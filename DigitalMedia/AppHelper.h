//
//  AppHelper.h
//  MediaCenter
//
//  Created by aJia on 12/11/12.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/xattr.h>
@interface AppHelper : NSObject
+ (void)openUrl:(NSString*)url;
+ (void)updateAccess;
+ (void)asyncPushWithComplete:(void(^)(NSArray *source))completed;
@end
