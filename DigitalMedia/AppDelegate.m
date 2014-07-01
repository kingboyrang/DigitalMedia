//
//  AppDelegate.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/15.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "AppDelegate.h"
#import "BasicTabBarController.h"
#import "AppHelper.h"
#import "ApnsToken.h"
#import "PushToken.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //向apns注册
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    //更新访问接口
    [AppHelper updateAccess];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    BasicTabBarController *tabbar=[[BasicTabBarController alloc] init];
    self.window.rootViewController=tabbar;
    [self.window makeKeyAndVisible];
    
    //处理远程通知
    UILocalNotification *localNotif=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (localNotif) {
        application.applicationIconBadgeNumber-=1;
        [self pushHandler:localNotif.userInfo];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - APNS 回傳結果
// 成功取得設備編號token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceId = [[deviceToken description]
                          substringWithRange:NSMakeRange(1, [[deviceToken description] length]-2)];
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceId = [deviceId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    ApnsToken *apns=[ApnsToken unarchiverApnsToken];
    if (![apns.AppToken isEqualToString:deviceId]) {
        apns.AppToken=deviceId;
        [apns save];
    }
    //注册推送
    [PushToken registerToken];
    
}
//获取接收的推播信息
- (void) application:(UIApplication *) app didReceiveRemoteNotification:(NSDictionary *) userInfo
{
    app.applicationIconBadgeNumber-=1;
    [self pushHandler:userInfo];
}

// 或無法取得設備編號token
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //表示信息推播失败
}
//推播处理
-(void)pushHandler:(NSDictionary*)userInfo{
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=nil) {
        NSString *post=[userInfo objectForKey:@"guid"];
        NSDictionary  *dic=[NSDictionary dictionaryWithObjectsAndKeys:post,@"guid", nil];
        
        NSNotification *notification = [NSNotification notificationWithName:@"pushDetail" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
    }
}
@end
