//
//  HappyElandView.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "HappyElandView.h"
#import "ASIServiceHTTPRequest.h"
#import "HappyEland.h"
#import "NetWorkConnection.h"
@interface HappyElandView ()
- (void)updateData;
@end
@implementation HappyElandView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _happyTable=[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _happyTable.delegate=self;
        _happyTable.dataSource=self;
        _happyTable.bounces=NO;
        [self addSubview:_happyTable];
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
        if (self.delegate&&[self.delegate respondsToSelector:@selector(showErrorNetworkMessage)]) {
            [self.delegate showErrorNetworkMessage];
        }
        return;
    }
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.methodName=@"GetCategoryList";
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request success:^{
        XmlNode *node=[request.ServiceResult methodNode];
        if (node) {
            [request.ServiceResult.xmlParse setDataSource:node.InnerText];
            self.listData=[request.ServiceResult.xmlParse selectNodes:@"//Categroy" className:@"HappyEland"];
            [_happyTable reloadData];
        }
    } failure:^{
        
    }];
}
#pragma mark -
#pragma mark TableView DataSource deletate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"cellMovieIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font=defaultBDeviceFont;
        cell.detailTextLabel.font=[UIFont fontWithName:defaultSDeviceFontName size:16];
        cell.detailTextLabel.textColor=[UIColor blueColor];
    }
    HappyEland *entity=self.listData[indexPath.row];
    cell.textLabel.text=entity.NAME;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"影片數量:%@",entity.MetaCount];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedItemWithModel:type:sender:)]) {
        [self.delegate selectedItemWithModel:self.listData[indexPath.row] type:1 sender:self];
    }
}
@end
