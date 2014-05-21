//
//  WebNews.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "WebNews.h"

@implementation WebNews
- (NSString*)formatDateText{
    if (_Date&&[_Date length]>0) {
        return [_Date substringWithRange:NSMakeRange(0, 10)];
    }
    return @"";
}
@end
