//
//  SearchMetaDataHelper.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchMetaData.h"
#import "DataPager.h"
@interface SearchMetaDataHelper : NSObject
@property (nonatomic,retain) DataPager *pager;
- (NSArray*)xmlSerializationWithXml:(NSString*)xml;
@end
