//
//  HappyMoviewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "SearchMetaDataHelper.h"
@interface HappyMoviewController : BasicViewController<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain) SearchMetaDataHelper *metaHelper;
@property (nonatomic,strong) PullingRefreshTableView *refrshTable;
@property (nonatomic) BOOL refreshing;
@property(nonatomic,copy) NSString *keyWord;
@property(nonatomic,retain) NSMutableArray *listData;

@property (nonatomic,retain) UIScrollView *happySrcollView;
@end
