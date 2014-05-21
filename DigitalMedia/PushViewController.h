//
//  PushViewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) UITableView *pushTable;
@property(nonatomic,retain) NSMutableArray *listData;
@end
