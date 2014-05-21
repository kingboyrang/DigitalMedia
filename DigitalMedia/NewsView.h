//
//  NewsView.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "WebNewsHelper.h"

@protocol NewsViewDelegate <NSObject>
- (void)showNetworkError:(id)sender;
- (void)showLoadingFailureError:(id)sender;
- (void)selectedItemWithType:(int)type model:(WebNews*)entity sender:(id)sender;
@end

@interface NewsView : UIView<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) WebNewsHelper *newsHelper;
@property(nonatomic,retain) PullingRefreshTableView *newsTable;
@property (nonatomic) BOOL refreshing;
@property(nonatomic,retain) NSMutableArray *sourceData;
@property(nonatomic,assign) id<NewsViewDelegate> delegate;
-(void)loadingData;
@end
