//
//  AppHelper.m
//  MediaCenter
//
//  Created by aJia on 12/11/12.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "AppHelper.h"
#import "SRMNetworkEngine.h"
#import "XmlParseHelper.h"
#import "AdminURL.h"
#import "PushToken.h"
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
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.serviceURL=DataAccessURL;
    args.httpWay=ServiceHttpPost;
    
    SRMNetworkEngine *engine=[[SRMNetworkEngine alloc] initWithHostName:args.hostName];
    [engine requestWithArgs:args success:^(MKNetworkOperation *completedOperation) {
        NSString *xml=[completedOperation.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"AdminURL[]\"" withString:@""];
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
        
        
        
    } failure:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"error=%@",error.description);
    }];
}
@end
