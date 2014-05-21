//
//  NewsView.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "NewsView.h"
#import "NetWorkConnection.h"
#import "ASIServiceHTTPRequest.h"
@implementation NewsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!_newsTable){
            _newsTable = [[PullingRefreshTableView alloc] initWithFrame:self.bounds pullingDelegate:self];
            _newsTable.dataSource = self;
            _newsTable.delegate = self;
            [self addSubview:_newsTable];
        }
        if (!_newsHelper) {
            _newsHelper=[[WebNewsHelper alloc] init];
        }

    }
    return self;
}
-(void)loadingData{
    if ([self.sourceData count]==0||self.newsHelper.pager.CurPage==0) {
        //第1次加载执时[下拉加载]
        [self.newsTable launchRefreshing];//默认加载10笔数据
    }
}
-(void)loadData{
    if (self.refreshing) {
        self.refreshing=NO;
    }
    if (![NetWorkConnection IsEnableConnection]) {
        [_newsTable tableViewDidFinishedLoading];
        _newsTable.reachedTheEnd  = NO;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(showNetworkError:)]) {
            [self.delegate showNetworkError:self];
        }
        return;
    }
    if (self.newsHelper.pager.hasNextPage) {
        [self.newsHelper.pager loadNextPage];
        [self loadSourceData];//加载数据
    }else{
        [_newsTable tableViewDidFinishedLoadingWithMessage:@"沒有了哦!"];
        _newsTable.reachedTheEnd  = YES;
        
    }
}
-(void)loadSourceData{
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:[self.newsHelper searchArgs]];
    [request success:^{
        [_newsTable tableViewDidFinishedLoading];
        _newsTable.reachedTheEnd  = NO;
        BOOL boo=NO;
        XmlNode *node=[request.ServiceResult methodNode];
        if (node) {
              NSArray *arr=[self.newsHelper xmlSerializationWithXml:node.InnerText];
            if (arr&&[arr count]>0) {
                boo=YES;
                if (self.newsHelper.pager.CurPage==1) {
                    self.sourceData=[NSMutableArray arrayWithArray:arr];
                    [self.newsTable reloadData];
                }else{
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:arr.count];
                    int total=self.sourceData.count;
                    for (int i=0; i<[arr count]; i++) {
                        [self.sourceData addObject:[arr objectAtIndex:i]];
                        NSIndexPath *newPath=[NSIndexPath indexPathForRow:i+total inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新呼叫UITableView的方法, 來生成行.
                    [self.newsTable beginUpdates];
                    [self.newsTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [self.newsTable endUpdates];
                }
            }
        }
        if (!boo) {
            self.newsHelper.pager.CurPage--;
            if (self.delegate&&[self.delegate respondsToSelector:@selector(showLoadingFailureError:)]) {
                [self.delegate showLoadingFailureError:self];
            }
        }
    } failure:^{
        [_newsTable tableViewDidFinishedLoading];
        _newsTable.reachedTheEnd  = NO;
        self.newsHelper.pager.CurPage--;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(showLoadingFailureError:)]) {
            [self.delegate showLoadingFailureError:self];
        }
        
    }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sourceData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellNewsIdentifier = @"CellNewsIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellNewsIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellNewsIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font=defaultBDeviceFont;
        cell.detailTextLabel.font=defaultSDeviceFont;
        cell.detailTextLabel.textColor=[UIColor grayColor];
    }
    WebNews *entity=self.sourceData[indexPath.row];
    cell.detailTextLabel.text=entity.formatDateText;
    cell.textLabel.text=entity.Title;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //goToNewsDetail
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedItemWithType:model:sender:)]) {
        [self.delegate selectedItemWithType:self.newsHelper.operType model:self.sourceData[indexPath.row] sender:self];
    }
}
#pragma mark - PullingRefreshTableViewDelegate
//下拉加载
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

//上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_newsTable tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_newsTable tableViewDidEndDragging:scrollView];
}
@end
