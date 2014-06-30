//
//  HappyMoviewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "HappyMoviewController.h"
#import "CCSegmentedControl.h"
#import "UIImage+TPCategory.h"
#import "BasicMetaDataController.h"
#import "HappyElandView.h"
#import "OrganView.h"
#import "HotMovieView.h"
#import "HappyMovieDelegate.h"
#import "OrgenMovieViewController.h"
#import "HappyEland.h"
#import "DMSearchBar.h"
#import "TKMetaDataCell.h"
#import "ASIServiceHTTPRequest.h"
#import "UIBarButtonItem+TPCategory.h"
#import "MetaDetailViewController.h"
@interface HappyMoviewController ()<HappyMovieDelegate,UIScrollViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (nonatomic,strong) DMSearchBar *mySearchBar;
@property (nonatomic,strong) UISearchDisplayController *movieDisplay;
@end

@implementation HappyMoviewController

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
    CCSegmentedControl* segmentedControl = [[CCSegmentedControl alloc] initWithItems:@[@"幸福宜蘭", @"機關類別", @"熱門影音",@"最新影音"]];
    segmentedControl.tag=200;
    segmentedControl.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    //设置背景图片，或者设置颜色，或者使用默认白色外观
    segmentedControl.backgroundImage = [UIImage createImageWithColor:[UIColor colorFromHexRGB:@"f0f0f0"] imageSize:CGSizeMake(self.view.bounds.size.width, 44)];
    segmentedControl.selectedSegmentTextColor = [UIColor whiteColor];
    //阴影部分图片，不设置使用默认椭圆外观的stain 70*35
    UIImage *img=[UIImage createImageWithColor:[UIColor colorFromHexRGB:@"5094a8"] imageSize:CGSizeMake(70, 35)];
    UIImage *corImg=[UIImage createRoundedRectImage:img size:img.size radius:5.0f];
    segmentedControl.selectedStainView = [[UIImageView alloc] initWithImage:corImg];
    segmentedControl.segmentTextColor = [UIColor colorFromHexRGB:@"5094a8"];//3f8d4a
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    CGRect r=self.view.bounds;
    r.origin.y=segmentedControl.frame.size.height;
    r.size.height-=[self topHeight]+r.origin.y;
    _happySrcollView=[[UIScrollView alloc] initWithFrame:r];
    _happySrcollView.pagingEnabled=YES;
    _happySrcollView.showsHorizontalScrollIndicator=NO;
    _happySrcollView.showsVerticalScrollIndicator=NO;
    _happySrcollView.delegate=self;
    [_happySrcollView setContentSize:CGSizeMake(4*r.size.width, r.size.height)];
    [self.view addSubview:_happySrcollView];
    
    //幸福宜蘭
    HappyElandView *elandView=[[HappyElandView alloc] initWithFrame:CGRectMake(0, 0, r.size.width, r.size.height)];
    elandView.tag=100;
    elandView.delegate=self;
    [_happySrcollView addSubview:elandView];
    [elandView loadingDataSource];
    //机关类别
    OrganView *organ=[[OrganView alloc] initWithFrame:CGRectMake(r.size.width, 0, r.size.width, r.size.height)];
    organ.tag=101;
    organ.movieDelegate=self;
    [_happySrcollView addSubview:organ];
    //热门影音
    HotMovieView *hotmovie=[[HotMovieView alloc] initWithFrame:CGRectMake(r.size.width*2, 0, r.size.width, r.size.height)];
    hotmovie.tag=102;
    hotmovie.delegate=self;
    [_happySrcollView addSubview:hotmovie];
    
   //最新影音
    self.metaHelper=[[SearchMetaDataHelper alloc] init];
    self.mySearchBar = [[DMSearchBar alloc] initWithFrame:CGRectZero];//CGRectMake(0, 0, self.view.bounds.size.width, 40)
    self.mySearchBar.delegate = self;
    [self.mySearchBar removeBackgroud];
    
    self.movieDisplay = [[UISearchDisplayController alloc]initWithSearchBar:self.mySearchBar contentsController:self];
    self.movieDisplay.active = NO;
    self.movieDisplay.searchResultsDataSource = self;
    self.movieDisplay.searchResultsDelegate = self;
    self.movieDisplay.delegate=self;
    [self.view addSubview:self.mySearchBar];
    
    _refrshTable=[[PullingRefreshTableView alloc] initWithFrame:CGRectMake(r.size.width*3, 0, r.size.width,r.size.height) pullingDelegate:self];
    _refrshTable.delegate=self;
    _refrshTable.dataSource=self;
    //_refrshTable.tableHeaderView=topView;
    [_happySrcollView addSubview:_refrshTable];
    
    [self.view sendSubviewToBack:_happySrcollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //加载数据
    self.keyWord=@"";
    [self.metaHelper.pager initParams];
    

}
- (void)valueChanged:(id)sender
{
    CCSegmentedControl* segmentedControl = sender;
    [_happySrcollView setContentOffset:CGPointMake(segmentedControl.selectedSegmentIndex*_happySrcollView.bounds.size.width,0) animated:YES];
    if (segmentedControl.selectedSegmentIndex==0) {
        HappyElandView *eland=(HappyElandView*)[_happySrcollView viewWithTag:100];
        [eland loadingDataSource];
    }
    if (segmentedControl.selectedSegmentIndex==1) {
        OrganView *eland=(OrganView*)[_happySrcollView viewWithTag:101];
        [eland loadingDataSource];
    }
    if (segmentedControl.selectedSegmentIndex==2) {
        HotMovieView *eland=(HotMovieView*)[_happySrcollView viewWithTag:102];
        [eland loadingDataSource];
    }
    if (segmentedControl.selectedSegmentIndex==3) {
         self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonWithImage:@"search.png" target:self action:@selector(buttonSearchClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.metaHelper.pager.CurPage==0||[self.listData count]==0) {
            [self.refrshTable launchRefreshing];
        }
    }else{
        self.navigationItem.rightBarButtonItem=nil;
    }
}
#pragma mark - 重写事件
-(void) showErrorViewAnimated:(void (^)(AnimateErrorView *errorView))process{
    CCSegmentedControl *segments=(CCSegmentedControl*)[self.view viewWithTag:200];
    AnimateErrorView *errorView = [self errorView];
    if (process) {
        process(errorView);
    }
    [self.view insertSubview:errorView belowSubview:segments];

    CGRect r=errorView.frame;
    r.origin.y=segments.frame.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        errorView.frame=r;
    }];
}
#pragma mark -HappyMovieDelegate Methods
-(void)selectedItemWithModel:(id)entity type:(int)type sender:(id)sender{
    if (type==1) {//幸福宜蘭
        HappyEland *mod=(HappyEland*)entity;
        BasicMetaDataController *metaData=[[BasicMetaDataController alloc] init];
        metaData.dataType=@"1";
        metaData.classCode=mod.CODE;
        [self.navigationController pushViewController:metaData animated:YES];
    }
    if (type==2) {//机关类别
        OrgenMovieViewController *orgenMovie=[[OrgenMovieViewController alloc] init];
        orgenMovie.Entity=entity;
        [self.navigationController pushViewController:orgenMovie animated:YES];
    }
    if (type==3) {//热门影音
        MetaDetailViewController *detail=[[MetaDetailViewController alloc] init];
        detail.Entity=entity;
        [self.navigationController pushViewController:detail animated:YES];
    }

}
- (void)showErrorNetworkMessage{
    [self showErrorNetWorkNotice:nil];
}
#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger page=offset.x / bounds.size.width;
    
    CCSegmentedControl *segemnts=(CCSegmentedControl*)[self.view viewWithTag:200];
    segemnts.selectedSegmentIndex=page;
    [self valueChanged:segemnts];
    //_menuBar.selectedItemIndex=page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Notifications
- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    //取得键盘的大小
    //CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {//显示键盘
        
        
        CCSegmentedControl *sengment=(CCSegmentedControl*)[self.view viewWithTag:200];
        CGRect r=CGRectMake(0, 0, self.view.bounds.size.width, 44);
        CGRect r1=sengment.frame;
        r1.origin.y=r.size.height;
        
        CGRect r2=_happySrcollView.frame;
        r2.origin.y=r.size.height+r1.size.height;
        
        
        NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        // 添加移动动画，使视图跟随键盘移动
        [UIView animateWithDuration:duration.doubleValue animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:[curve intValue]];
            
            self.mySearchBar.frame=r;
            sengment.frame=r1;
            _happySrcollView.frame=r2;
        }];
        
    }
    else  {//隐藏键盘
        CCSegmentedControl *sengment=(CCSegmentedControl*)[self.view viewWithTag:200];
        CGRect r=sengment.frame;
        r.origin.y=0;
        
        CGRect r1=_happySrcollView.frame;
        r1.origin.y=r.size.height;
        [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.mySearchBar.frame=CGRectZero;
            sengment.frame=r;
            _happySrcollView.frame=r1;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.view bringSubviewToFront:sengment];
            }
        }];
    }
}
- (void)buttonSearchClick:(UIButton*)btn{
    if (self.keyWord&&[self.keyWord length]>0) {
        self.mySearchBar.text=self.keyWord;
    }
    [self.mySearchBar.searchField becomeFirstResponder];
}
- (void)failureInits{
    self.metaHelper.pager.CurPage--;
    [_refrshTable tableViewDidFinishedLoading];
    _refrshTable.reachedTheEnd  = NO;
    [self showErrorViewWithHide:^(AnimateErrorView *errorView) {
        errorView.labelTitle.text=@"沒有返回數據!";
    } completed:nil];
}
-(void)loadData{
    if (self.refreshing) {
        self.refreshing=NO;
    }
    if (![self hasNewWork]) {
        [_refrshTable tableViewDidFinishedLoading];
        _refrshTable.reachedTheEnd  = NO;
        [self showErrorNetWorkNotice:nil];
        return;
    }
    if (self.metaHelper.pager.hasNextPage) {
        [self.metaHelper.pager loadNextPage];
        [self loadSourceData];//加载数据
    }else{
        [_refrshTable tableViewDidFinishedLoadingWithMessage:@"沒有了哦.."];
        _refrshTable.reachedTheEnd  = YES;
    }
}
- (void)loadSourceData{
   
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"category", nil]];
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
            self.metaHelper.pager.CurPage--;
            [self showErrorViewWithHide:^(AnimateErrorView *errorView) {
                errorView.labelTitle.text=@"沒有返回數據!";
            } completed:nil];
        }
    } failure:^{
        [self failureInits];
    }];
    
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
    
    for( UIView *subview in tableView1.subviews ) {
        if( [subview class] == [UILabel class] ) {
            UILabel *lbl = (UILabel*)subview; // sv changed to subview.
            lbl.text = @"";
        }
    }
    tableView1.alpha=0.0;
    return YES;
}
#pragma mark - UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.mySearchBar.searchField resignFirstResponder];
    self.keyWord=searchBar.text;
    searchBar.text=@"";
    self.movieDisplay.active=NO;
    [self.metaHelper.pager initParams];
    [self.refrshTable launchRefreshing];
    //[self loadSourceData];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.mySearchBar setCancelButtonDefaultTitle];
    return YES;
}
#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.movieDisplay.searchResultsTableView){
        return 0;
    }
    return [self.listData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.movieDisplay.searchResultsTableView) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
    static NSString *CellIdentifier = @"MetaDataCell";
    TKMetaDataCell *cell = (TKMetaDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TKMetaDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    cell.labDate.text=entity.formatDateText;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MetaDetailViewController *detail=[[MetaDetailViewController alloc] init];
    detail.Entity=self.listData[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
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
