//
//  SearchMetaData.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "SearchMetaData.h"

@implementation SearchMetaData
- (NSString*)formatDateText{
    if (_REG_DATE&&[_REG_DATE length]>0) {
        if ([_REG_DATE length]>=10) {
            return [_REG_DATE substringWithRange:NSMakeRange(0, 10)];
        }else{
            return _REG_DATE;
        }
    }
    return @"";
}
@end
