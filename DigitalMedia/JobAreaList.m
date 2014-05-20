//
//  JobAreaList.m
//  MediaCenter
//
//  Created by aJia on 13/9/25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "JobAreaList.h"
#import "ASIServiceHTTPRequest.h"
#import "JobEmployment.h"
#import "TKJobCell.h"
#import "NetWorkConnection.h"
@interface JobAreaList()
-(void)loadControls;
- (void)loadData;
-(void)loadSourceData;
@end
@implementation JobAreaList
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.jobType=1;
        self.backgroundColor=[UIColor clearColor];
        [self loadControls];
    }
    return self;
}
-(void)loadingData{
    if ([self.sourceData count]==0||self.jobHelper.pager.CurPage==0) {
        //第1次加载执时[下拉加载]
        [self.jobTable launchRefreshing];//默认加载10笔数据
    }
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sourceData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellNewsIdentifier = @"CellNewsIdentifier";
    TKJobCell *cell = (TKJobCell*)[tableView dequeueReusableCellWithIdentifier:CellNewsIdentifier];
    if (cell==nil) {
        cell=[[TKJobCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellNewsIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    JobEmployment *entity=self.sourceData[indexPath.row];
    cell.labTitle.text=[entity getCellValueWithType:self.jobHelper.operType];
    cell.labDate.text=self.jobHelper.operType==1?entity.WorkAddress:[entity detailText];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobEmployment *entity=self.sourceData[indexPath.row];
    CGFloat leftX=5,top=4,topY=8,w=self.frame.size.width-leftX-20,total=0.0f;
    NSString *title1=[entity getCellValueWithType:self.jobHelper.operType];
    CGSize size=[title1 textSize:defaultBDeviceFont withWidth:w];
    total+=topY+size.height+top;
    title1=self.jobHelper.operType==1?entity.WorkAddress:[entity detailText];
    size=[title1 textSize:defaultSDeviceFont withWidth:w];
    total+=size.height+topY;
    return total;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedItemWithEntity:sender:)]) {
        [self.delegate selectedItemWithEntity:self.sourceData[indexPath.row] sender:self];
    }
    
}
-(void)loadSourceData{
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:self.jobHelper.searchArgs];
    [request success:^{
        [self.jobTable tableViewDidFinishedLoading];
        self.jobTable.reachedTheEnd  = NO;
        BOOL boo=NO;
        XmlNode *node=[request.ServiceResult methodNode];
        if (node) {
            NSArray *arr=[self.jobHelper xmlSerializationWithXml:node.InnerText];
            if (arr&&[arr count]>0) {
                boo=YES;
                if (self.jobHelper.pager.CurPage==1) {
                    self.sourceData=[NSMutableArray arrayWithArray:arr];
                    [self.jobTable reloadData];
                }else{
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:arr.count];
                    int total=self.sourceData.count;
                    for (int i=0; i<[arr count]; i++) {
                        [self.sourceData addObject:[arr objectAtIndex:i]];
                        NSIndexPath *newPath=[NSIndexPath indexPathForRow:i+total inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新呼叫UITableView的方法, 來生成行.
                    [self.jobTable beginUpdates];
                    [self.jobTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [self.jobTable endUpdates];
                }
                
            }
        }
        if (!boo) {
            self.jobHelper.pager.CurPage--;
            if (self.delegate&&[self.delegate respondsToSelector:@selector(showLoadFailure:)]) {
                [self.delegate showLoadFailure:self];
            }
        }
    } failure:^{
        [self.jobTable tableViewDidFinishedLoading];
        self.jobTable.reachedTheEnd  = NO;
        self.jobHelper.pager.CurPage--;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(showLoadFailure:)]) {
            [self.delegate showLoadFailure:self];
        }
    }];
}
- (void)loadData{
    if (self.refreshing) {
        self.refreshing=NO;
    }
    //判断是否存在网络连接
    if (![NetWorkConnection IsEnableConnection]) {
        [self.jobTable tableViewDidFinishedLoading];
        self.jobTable.reachedTheEnd  = NO;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(showNetWorkError:)]) {
            [self.delegate showNetWorkError:self];
        }
        return;
    }
    if (self.jobHelper.pager.hasNextPage) {
        [self.jobHelper.pager loadNextPage];
        [self loadSourceData];//加载数据
    }else{
        [self.jobTable tableViewDidFinishedLoadingWithMessage:@"沒有了哦.."];
        self.jobTable.reachedTheEnd  = YES;
        
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
    [self.jobTable tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.jobTable tableViewDidEndDragging:scrollView];
}
#pragma mark private methods
-(void)loadControls{
    if (!self.jobTable){
        self.jobTable = [[PullingRefreshTableView alloc] initWithFrame:self.bounds pullingDelegate:self];
        self.jobTable.backgroundColor=[UIColor clearColor];
        self.jobTable.dataSource = self;
        self.jobTable.delegate = self;
        [self addSubview:self.jobTable];
    }
    self.jobHelper=[[JobEmploymentHelper alloc] init];
}
@end
