//
//  TKJobCell.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKJobCell.h"

@implementation TKJobCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    _labTitle=[[UILabel alloc] initWithFrame:CGRectZero];
    _labTitle.backgroundColor=[UIColor clearColor];
    _labTitle.font=defaultBDeviceFont;
    _labTitle.textColor=[UIColor blackColor];
    _labTitle.numberOfLines=0;
    _labTitle.lineBreakMode=NSLineBreakByWordWrapping;
    [self.contentView addSubview:_labTitle];
    
    _labDate=[[UILabel alloc] initWithFrame:CGRectZero];
    _labDate.backgroundColor=[UIColor clearColor];
    _labDate.font=defaultSDeviceFont;
    _labDate.textColor=[UIColor grayColor];
    _labDate.numberOfLines=0;
    _labDate.lineBreakMode=NSLineBreakByWordWrapping;
    [self.contentView addSubview:_labDate];
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat leftX=5,top=4;
    CGSize size=[_labTitle.text textSize:_labTitle.font withWidth:self.frame.size.width-leftX-15];
    _labTitle.frame=CGRectMake(leftX, 8, size.width, size.height);
    size=[_labDate.text textSize:_labDate.font withWidth:self.frame.size.width-leftX-15];
    _labDate.frame=CGRectMake(leftX, _labTitle.frame.origin.y+_labTitle.frame.size.height+top, size.width, size.height);
    
    NSLog(@"h=%f",_labDate.frame.origin.y+_labDate.frame.size.height+_labTitle.frame.origin.y);
}

@end
