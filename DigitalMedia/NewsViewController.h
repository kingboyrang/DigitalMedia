//
//  NewsViewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightMenuBar.h"
#import "LightMenuBarDelegate.h"
@interface NewsViewController : BasicViewController<LightMenuBarDelegate,UIScrollViewDelegate>
@property (nonatomic,retain) LightMenuBar *menuBar;
@property (nonatomic,retain) UIScrollView *newsScrollView;
@end
