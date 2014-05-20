//
//  JobAreaViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "JobAreaViewController.h"
#import "ASIServiceHTTPRequest.h"
#import "JobAreaList.h"
#import "JobDetailViewController.h"
@interface JobAreaViewController ()<UIScrollViewDelegate,JobAreaDelegate>{
    int currentPage;
    BOOL pageControlUsed;
}
@property (nonatomic,strong) UIScrollView *nibScrollView;
@property (nonatomic,strong) JobAreaList *couponTableView;
@property (nonatomic,strong) JobAreaList *groupbuyTableView;
@property (nonatomic,strong) UIPageControl *pageControl;
@end

@implementation JobAreaViewController

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
    _topView=[[JobTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [_topView.leftButton addTarget:self action:@selector(couponButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView.rightButton addTarget:self action:@selector(groupbuyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topView];
    
    CGRect r=self.view.bounds;
    r.origin.y=_topView.frame.size.height;
    r.size.height-=[self topHeight]+r.origin.y;
    
    self.nibScrollView=[[UIScrollView alloc] initWithFrame:r];
    self.nibScrollView.scrollEnabled=YES;
    self.nibScrollView.showsHorizontalScrollIndicator=NO;
    self.nibScrollView.showsVerticalScrollIndicator=NO;
    self.nibScrollView.scrollsToTop = NO;
    self.nibScrollView.delegate = self;
    [self.nibScrollView setContentOffset:CGPointMake(0, 0)];
    [self.nibScrollView setContentSize:CGSizeMake(2*r.size.width,r.size.height)];
    
    self.couponTableView=[[JobAreaList alloc] initWithFrame:CGRectMake(0, 0,r.size.width,r.size.height)];
    self.couponTableView.delegate=self;
    [self.nibScrollView addSubview:self.couponTableView];
    
    
    self.groupbuyTableView=[[JobAreaList alloc] initWithFrame:CGRectMake(r.size.width, 0,r.size.width,r.size.height)];
    self.groupbuyTableView.jobHelper.operType=2;
    self.groupbuyTableView.delegate=self;
    [self.nibScrollView addSubview:self.groupbuyTableView];
    [self.view addSubview:self.nibScrollView];
    
    //公用
    currentPage = 0;
    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-100)/2.0, 0, 100, 30)];
    self.pageControl.currentPage=0;
    self.pageControl.numberOfPages=2;
    self.pageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.pageControl];
    self.pageControl.hidden=YES;
    
    [self.couponTableView loadingData];
}
#pragma mark- JobAreaDelegate Methods
- (void)showLoadFailure:(id)sender{
    
}
- (void)showNetWorkError:(id)sender{
    [self showErrorNetWorkNotice:nil];
}
- (void)selectedItemWithEntity:(JobEmployment*)entity sender:(id)sender{
    if (self.couponTableView==sender) {//職缺資訊
        JobDetailViewController *detail=[[JobDetailViewController alloc] init];
        detail.Entity=entity;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark-
#pragma mark 界面按钮事件
- (void) btnActionShow
{
    if (currentPage == 0) {
        [self couponButtonAction:_topView.leftButton];
    }
    else{
        [self groupbuyButtonAction:_topView.rightButton];
    }
}
- (void) couponButtonAction:(UIButton*)btn
{
    //[self.couponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//此时选中
    //[self.groupbuyButton setTitleColor:[UIColor colorWithRed:(220/255.0) green:(220/255.0) blue:(220/255.0) alpha:1] forState:UIControlStateNormal];//此时未被选中
    
    CGRect r=_topView.labLine.frame;
    r.origin.x=0;
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    _topView.labLine.frame=r;
    [self.nibScrollView setContentOffset:CGPointMake(self.view.bounds.size.width*0, 0)];//页面滑动
    
    [UIView commitAnimations];
    [self.couponTableView loadingData];
}

- (void) groupbuyButtonAction:(UIButton*)btn
{
    //[self.groupbuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//此时选中
    //[self.couponButton setTitleColor:[UIColor colorWithRed:(220/255.0) green:(220/255.0) blue:(220/255.0) alpha:1] forState:UIControlStateNormal];//此时未被选中
    
    CGRect r=_topView.labLine.frame;
    r.origin.x=self.view.bounds.size.width/2;
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    _topView.labLine.frame=r;
    [self.nibScrollView setContentOffset:CGPointMake(self.view.bounds.size.width*1, 0)];
    [UIView commitAnimations];
    [self.groupbuyTableView loadingData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIScrollViewDelegate Methods
// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.nibScrollView.frame.size.width;
    int page = floor((self.nibScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.pageControl.currentPage = page;
    currentPage = page;
    pageControlUsed = NO;
    [self btnActionShow];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //暂不处理 - 其实左右滑动还有包含开始等等操作，这里不做介绍
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}
@end
