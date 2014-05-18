//
//  CountyZoneViewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface CountyZoneViewController : BasicViewController<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    int curPage;
    int pageSize;
    int maxPage;
}
@property (nonatomic,strong) PullingRefreshTableView *refrshTable;
@property (nonatomic) BOOL refreshing;
@property(nonatomic,retain) NSString *keyWord;
@property(nonatomic,retain) NSMutableArray *listData;
@end
