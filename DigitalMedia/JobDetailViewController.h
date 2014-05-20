//
//  JobDetailViewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobEmployment.h"
@interface JobDetailViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) JobEmployment *Entity;
@property (nonatomic,strong) UITableView *menuTable;
@property (nonatomic,strong) NSMutableArray *cells;
@end
