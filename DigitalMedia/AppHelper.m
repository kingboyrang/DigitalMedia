//
//  AppHelper.m
//  MediaCenter
//
//  Created by aJia on 12/11/12.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "AppHelper.h"
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
@end
