//
//  TKMetaDataCell.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKMetaDataCell.h"

@implementation TKMetaDataCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    _labTitle=[[UILabel alloc] initWithFrame:CGRectZero];
    _labTitle.backgroundColor=[UIColor clearColor];
    _labTitle.font=defaultBDeviceFont;
    _labTitle.textColor=[UIColor blackColor];
    [self.contentView addSubview:_labTitle];
    
    _labCategory=[[UILabel alloc] initWithFrame:CGRectZero];
    _labCategory.backgroundColor=[UIColor clearColor];
    _labCategory.font=defaultSmallFont;
    _labCategory.textColor=[UIColor grayColor];
    [self.contentView addSubview:_labCategory];
    
    _labUnit=[[UILabel alloc] initWithFrame:CGRectZero];
    _labUnit.backgroundColor=[UIColor clearColor];
    _labUnit.font=defaultSmallFont;
    _labUnit.textColor=[UIColor grayColor];
    [self.contentView addSubview:_labUnit];
    
    _labDate=[[UILabel alloc] initWithFrame:CGRectZero];
    _labDate.backgroundColor=[UIColor clearColor];
    _labDate.font=[UIFont boldSystemFontOfSize:14];
    _labDate.textColor=[UIColor blueColor];
    [self.contentView addSubview:_labDate];
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat leftX=5,w=self.frame.size.width-leftX-20,top=5;
    NSString *title=@"我们";
    CGSize size=[title textSize:_labTitle.font withWidth:w];
    _labTitle.frame=CGRectMake(leftX, 8, w, size.height);

    
    size=[_labCategory.text textSize:_labCategory.font withWidth:self.frame.size.width-5-10];
    _labCategory.frame=CGRectMake(leftX, _labTitle.frame.origin.y+_labTitle.frame.size.height+top, size.width, size.height);
    
    size=[_labUnit.text textSize:_labUnit.font withWidth:self.frame.size.width-5-10];
    _labUnit.frame=CGRectMake(leftX, _labCategory.frame.origin.y+_labCategory.frame.size.height+top, size.width, size.height);
    
    size=[_labDate.text textSize:_labDate.font withWidth:self.frame.size.width-5-10];
    _labDate.frame=CGRectMake(self.frame.size.width-size.width-25,(self.frame.size.height-size.height)/2, size.width, size.height);
    
    CGRect r=_labTitle.frame;
    r.size.width=_labDate.frame.origin.x-2-leftX;
    _labTitle.frame=r;
    
    r=_labCategory.frame;
    r.size.width=_labDate.frame.origin.x-2-leftX;
    _labCategory.frame=r;
}
@end
