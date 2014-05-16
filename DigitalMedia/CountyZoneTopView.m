//
//  CountyZoneTopView.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "CountyZoneTopView.h"
#import "AppHelper.h"
@implementation CountyZoneTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorFromHexRGB:@"5094a8"];
        UIImage *img1=[UIImage imageNamed:@"facebook.png"];
        UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame=CGRectMake(frame.size.width-img1.size.width*2-15, 0, img1.size.width, img1.size.height);
        [btn1 setImage:img1 forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(buttonFacebookClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
        
        UIImage *img2=[UIImage imageNamed:@"plurk.png"];
        UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame=CGRectMake(frame.size.width-img2.size.width-5, 0, img2.size.width, img2.size.height);
        [btn2 setImage:img2 forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(buttonPlurkClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn2];
    }
    return self;
}
//facebook
- (void)buttonFacebookClick:(UIButton*)btn{
    [AppHelper openUrl:CountyZoneFacebookURL];
}
//plurk
- (void)buttonPlurkClick:(UIButton*)btn{
    [AppHelper openUrl:CountyZonePlurkURL];
}
@end
