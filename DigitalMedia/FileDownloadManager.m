//
//  FileDownloadManager.m
//  MediaCenter
//
//  Created by aJia on 13/1/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "FileDownloadManager.h"
#import "FileHelper.h"
#import "PreviewFileManager.h"
#import "AppHelper.h"
#import "NSDate+TPCategory.h"
#import "MovieStore.h"
#import "MovieStoreHelper.h"
#import "AlertHelper.h"
@implementation FileDownloadManager
+(FileDownloadManager *)shareInitialization{
    static dispatch_once_t  onceToken;
    static FileDownloadManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[FileDownloadManager alloc] init];
    });
    return sSharedInstance;
}
//fileName文件保存的完整路径
-(void)downloadFile:(NSString*)url path:(NSString*)fileName withEntity:(MovieStore*)entity{
    NSFileManager *fileManger=[NSFileManager defaultManager];
    if ([fileManger fileExistsAtPath:fileName]) {
        //删除文件
        [FileHelper deleteFileWithPath:fileName];
    }
    
    self.Entity=entity;
    DownLoadArgs *args=[[DownLoadArgs alloc] init];
    args.downloadUrl=url;
    args.downloadFileName=[fileName lastPathComponent];
    args.fileSavePath=DownFileFolderPath;

    [[PreviewFileManager sharedInstance] startBlockDownLoadFile:args progress:nil finishDownload:^(NSString *filePath){
        [self downloadManagerDataDownloadFinished:filePath];
    
    } failedDownload:^(NSError *error){
        [AlertHelper initWithTitle:@"提示" message:@"文件下載失敗!"];
    }];

}
#pragma mark -
#pragma mark filedown delegate Methods
//文件下载完成
- (void) downloadManagerDataDownloadFinished: (NSString *) fileName
{
    [AppHelper addNoBackupAttribute:[NSURL fileURLWithPath:fileName]];
    if (self.Entity) {
        self.Entity.Date=[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm"];
        
         MovieStoreHelper *helper=[[MovieStoreHelper alloc] init];
        [helper addStore:self.Entity];
    }
}
//发送下载完成的本地通知
-(void)sendLocationNotice:(NSString*)guid{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:10];//10秒后通知
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        NSString *name=[[guid lastPathComponent] stringByDeletingPathExtension];
        notification.alertBody=[NSString stringWithFormat:@"%@下載完成",name];//提示信息 弹出提示框
        
         NSDictionary *infoDict = [NSDictionary dictionaryWithObject:guid forKey:@"path"];
        notification.userInfo = infoDict; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
}
@end
