//
//  AppDelegate.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/15.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "AppDelegate.h"
#import "BasicTabBarController.h"
#import "SRMNetworkEngine.h"
#import "XmlParseHelper.h"
#import "AdminURL.h"
#import "PushToken.h"
@implementation AppDelegate

- (void)updateAccess{
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
                    
                }
            }
            [arr writeToFile:DataWebPath atomically:YES];
        }

        
        
    } failure:^(MKNetworkOperation *completedOperation, NSError *error) {
         NSLog(@"error=%@",error.description);
    }];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self updateAccess];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    BasicTabBarController *tabbar=[[BasicTabBarController alloc] init];
    self.window.rootViewController=tabbar;
    [self.window makeKeyAndVisible];
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

@end
