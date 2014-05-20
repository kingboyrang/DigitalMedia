//
//  JobAreaList.h
//  MediaCenter
//
//  Created by aJia on 13/9/25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "JobEmploymentHelper.h"

@protocol JobAreaDelegate <NSObject>
- (void)showLoadFailure;
- (void)showNetWorkError;
- (void)selectedItemWithEntity:(JobEmployment*)entity;
@end

@interface JobAreaList : UIView<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) JobEmploymentHelper *jobHelper;
@property(nonatomic,strong) PullingRefreshTableView *jobTable;
@property(nonatomic,assign) int jobType;
@property (nonatomic) BOOL refreshing;
@property(nonatomic,retain) NSMutableArray *sourceData;
@property(nonatomic,assign) id<JobAreaDelegate> delegate;
-(void)loadingData;
@end
