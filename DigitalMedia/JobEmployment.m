//
//  JobEmployment.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "JobEmployment.h"

@implementation JobEmployment
-(NSString*)detailText{
    NSMutableString *msg=[NSMutableString stringWithFormat:@"類別:%@",[self Category]];
    [msg appendFormat:@"\n日期:%@",[self Date]];
    return msg;
}
- (NSString*)getCellValueWithType:(int)type{
    if (type==1) {
        return [self JobName];
    }
    return [self Name];
}
@end
