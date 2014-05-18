//
//  CountyZoneViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "CountyZoneViewController.h"
#import "CountyZoneTopView.h"
@interface CountyZoneViewController ()

@end

@implementation CountyZoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CountyZoneTopView *topView=[[CountyZoneTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
    [self.view addSubview:topView];
    
    CGFloat h=self.view.frame.size.height-[self topHeight]-48;
    _refrshTable=[[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 48, self.view.frame.size.width,h) pullingDelegate:self];
    _refrshTable.delegate=self;
    _refrshTable.dataSource=self;
    [_refrshTable setAutoresizesSubviews:YES];
    [_refrshTable setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:_refrshTable];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initPageParams{
    curPage=0;
    pageSize=DeviceIsPad?20:10;
    maxPage=0;
}
-(void)loadData{
    if (self.refreshing) {
        self.refreshing=NO;
    }
    if (![self hasNewWork]) {
        //_refrshTable.reachedTheEnd  = NO;
        //[_refrshTable tableViewDidFinishedLoadingWithMessage:@"請檢查網絡連接.."];
        [self showErrorNetWorkNotice:nil];
        return;
    }
    if (curPage!=maxPage) {
        curPage++;
        if (curPage>=maxPage) {
            curPage=maxPage;
        }
        //[self loadSourceData];//加载数据
    }else{
        [_refrshTable tableViewDidFinishedLoadingWithMessage:@"沒有了哦.."];
        _refrshTable.reachedTheEnd  = YES;
        
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
