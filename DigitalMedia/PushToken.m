//
//  PushToken.m
//  Eland
//
//  Created by aJia on 13/10/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "PushToken.h"
#import "SRMNetworkEngine.h"
#import "ApnsToken.h"
@implementation PushToken
-(NSString*)XmlSerialize{
    NSMutableString *xml=[NSMutableString stringWithFormat:@"<?xml version=\"1.0\"?>"];
    [xml appendString:@"<PushToken xmlns=\"PushToken\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"];
    
    [xml appendFormat:@"<GUID>%@</GUID>",[self getPropertyValue:_GUID]];
    [xml appendFormat:@"<UniqueCode>%@</UniqueCode>",[self getPropertyValue:_UniqueCode]];
    [xml appendFormat:@"<AppCode>%@</AppCode>",[self getPropertyValue:_AppCode]];
    [xml appendFormat:@"<AppName>%@</AppName>",[self getPropertyValue:_AppName]];
    [xml appendFormat:@"<AppType>%@</AppType>",[self getPropertyValue:_AppType]];
    [xml appendFormat:@"<Flatbed>%@</Flatbed>",[self getPropertyValue:_Flatbed]];
    [xml appendString:@"</PushToken>"];
     NSString  *result=[xml stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    result=[result stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return result;
}
+(void)registerToken{
    ApnsToken *apns=[ApnsToken unarchiverApnsToken];
    if (apns.AppToken&&[apns.AppToken length]>0) {
        PushToken *push=[[PushToken alloc] init];
        push.GUID=apns.AppToken;
        push.UniqueCode=apns.UID;
        push.AppCode=@"ios.app.com.eland2.media";
        push.AppName=@"IOS數位媒體";
        push.AppType=@"ios";
        push.Flatbed=UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?@"1":@"2";
        
        ServiceArgs *args=[[ServiceArgs alloc] init];
        args.serviceURL=PushWebServiceUrl;
        args.serviceNameSpace=PushWebServiceNameSpace;
        args.methodName=@"Register";
        args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[push XmlSerialize],@"xml", nil], nil];
        
        SRMNetworkEngine *engine=[[SRMNetworkEngine alloc] initWithHostName:args.hostName];
        [engine requestWithArgs:args success:^(MKNetworkOperation *completedOperation) {
            
        } failure:^(MKNetworkOperation *completedOperation, NSError *error) {
            
        }];
    }
}
-(NSString*)getPropertyValue:(NSString*)field{
    if (field==nil||[field length]==0) {
        return @"";
    }
    return field;
}
@end
