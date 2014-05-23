//
//  JobTopView.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "JobTopView.h"

@interface JobTopView ()
@property (nonatomic,strong) UILabel *seperLine;
@end

@implementation JobTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorFromHexRGB:@"f0f0f0"];//[UIColor colorFromHexRGB:@"333333"];
        _leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitleColor:[UIColor colorFromHexRGB:@"20a0bb"] forState:UIControlStateNormal];
        _leftButton.titleLabel.font=[UIFont fontWithName:defaultDeviceFontName size:18];
        [_leftButton setTitle:@"職缺資訊" forState:UIControlStateNormal];
        _leftButton.showsTouchWhenHighlighted=YES;
        _leftButton.frame=CGRectMake(0, 0, frame.size.width/2, frame.size.height);
        [self addSubview:_leftButton];
        
        _labLine=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-4, frame.size.width/2, 4)];
        _labLine.backgroundColor=[UIColor colorFromHexRGB:@"20a0bb"];
        [self addSubview:_labLine];
        
        _rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitleColor:[UIColor colorFromHexRGB:@"20a0bb"] forState:UIControlStateNormal];
        _rightButton.titleLabel.font=[UIFont fontWithName:defaultDeviceFontName size:18];
        [_rightButton setTitle:@"求材活動資訊" forState:UIControlStateNormal];
        _rightButton.showsTouchWhenHighlighted=YES;
        _rightButton.frame=CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height);
        [self addSubview:_rightButton];
        
        _seperLine=[[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-1)/2,0,1,frame.size.height-4)];
        _seperLine.backgroundColor=[UIColor whiteColor];
        [self addSubview:_seperLine];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
