//
//  MetaDataTable.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/23.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MetaDataTable.h"
#import "TKLabelLabelCell.h"
@implementation MetaDataTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _metaTable=[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _metaTable.dataSource=self;
        _metaTable.delegate=self;
        _metaTable.bounces=NO;
        [self addSubview:_metaTable];
        
        TKLabelLabelCell *cell1=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell1.labName.text=@"發佈時間:";
        
        TKLabelLabelCell *cell2=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell2.labName.text=@"中文名稱:";
        
        TKLabelLabelCell *cell3=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell3.labName.text=@"資料:";
        
        TKLabelLabelCell *cell4=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell4.labName.text=@"檔案類別:";
        
        TKLabelLabelCell *cell5=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell5.labName.text=@"說明:";
        
        self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5, nil];
    }
    return self;
}
- (void)loadingSourceDataWithModel:(SubMetaData*)entity withModel:(SearchMetaData*)mod{
    TKLabelLabelCell *cell1=self.cells[0];
    cell1.labDetail.text=entity.REG_DATE;
    
    TKLabelLabelCell *cell2=self.cells[1];
    cell2.labDetail.text=entity.C_NAME;
    
    TKLabelLabelCell *cell3=self.cells[2];
    cell3.labDetail.text=mod.dataTypeName;
    
    TKLabelLabelCell *cell4=self.cells[3];
    cell4.labDetail.text=mod.CATEGORY_NAME;
    
    TKLabelLabelCell *cell5=self.cells[4];
    cell5.labDetail.text=entity.SUB_DESCRIPTION;
    
    [_metaTable reloadData];

    
}
#pragma mark -UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cells count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=self.cells[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TKLabelLabelCell *cell=self.cells[indexPath.row];
    CGFloat w=self.frame.size.width-cell.labName.frame.origin.x-cell.labName.frame.origin.y-2-5;
    CGSize size=[cell.labDetail.text textSize:cell.labDetail.font withWidth:w];
    if (size.height+20>44.0f) {
        return size.height+20;
    }
    return 44.0f;
}
@end
