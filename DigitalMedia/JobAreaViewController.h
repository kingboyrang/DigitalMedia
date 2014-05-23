//
//  JobAreaViewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightMenuBar.h"
#import "LightMenuBarDelegate.h"
@interface JobAreaViewController : BasicViewController<LightMenuBarDelegate>
@property (nonatomic,retain) LightMenuBar *menuBar;
@end
