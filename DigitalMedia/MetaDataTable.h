//
//  MetaDataTable.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/23.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubMetaData.h"
#import "SearchMetaData.h"
@interface MetaDataTable : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *metaTable;
@property (nonatomic,strong) NSMutableArray *cells;
- (void)loadingSourceDataWithModel:(SubMetaData*)entity withModel:(SearchMetaData*)mod;
@end
