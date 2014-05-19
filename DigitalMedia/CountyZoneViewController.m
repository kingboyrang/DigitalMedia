//
//  CountyZoneViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "CountyZoneViewController.h"
#import "CountyZoneTopView.h"
#import "SRMNetworkEngine.h"
#import "UIBarButtonItem+TPCategory.h"
#import "UIImage+TPCategory.h"
#import "DMSearchBar.h"
@interface CountyZoneViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
@property (nonatomic,strong) DMSearchBar *mySearchBar;
@property (nonatomic,strong) UISearchDisplayController *movieDisplay;
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
    
    CountyZoneTopView *topView=[[CountyZoneTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
    topView.tag=100;
    [self.view addSubview:topView];
    
   
    CGFloat h=self.view.frame.size.height-[self topHeight]-48;
    _refrshTable=[[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 48, self.view.frame.size.width,h) pullingDelegate:self];
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
    
 
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initPageParams];
    [self.refrshTable launchRefreshing];
}
#pragma mark - Notifications
- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    //取得键盘的大小
    //CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {//显示键盘
        
        CountyZoneTopView *topView=(CountyZoneTopView*)[self.view viewWithTag:100];
        
        CGRect r=CGRectMake(0, 0, self.view.bounds.size.width, 44);
        CGRect r1=topView.frame;
        r1.origin.y=r.size.height;
        CGRect r2=self.refrshTable.frame;
        r2.origin.y=r.size.height+r1.size.height;
        r2.size.height-=r.size.height;
        
        
        NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        // 添加移动动画，使视图跟随键盘移动
        [UIView animateWithDuration:duration.doubleValue animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:[curve intValue]];
           
            self.mySearchBar.frame=r;
            topView.frame=r1;
            
            self.refrshTable.frame=r2;
        }];
        
    }
    else  {//隐藏键盘
         CountyZoneTopView *topView=(CountyZoneTopView*)[self.view viewWithTag:100];
        CGRect r=topView.frame;
        r.origin.y=0;
        
        CGRect r1=self.refrshTable.frame;
        r1.origin.y=r.size.height;
        r1.size.height+=44;
        [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.mySearchBar.frame=CGRectZero;
            topView.frame=r;
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
    [self.mySearchBar.searchField becomeFirstResponder];
}
-(void)initPageParams{
    curPage=0;
    pageSize=DeviceIsPad?20:10;
    maxPage=0;
    self.keyWord=@"";
}
-(void)loadData{
    if (self.refreshing) {
        self.refreshing=NO;
    }
    if (![self hasNewWork]) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    if (curPage!=maxPage) {
        curPage++;
        if (curPage>=maxPage) {
            curPage=maxPage;
        }
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
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",curPage],@"curPage", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageSize],@"pageSize", nil]];
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"CategorySearchMetaData";
    args.soapParams=params;
    
    SRMNetworkEngine *engine=[[SRMNetworkEngine alloc] initWithHostName:args.hostName];
    [engine requestWithArgs:args success:^(MKNetworkOperation *completedOperation) {
        [_refrshTable tableViewDidFinishedLoading];
        _refrshTable.reachedTheEnd  = NO;
        
        NSLog(@"xml=%@",completedOperation.responseString);
        
    } failure:^(MKNetworkOperation *completedOperation, NSError *error) {
        curPage--;
        [_refrshTable tableViewDidFinishedLoading];
        _refrshTable.reachedTheEnd  = NO;
        [self showErrorViewWithHide:^(AnimateErrorView *errorView) {
            errorView.labelTitle.text=@"沒有返回數據!";
        } completed:nil];
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
    [self loadSourceData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    self.mySearchBar.frame=CGRectZero;
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    self.refrshTable.frame=r;
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
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.movieDisplay.searchResultsTableView) {
        //cell.textLabel.text = searchResults[indexPath.row];
    }
    else {
        cell.textLabel.text = self.listData[indexPath.row];
    }
    return cell;
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
