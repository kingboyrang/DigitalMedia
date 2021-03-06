//
//  BasicMetaDataViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicMetaDataController.h"
#import "DMSearchBar.h"
#import "UIBarButtonItem+TPCategory.h"
#import "TKMetaDataCell.h"
#import "ASIServiceHTTPRequest.h"
#import "MetaDetailViewController.h"
@interface BasicMetaDataController ()<UISearchBarDelegate,UISearchDisplayDelegate>
@property (nonatomic,strong) DMSearchBar *mySearchBar;
@property (nonatomic,strong) UISearchDisplayController *movieDisplay;
@end

@implementation BasicMetaDataController

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
    self.metaHelper=[[SearchMetaDataHelper alloc] init];
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonWithImage:@"search.png" target:self action:@selector(buttonSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.mySearchBar = [[DMSearchBar alloc] initWithFrame:CGRectZero];//CGRectMake(0, 0, self.view.bounds.size.width, 40)
    self.mySearchBar.delegate = self;
    [self.mySearchBar removeBackgroud];
    
    self.movieDisplay = [[UISearchDisplayController alloc]initWithSearchBar:self.mySearchBar contentsController:self];
    self.movieDisplay.active = NO;
    self.movieDisplay.searchResultsDataSource = self;
    self.movieDisplay.searchResultsDelegate = self;
    self.movieDisplay.delegate=self;
    [self.view addSubview:self.mySearchBar];
    
    
    CGFloat h=self.view.frame.size.height-[self topHeight];
    _refrshTable=[[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,h) pullingDelegate:self];
    _refrshTable.delegate=self;
    _refrshTable.dataSource=self;
    //_refrshTable.tableHeaderView=topView;
    [self.view addSubview:_refrshTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //加载数据
    [self.metaHelper.pager initParams];
    [self.refrshTable launchRefreshing];
}
#pragma mark - Notifications
- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    //取得键盘的大小
    //CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {//显示键盘
        
        
        
        CGRect r=CGRectMake(0, 0, self.view.bounds.size.width, 44);
        
        CGRect r2=self.refrshTable.frame;
        r2.origin.y=r.size.height;
        r2.size.height-=r.size.height;
        
        
        NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        // 添加移动动画，使视图跟随键盘移动
        [UIView animateWithDuration:duration.doubleValue animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:[curve intValue]];
            
            self.mySearchBar.frame=r;
            self.refrshTable.frame=r2;
        }];
        
    }
    else  {//隐藏键盘
        
        CGRect r1=self.refrshTable.frame;
        r1.origin.y=0;
        r1.size.height=self.view.bounds.size.height-[self topHeight];
        [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.mySearchBar.frame=CGRectZero;
            self.refrshTable.frame=r1;
        }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (!self.keyWord) {
        self.keyWord=@"";
    }
    if (!self.classCode) {
        self.classCode=@"";
    }
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.dataType,@"category", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.classCode,@"classcode", nil]];
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
