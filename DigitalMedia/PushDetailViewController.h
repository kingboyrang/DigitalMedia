//
//  PushDetailViewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushResult.h"
@interface PushDetailViewController : BasicViewController
-(void)loadPushDetail:(NSString*)guid;
@property(nonatomic,strong) PushResult *Entity;
@end
