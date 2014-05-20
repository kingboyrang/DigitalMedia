//
//  JobEmployment.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobEmployment : NSObject
@property (nonatomic,copy) NSString *PK;
/*******職缺資訊**********/
@property (nonatomic,copy) NSString *JobName;
@property (nonatomic,copy) NSString *WorkAddress;
/******求材活動資訊******/
@property (nonatomic,copy) NSString *Category;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *Date;

@property (nonatomic,readonly) NSString *detailText;
- (NSString*)getCellValueWithType:(int)type;
@end
