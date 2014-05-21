//
//  HappyElandView.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HappyMovieDelegate.h"
@interface HappyElandView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *happyTable;
@property (nonatomic,retain) NSArray *listData;
@property (nonatomic,assign) id<HappyMovieDelegate> delegate;
- (void)loadingDataSource;
@end
