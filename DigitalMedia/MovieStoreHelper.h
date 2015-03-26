//
//  MovieStoreHelper.h
//  DigitalMedia
//
//  Created by aJia on 2014/6/30.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kNotificationMovieFinishedUpdate @"kNotificationMovieFinishedUpdate"

@class MovieStore;
@interface MovieStoreHelper : NSObject
//取得收藏影音列表
- (NSMutableArray*)storeMovies;
- (BOOL)existsFileName:(NSString*)name;
- (void)addStore:(MovieStore*)entity;
- (void)deleteStoreWithRow:(NSInteger)index;
-(void)saveWithSources:(NSArray*)sources;
- (void)reloadData;
@end
