//
//  SearchMetaData.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchMetaData : NSObject
@property (nonatomic,copy) NSString *META_PK;
@property (nonatomic,copy) NSString *CATEGORY;
@property (nonatomic,copy) NSString *CATEGORY_NAME;
@property (nonatomic,copy) NSString *C_NAME;
@property (nonatomic,copy) NSString *ClassCodeName;
@property (nonatomic,copy) NSString *DEPT_NAME;
@property (nonatomic,copy) NSString *DESCRIPTION;
@property (nonatomic,copy) NSString *DTYPE;
@property (nonatomic,copy) NSString *FilePath;
@property (nonatomic,copy) NSString *MOTIF_COUNTRY;
@property (nonatomic,copy) NSString *MOTIF_COUNTRY_FieldType;
@property (nonatomic,copy) NSString *PHO_DATE_START;
@property (nonatomic,copy) NSString *PHO_PLACE;
@property (nonatomic,copy) NSString *REG_DATE;//發佈時間
@property (nonatomic,copy) NSString *ShowWebDate;
@property (nonatomic,copy) NSString *Value_1;
@property (nonatomic,copy) NSString *Views;//阅读数量

@property (nonatomic,readonly) NSString *formatDateText;
@end
