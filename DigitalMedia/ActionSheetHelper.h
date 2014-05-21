//
//  ActionSheetHelper.h
//  HsinchuElderly
//
//  Created by aJia on 2014/5/12.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionSheetHelper : NSObject
+(void)showSheetInView:(UIView*)view cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction;
+(void)showSheetInView:(UIView*)view confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction;
+(void)showSheetInView:(UIView*)view actions:(NSArray*)actions;
@end
