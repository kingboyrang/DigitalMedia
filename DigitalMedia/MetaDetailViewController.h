//
//  MetaDetailViewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/23.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchMetaData.h"
#import "MetaDataTable.h"
@interface MetaDetailViewController : BasicViewController
@property (nonatomic,retain) SearchMetaData *Entity;
@property (nonatomic,retain) NSArray *subMetas;
@property (nonatomic,retain) MetaDataTable *dataTable;
@end
