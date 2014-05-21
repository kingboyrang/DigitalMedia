//
//  WebNews.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebNews : NSObject
@property (nonatomic,copy) NSString *PK;
@property (nonatomic,copy) NSString *Type;
@property (nonatomic,copy) NSString *Date;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,copy) NSString *DeptId;
@property (nonatomic,copy) NSString *DeptName;

@property (nonatomic,readonly) NSString *formatDateText;
@end
