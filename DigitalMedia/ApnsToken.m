//
//  ApnsToken.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ApnsToken.h"
#import "FileHelper.h"
@implementation ApnsToken
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.AppToken forKey:@"AppToken"];
    [encoder encodeBool:self.flags forKey:@"flags"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.AppToken=[aDecoder decodeObjectForKey:@"AppToken"];
        self.flags=[aDecoder decodeBoolForKey:@"flags"];
       
    }
    return self;
}
+(ApnsToken*)unarchiverApnsToken{
    NSString *path=[DocumentPath stringByAppendingPathComponent:@"Account.db"];
    if(![FileHelper existsFilePath:path]){ //如果不存在
        ApnsToken *acc=[[ApnsToken alloc] init];
        acc.AppToken=@"";
        acc.flags=NO;
        return acc;
    }
    return (ApnsToken*)[NSKeyedUnarchiver unarchiveObjectWithFile: path];
}
//儲存
-(void)save{
    NSString *path=[DocumentPath stringByAppendingPathComponent:@"ApnsToken.db"];
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}
@end
