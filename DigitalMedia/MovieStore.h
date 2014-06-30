//
//  MovieStore.h
//  DigitalMedia
//
//  Created by aJia on 2014/6/30.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieStore : NSObject<NSCoding>
@property (nonatomic,copy) NSString *Guid;//ID
@property (nonatomic,copy) NSString *Name;//文件名稱
@property (nonatomic,copy) NSString *Date;//下載日期
@property (nonatomic,copy) NSString *Dept;//單位
@property (nonatomic,copy) NSString *DTYPE;//檔案類型 (1:圖片； 2：影音；3：聲音；4：檔案)

@property (nonatomic,readonly) NSString *TypeName;
@property (nonatomic,readonly) NSString *path;
@end
