//
//  TKMenuItemCell.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKMenuItemCell.h"

@implementation TKMenuItemCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    _leftMenuItem=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_leftMenuItem];
    
    _leftLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _leftLabel.backgroundColor=[UIColor clearColor];
    _leftLabel.textAlignment=NSTextAlignmentCenter;
    _leftLabel.font=defaultBDeviceFont;
    [self.contentView addSubview:_leftLabel];
    
    _rightMenuItem=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_rightMenuItem];
    
    _rightLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _rightLabel.backgroundColor=[UIColor clearColor];
    _rightLabel.textAlignment=NSTextAlignmentCenter;
    _rightLabel.font=defaultBDeviceFont;
    [self.contentView addSubview:_rightLabel];
    //12 85
	return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseIdentifier];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat h=DeviceIsPad?256.0f:128.0f;
    //CGFloat leftX=DeviceIsPad?85.0f:(self.frame.size.width-h*2)/3;
    CGFloat leftX=(self.frame.size.width-h*2)/3;
    CGRect r=_leftMenuItem.frame;
    r.origin.x=leftX;
    r.origin.y=0;
    r.size=CGSizeMake(h, h);
    _leftMenuItem.frame=r;
    
    CGSize size=[_leftLabel.text textSize:defaultBDeviceFont withWidth:self.frame.size.width];
    _leftLabel.frame=CGRectMake(r.origin.x+r.size.width/2-size.width/2, r.origin.y+r.size.height+5, size.width, size.height);
    
    
    leftX=r.origin.x+r.size.width;
    r.origin.x=leftX+(self.frame.size.width-leftX*2);
    _rightMenuItem.frame=r;
    
     size=[_rightLabel.text textSize:defaultBDeviceFont withWidth:self.frame.size.width];
     _rightLabel.frame=CGRectMake(_rightMenuItem.frame.origin.x+_rightMenuItem.frame.size.width/2-size.width/2, _leftLabel.frame.origin.y,size.width, size.height);
    
    
}

@end
