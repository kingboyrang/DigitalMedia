//
//  OrgenMovieViewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Department;
@interface OrgenMovieViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *menuTable;
@property (nonatomic,retain) Department *Entity;
@property(nonatomic,retain)  NSArray *listData;
@end
