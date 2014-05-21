//
//  HotMovieView.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "SearchMetaDataHelper.h"
#import "HappyMovieDelegate.h"
@interface HotMovieView : UIView<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) SearchMetaDataHelper *metaHelper;
@property (nonatomic,strong) PullingRefreshTableView *refrshTable;
@property (nonatomic) BOOL refreshing;
@property(nonatomic,retain) NSString *keyWord;
@property(nonatomic,retain) NSMutableArray *listData;
@property (nonatomic,assign) id<HappyMovieDelegate> delegate;
- (void)loadingDataSource;
@end
