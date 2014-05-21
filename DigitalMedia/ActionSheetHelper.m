//
//  ActionSheetHelper.m
//  HsinchuElderly
//
//  Created by aJia on 2014/5/12.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ActionSheetHelper.h"
#import "RIButtonItem.h"
#import "UIActionSheet+Blocks.h"
@implementation ActionSheetHelper
+(void)showSheetInView:(UIView*)view cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction{
    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=cancelTitle;
    canBtn.action=cancelAction;
    
    RIButtonItem *viewerBtn=[RIButtonItem item];
    viewerBtn.label=confirmTitle;
    viewerBtn.action=confirmAction;
    
   
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:canBtn destructiveButtonItem:nil otherButtonItems:viewerBtn, nil];
    [sheet showInView:view];
}
+(void)showSheetInView:(UIView*)view confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction{
    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=@"取消";
    canBtn.action=nil;
    
    RIButtonItem *viewerBtn=[RIButtonItem item];
    viewerBtn.label=confirmTitle;
    viewerBtn.action=confirmAction;
    
    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:canBtn destructiveButtonItem:nil otherButtonItems:viewerBtn, nil];
    [sheet showInView:view];
}
+(void)showSheetInView:(UIView*)view actions:(NSArray*)actions{
    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=@"取消";
    canBtn.action=nil;
    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:nil destructiveButtonItem:nil otherButtonItems:nil, nil];
    for (RIButtonItem *item in actions) {
        [sheet addButtonItem:item];
    }
    [sheet addButtonItem:canBtn];
    [sheet showInView:view];
}
@end
