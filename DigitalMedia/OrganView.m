//
//  OrganView.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "OrganView.h"
#import "Department.h"
#import "ASIServiceHTTPRequest.h"
#import "NetWorkConnection.h"
@interface OrganView ()
- (void)updateData;
@end

@implementation OrganView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _menuTable=[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _menuTable.bounces=NO;
        _menuTable.dataSource=self;
        _menuTable.delegate=self;
        [self addSubview:_menuTable];

    }
    return self;
}
- (void)loadingDataSource{
    if ([self.listData count]==0) {
        [self updateData];
    }
}
- (void)updateData{
    if (![NetWorkConnection IsEnableConnection]) {
        if (self.movieDelegate&&[self.movieDelegate respondsToSelector:@selector(showErrorNetworkMessage)]) {
            [self.movieDelegate showErrorNetworkMessage];
        }
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showLoadingDataAnimatial)]) {
        [self.delegate showLoadingDataAnimatial];
    }
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.methodName=@"GetFirstDeptList";
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request success:^{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(hideLoadingDataAnimatial)]) {
            [self.delegate hideLoadingDataAnimatial];
        }
        XmlNode *node=[request.ServiceResult methodNode];
        if (node) {
            [request.ServiceResult.xmlParse setDataSource:node.InnerText];
            self.listData=[request.ServiceResult.xmlParse selectNodes:@"//Department" className:@"Department"];
            [_menuTable reloadData];
        }
    } failure:^{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(showLoadingDataFaliureAnimatial)]) {
            [self.delegate showLoadingDataFaliureAnimatial];
        }
    }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellDeptIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font=[UIFont fontWithName:defaultSDeviceFontName size:16];
        cell.detailTextLabel.textColor=[UIColor blueColor];
        cell.textLabel.font=defaultBDeviceFont;
    }
    Department *entity=self.listData[indexPath.row];
    cell.textLabel.text=entity.DEPT_NAME;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"影片數量:%@",entity.MetaCount];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.movieDelegate&&[self.movieDelegate respondsToSelector:@selector(selectedItemWithModel:type:sender:)]) {
        [self.movieDelegate selectedItemWithModel:self.listData[indexPath.row] type:2 sender:self];
    }
}
@end
