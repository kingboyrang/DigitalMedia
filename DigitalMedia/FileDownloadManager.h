//
//  FileDownloadManager.h
//  MediaCenter
//
//  Created by aJia on 13/1/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MovieStore;
@interface FileDownloadManager : NSObject
@property(nonatomic,retain)  MovieStore *Entity;
+(FileDownloadManager *)shareInitialization;

-(void)downloadFile:(NSString*)url path:(NSString*)fileName withEntity:(MovieStore*)entity;
//发送下载完成的本地通知
-(void)sendLocationNotice:(NSString*)guid;
-(void)downloadManagerDataDownloadFinished:(NSString *)fileName;
@end
