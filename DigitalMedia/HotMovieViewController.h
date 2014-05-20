//
//  HotMovieViewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "SearchMetaDataHelper.h"
@interface HotMovieViewController : BasicViewController<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain) SearchMetaDataHelper *metaHelper;
@property (nonatomic,strong) PullingRefreshTableView *refrshTable;
@property (nonatomic) BOOL refreshing;
@property(nonatomic,retain) NSString *keyWord;
@property(nonatomic,retain) NSMutableArray *listData;

@end
