//
//  DMSearchBar.h
//  DigitalMedia
//
//  Created by rang on 14-5-19.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSearchBar : UISearchBar
@property (nonatomic,readonly) UITextField *searchField;
//移除背景色
- (void)removeBackgroud;
//设置取消按钮文字
- (void)setCancelButtonWithTitle:(NSString*)title;
- (void)setCancelButtonDefaultTitle;
@end
