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
//資料別 1:圖片； 2：影音；3：聲音；4：檔案
- (NSString*)dataTypeName{
    NSString *result=@"圖片";
    switch ([self.DTYPE intValue]) {
        case 2:
            result=@"影音";
            break;
        case 3:
            result=@"聲音";
            break;
        case 4:
            result=@"檔案";
            break;
        default:
            break;
    }
    return result;
}
@end
