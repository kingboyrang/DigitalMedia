//
//  MovieScroll.h
//  MediaCenter
//
//  Created by aJia on 12/11/16.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SubMetaData.h"
#import "MovieDataSrcollDelegate.h"


@interface MovieScroll : UIView<UIScrollViewDelegate,UIWebViewDelegate>{
   int curPage;
   //MPMoviePlayerController *player;
    MPMoviePlayerViewController *moviePlayer;
    UIWebView *_webView;
}
@property(nonatomic,assign) id<MovieDataSrcollDelegate> delegate;
@property(nonatomic,retain)  UIScrollView *scrollView;
@property(nonatomic,retain)  NSArray *listData;
@property(nonatomic,retain)  NSArray *youtubeList;
@property(nonatomic,readonly)  int selectItemIndex;

-(id)initWithData:(NSArray*)arr frame:(CGRect)frame;
-(id)initWithData:(NSArray*)arr youtube:(NSArray*)youtu frame:(CGRect)frame;
-(void)loadConfigure:(CGRect)frame;
-(void)startMovie:(int)page;
//开始播放影片
-(void)preStartMovie;
//前一张影片
-(void)loadPrevMovie;
//后一张影片
-(void)loadNextMovie;
@end
