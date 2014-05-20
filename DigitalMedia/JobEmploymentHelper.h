//
//  JobEmploymentHelper.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JobEmployment.h"
#import "DataPager.h"
#import "ASIServiceArgs.h"
@interface JobEmploymentHelper : NSObject
@property (nonatomic,retain) DataPager *pager;
@property (nonatomic,readonly) ASIServiceArgs *searchArgs;
@property (nonatomic,readonly) NSString *methodName;
@property (nonatomic,readonly) NSString *searchXpath;
@property (nonatomic,assign) int operType;
- (NSArray*)xmlSerializationWithXml:(NSString*)xml;
@end
