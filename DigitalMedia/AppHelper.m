//
//  AppHelper.m
//  MediaCenter
//
//  Created by aJia on 12/11/12.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "AppHelper.h"
#import "ASIServiceArgs.h"
#import "XmlParseHelper.h"
#import "AdminURL.h"
#import "PushToken.h"
#import "ASIServiceHTTPRequest.h"
#import "ApnsToken.h"
#import "CacheHelper.h"
@implementation AppHelper

/***页面跳转****/
+(void)openUrl:(NSString*)skipUrl{
    NSString *encodedString=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                   (CFStringRef)skipUrl,
                                                                                                   NULL,
                                                                                                   NULL,
                                                                                                   kCFStringEncodingUTF8));

    NSURL *url=[NSURL URLWithString:encodedString];
    [[UIApplication sharedApplication] openURL:url];
}
+ (void)updateAccess{
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.serviceURL=DataAccessURL;
    args.httpWay=ASIServiceHttpPost;
    
    ASIHTTPRequest *engine=[args request];
    [engine setCompletionBlock:^{
        if (engine.responseStatusCode==200) {
            NSString *xml=[engine.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"AdminURL[]\"" withString:@""];
            XmlParseHelper *parse=[[XmlParseHelper alloc] initWithData:xml];
            NSArray *source=[parse selectNodes:@"//AdminURL" className:@"AdminURL"];
            NSMutableArray *arr=[NSMutableArray arrayWithArray:DataServicesSource];
            
            if (source&&[source count]>0) {
                NSString *url2=@"";
                for (AdminURL *item in source) {
                    if ([item.name isEqualToString:@"elandmcwebserviceurl"]&&[item.url length]>0) {
                        arr[0]=[item.url Trim];
                    }
                    if ([item.name isEqualToString:@"pushsadminurl"]&&[item.url length]>0) {
                        url2=[item.url Trim];
                    }
                }
                if ([url2 length]>0) {
                    if (![url2 isEqualToString:arr[1]]) {
                        arr[1]=url2;
                        //重新注册
                        [PushToken registerToken];
                    }
                }
                [arr writeToFile:DataWebPath atomically:YES];
            }
        }
    }];
    [engine setFailedBlock:^{
        
    }];
    [engine startAsynchronous];
}
+ (void)asyncPushWithComplete:(void(^)(NSArray *source))completed{
    ApnsToken *app=[ApnsToken unarchiverApnsToken];
    if (app.AppToken&&[app.AppToken length]>0) {
        ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
        args.serviceURL=PushWebServiceUrl;
        args.serviceNameSpace=PushWebServiceNameSpace;
        args.methodName=@"GetMessages";
        args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:app.AppToken,@"token", nil], nil];
        ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
        [request success:^{
            XmlNode *node=[request.ServiceResult methodNode];
            if (node) {
                 NSString *xml=[node.InnerText stringByReplacingOccurrencesOfString:@"xmlns=\"Push[]\"" withString:@""];
                [request.ServiceResult.xmlParse setDataSource:xml];
                NSArray *arr=[request.ServiceResult.xmlParse selectNodes:@"//Push" className:@"PushResult"];
                if (arr&&[arr count]>0) {
                    [CacheHelper cacheCasePushArray:arr];
                    if (completed) {
                        completed(arr);
                    }
                }
            }
        } failure:^{
            
        }];
    }
}

//表示下载的文件不同步到iCloud and iTunes里面
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
//表示下载的文件不同步到iCloud and iTunes里面 for 5.0.1 以前
+(BOOL)addSkipBackupAttributeToItemAtURL5:(NSURL *)URL{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}
+(void)addNoBackupAttribute:(NSURL *)URL{
    float fVersion=[[[UIDevice currentDevice] systemVersion] floatValue];
    if (fVersion < 5.1) {
        [self addSkipBackupAttributeToItemAtURL5:URL];
    }else{
        [self addSkipBackupAttributeToItemAtURL:URL];
    }
}

@end
