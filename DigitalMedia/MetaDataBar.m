//
//  MetaDataBar.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/23.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MetaDataBar.h"
#import "UIImage+TPCategory.h"

@interface MetaDataBar ()
@property (nonatomic,retain) UILabel *lineLab;
@end

@implementation MetaDataBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat h=35,btnLeft=15;
        //資料介紹 檔案下載
        self.backgroundColor=[UIColor colorFromHexRGB:@"f0f0f0"];
        UIImage *img=[UIImage imageNamed:@"back_normal.png"];
        _leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame=CGRectMake(btnLeft,(frame.size.height-img.size.height)/2, img.size.width, img.size.height);
        [_leftButton setImage:img forState:UIControlStateNormal];
        [self addSubview:_leftButton];
        
        UIImage *img1=[UIImage imageNamed:@"arrowRight.png"];
        _rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame=CGRectMake(frame.size.width-img.size.width-btnLeft,(frame.size.height-img1.size.height)/2, img1.size.width, img1.size.height);
        [_rightButton setImage:img1 forState:UIControlStateNormal];
        [self addSubview:_rightButton];
        
        CGFloat leftX=_leftButton.frame.origin.x+_leftButton.frame.size.width+btnLeft;
        CGFloat w=(frame.size.width-leftX*2)/2;
        
        UIImage *bgImg=[UIImage createImageWithColor:[UIColor colorFromHexRGB:defaultButtonBgColor] imageSize:CGSizeMake(70, h)];
        UIImage *corImg=[UIImage createRoundedRectImage:bgImg size:bgImg.size radius:5];
        UIImage *leftImg=[corImg imageAtRect:CGRectMake(0, 0, 60, h)];
        leftImg=[leftImg stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        _dataButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _dataButton.frame=CGRectMake(leftX,(frame.size.height-leftImg.size.height)/2, w, leftImg.size.height);
        [_dataButton setTitle:@"資料介紹" forState:UIControlStateNormal];
        [_dataButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _dataButton.titleLabel.font=defaultBDeviceFont;
        [_dataButton setBackgroundImage:leftImg forState:UIControlStateNormal];
        [self addSubview:_dataButton];
        
        
        leftX=_dataButton.frame.origin.x+_dataButton.frame.size.width;
        UIImage *rightImg=[leftImg imageRotatedByDegrees:180];
        rightImg=[rightImg stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        _fileButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _fileButton.frame=CGRectMake(leftX,(frame.size.height-rightImg.size.height)/2, w, rightImg.size.height);
        [_fileButton setTitle:@"檔案下載" forState:UIControlStateNormal];
        [_fileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fileButton setBackgroundImage:rightImg forState:UIControlStateNormal];
         _fileButton.titleLabel.font=defaultBDeviceFont;
        [self addSubview:_fileButton];
        
        _lineLab=[[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-2)/2,(frame.size.height-h)/2, 2, h)];
        _lineLab.backgroundColor=[UIColor whiteColor];
        [self addSubview:_lineLab];
        
    }
    return self;
}
@end
