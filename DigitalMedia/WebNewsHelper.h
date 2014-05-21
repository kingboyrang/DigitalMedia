//
//  WebNewsHelper.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataPager.h"
#import "ASIServiceArgs.h"
#import "WebNews.h"
@interface WebNewsHelper : NSObject
@property (nonatomic,retain) DataPager *pager;
@property (nonatomic,readonly) ASIServiceArgs *searchArgs;
@property (nonatomic,assign) int operType;
- (NSArray*)xmlSerializationWithXml:(NSString*)xml;
@end
