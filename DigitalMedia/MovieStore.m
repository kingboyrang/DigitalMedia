//
//  MovieStore.m
//  DigitalMedia
//
//  Created by aJia on 2014/6/30.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MovieStore.h"

@implementation MovieStore
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.Guid forKey:@"Guid"];
    [encoder encodeObject:self.Name forKey:@"Name"];
    [encoder encodeObject:self.Date forKey:@"Date"];
    [encoder encodeObject:self.Dept forKey:@"Dept"];
    [encoder encodeObject:self.DTYPE forKey:@"DTYPE"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.Guid=[aDecoder decodeObjectForKey:@"Guid"];
        self.Name=[aDecoder decodeObjectForKey:@"Name"];
        self.Date=[aDecoder decodeObjectForKey:@"Date"];
        self.Dept=[aDecoder decodeObjectForKey:@"Dept"];
        self.DTYPE=[aDecoder decodeObjectForKey:@"DTYPE"];
        
    }
    return self;
}
- (NSString*)TypeName{
    if (_DTYPE&&[_DTYPE isEqualToString:@"1"]) {
        return @"圖片";
    }
    if (_DTYPE&&[_DTYPE isEqualToString:@"2"]) {
        return @"影音";
    }
    if (_DTYPE&&[_DTYPE isEqualToString:@"3"]) {
        return @"聲音";
    }
    return @"檔案";
}
- (NSString*)path{
    if (_Name&&[_Name length]>0) {
        return [DownFileFolderPath stringByAppendingPathComponent:_Name];
    }
    return @"";
}
@end
