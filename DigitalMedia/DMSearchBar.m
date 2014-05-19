//
//  DMSearchBar.m
//  DigitalMedia
//
//  Created by rang on 14-5-19.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "DMSearchBar.h"
#import "UIImage+TPCategory.h"
@interface DMSearchBar ()
@property(nonatomic,strong) UITextField *searchTextField;
@end

@implementation DMSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder=@"輸入關鍵字";
    }
    return self;
}
- (UITextField*)searchField{
    if (!self.searchTextField) {
        for (UIView *subview in self.subviews)
        {
            if ([subview isKindOfClass:[UITextField class]])
            {
                self.searchTextField=(UITextField*)subview;
                break;
            }
        }
        if (IOSVersion>=7.0) {
            UIView *searchV = [[self subviews] lastObject];
            for (id v in searchV.subviews) {
                if ([v isKindOfClass:[UITextField class]])
                {
                    self.searchTextField=(UITextField*)v;
                    break;
                }
            }
        }
    }
    return self.searchTextField;
}
- (void)removeBackgroud{
    // for ios 6,7
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            self.backgroundColor=[UIColor clearColor];
            break;
        }
    }
    /***
    //for ios 7.1
    float  iosversion7_1 = 7.1 ;
    if (IOSVersion >= iosversion7_1)
    {
        //iOS7.1
        [[[[self.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        self.backgroundColor=[UIColor clearColor];
    }
     ***/
    
}
- (void)setCancelButtonWithTitle:(NSString*)title{
    self.showsCancelButton=YES;
    for (id cc in self.subviews) {
        // for ios 6
        if([cc isKindOfClass:[UIButton class]]){
            UIButton *btn=(UIButton *)cc;
            [btn setTitle:title forState:UIControlStateNormal];
            UIImage *img=[UIImage createImageWithColor:[UIColor colorFromHexRGB:@"5094a8"] imageSize:CGSizeMake(44, 35)];
            UIImage *roundImg=[UIImage createRoundedRectImage:img size:CGSizeMake(44, 35) radius:5];
            [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
            break;
        }
        // for ios 7
        if ([cc isKindOfClass:[UIView class]]) {
            UIView *v=(UIView*)cc;
            for (id item in v.subviews) {
                if([item isKindOfClass:[UIButton class]]){
                    UIButton *btn=(UIButton *)item;
                    [btn setTitle:title forState:UIControlStateNormal];
                    break;
                }
            }
        }
    }
}
- (void)setCancelButtonDefaultTitle{
    [self setCancelButtonWithTitle:@"取消"];
}
@end
