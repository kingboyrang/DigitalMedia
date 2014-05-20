//
//  TKDataDetailCell.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKDataDetailCell.h"

@implementation TKDataDetailCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _labName = [[UILabel alloc] initWithFrame:CGRectZero];
	_labName.backgroundColor = [UIColor clearColor];
    _labName.textAlignment = NSTextAlignmentRight;
    _labName.textColor = [UIColor blackColor];
    _labName.font = defaultBDeviceFont;
    _labName.numberOfLines=0;
    _labName.lineBreakMode=NSLineBreakByWordWrapping;
	[self.contentView addSubview:_labName];
    
    _labDetail = [[UILabel alloc] initWithFrame:CGRectZero];
	_labDetail.backgroundColor = [UIColor clearColor];
    _labDetail.textAlignment = NSTextAlignmentLeft;
    _labDetail.textColor = [UIColor blackColor];
    _labDetail.font = defaultBDeviceFont;
    _labDetail.numberOfLines=0;
    _labDetail.lineBreakMode=NSLineBreakByWordWrapping;
	[self.contentView addSubview:_labDetail];
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
	
	CGRect r = CGRectInset(self.contentView.bounds, 10, 10);
    r.origin.x=10;
    CGSize size=[_labName.text textSize:_labName.font withWidth:100];
    r.size=CGSizeMake(100, size.height);
    r.origin.y=(self.frame.size.height-size.height)/2;
	_labName.frame = r;
    
    CGFloat leftX=r.origin.x+r.size.width+2;
    CGFloat w=self.frame.size.width-leftX-10;
    size=[_labDetail.text textSize:_labDetail.font withWidth:w];
    _labDetail.frame=CGRectMake(leftX,(self.frame.size.height-size.height)/2, size.width, size.height);
}
@end
