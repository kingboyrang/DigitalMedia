//
//  DataPager.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPager : NSObject
@property (nonatomic) int Total;
@property (nonatomic) int PageCount;
@property (nonatomic) int CurPage;
@property (nonatomic) int PageSize;
@property (nonatomic) BOOL hasNextPage;//是否存在下一页
- (void)initParams;
- (void)loadNextPage;
@end
