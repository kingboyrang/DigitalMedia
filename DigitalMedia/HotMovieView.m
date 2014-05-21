//
//  HotMovieView.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "HotMovieView.h"
#import "TKHotMovieCell.h"
#import "ASIServiceHTTPRequest.h"
#import "NetWorkConnection.h"
@implementation HotMovieView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.metaHelper=[[SearchMetaDataHelper alloc] init];
        //加载数据
        self.keyWord=@"";
        [self.metaHelper.pager initParams];
        
        _refrshTable=[[PullingRefreshTableView alloc] initWithFrame:self.bounds pullingDelegate:self];
        _refrshTable.delegate=self;
        _refrshTable.dataSource=self;
        //_refrshTable.tableHeaderView=topView;
        [self addSubview:_refrshTable];
    }
    return self;
}
- (void)loadingDataSource{
    if (self.metaHelper.pager.CurPage==0||[self.listData count]==0) {
        [self.refrshTable launchRefreshing];
    }
}
- (void)failureInits{
    self.metaHelper.pager.CurPage--;
    [_refrshTable tableViewDidFinishedLoading];
    _refrshTable.reachedTheEnd  = NO;
}
-(void)loadData{
    if (self.refreshing) {
        self.refreshing=NO;
    }
    if (![NetWorkConnection IsEnableConnection]) {
        //[self showErrorNetWorkNotice:nil];
        return;
    }
    if (self.metaHelper.pager.hasNextPage) {
        [self.metaHelper.pager loadNextPage];
        [self loadSourceData];//加载数据
    }else{
        [_refrshTable tableViewDidFinishedLoadingWithMessage:@"沒有了哦!"];
        _refrshTable.reachedTheEnd  = YES;
    }
}
- (void)loadSourceData{
    
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"category", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"classcode", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.keyWord,@"keywork", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.metaHelper.pager.CurPage],@"curPage", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.metaHelper.pager.PageSize],@"pageSize", nil]];
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.methodName=@"CategorySearchMetaData";
    args.soapParams=params;
    
    ASIServiceHTTPRequest *engine=[ASIServiceHTTPRequest requestWithArgs:args];
    [engine success:^{
        [_refrshTable tableViewDidFinishedLoading];
        _refrshTable.reachedTheEnd  = NO;
        NSArray *source=[self.metaHelper xmlSerializationWithXml:engine.responseString];
        if (source&&[source count]>0) {
            if (self.metaHelper.pager.CurPage==1) {
                self.listData=[NSMutableArray arrayWithArray:source];
                [_refrshTable reloadData];
            }else{
                NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:source.count];
                int total=self.listData.count;
                for (int i=0; i<[source count]; i++) {
                    [self.listData addObject:[source objectAtIndex:i]];
                    NSIndexPath *newPath=[NSIndexPath indexPathForRow:i+total inSection:0];
                    [insertIndexPaths addObject:newPath];
                }
                //重新呼叫UITableView的方法, 來生成行.
                [_refrshTable beginUpdates];
                [_refrshTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                [_refrshTable endUpdates];
            }
        }else{
            [self failureInits];
        }
    } failure:^{
        [self failureInits];
    }];
    
}
#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [self.listData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MetaDataCell";
    TKHotMovieCell *cell = (TKHotMovieCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TKHotMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    SearchMetaData *entity=self.listData[indexPath.row];
    cell.labTitle.text=[entity.C_NAME Trim];
    cell.labCategory.text=[NSString stringWithFormat:@"類別:%@",[entity.ClassCodeName Trim]];
    //单位
    NSString *unit=@"";
    if (entity.DEPT_NAME&&[entity.DEPT_NAME length]>0) {
        unit=[entity.DEPT_NAME Trim];
    }
    cell.labUnit.text=[NSString stringWithFormat:@"單位:%@",unit];
    cell.labDate.text=[NSString stringWithFormat:@"發佈時間:%@",entity.formatDateText];
    cell.labRead.text=[NSString stringWithFormat:@"點閱:%@",entity.Views];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedItemWithModel:type:sender:)]) {
        [self.delegate selectedItemWithModel:self.listData[indexPath.row] type:3 sender:self];
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
    [_refrshTable tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refrshTable tableViewDidEndDragging:scrollView];
}
@end
