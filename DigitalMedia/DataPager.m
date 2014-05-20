//
//  DataPager.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "DataPager.h"

@implementation DataPager
- (id)init{
    if (self=[super init]) {
        [self initParams];
    }
    return self;
}
- (BOOL)hasNextPage{
    if (self.PageCount>0&&self.CurPage==self.PageCount) {
        return NO;
    }
    return YES;
}
- (void)initParams{
    self.CurPage=0;
    self.PageSize=DeviceIsPad?20:10;
    self.PageCount=0;
}
- (void)loadNextPage{
    self.CurPage++;
    if (self.CurPage>=self.PageCount) {
        self.CurPage=self.PageCount;
    }
}
@end
