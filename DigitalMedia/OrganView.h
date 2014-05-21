//
//  OrganView.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HappyMovieDelegate.h"
@protocol OrganViewDelegate <NSObject>
- (void)showLoadingDataAnimatial;
- (void)showLoadingDataFaliureAnimatial;
- (void)hideLoadingDataAnimatial;
@end

@interface OrganView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *menuTable;
@property (nonatomic,retain) NSArray *listData;
@property (nonatomic,assign) id<OrganViewDelegate> delegate;
@property (nonatomic,assign) id<HappyMovieDelegate> movieDelegate;
- (void)loadingDataSource;
@end
