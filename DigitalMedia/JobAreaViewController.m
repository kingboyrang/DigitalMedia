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
#define JobAreaSoureData [NSArray arrayWithObjects:@"職缺資訊", @"求材活動資訊", nil]

@interface JobAreaViewController ()<UIScrollViewDelegate,JobAreaDelegate>
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
    _menuBar= [[LightMenuBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44) andStyle:LightMenuBarStyleItem];
    _menuBar.delegate = self;
    _menuBar.bounces = YES;
    _menuBar.selectedItemIndex = 0;
    if (DeviceIsPad) {
        UIView *viewBg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        viewBg.backgroundColor=[UIColor colorFromHexRGB:@"f0f0f0"];
        [viewBg addSubview:_menuBar];
        [self.view addSubview:viewBg];
    }else{
        [self.view addSubview:_menuBar];
    }
    CGRect r=self.view.bounds;
    r.origin.y=_menuBar.frame.size.height;
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
    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-100)/2.0, 0, 100, 30)];
    self.pageControl.currentPage=0;
    self.pageControl.numberOfPages=2;
    self.pageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.pageControl];
    self.pageControl.hidden=YES;
    
    [self.couponTableView loadingData];
}
#pragma mark - 重写事件
-(void) showErrorViewAnimated:(void (^)(AnimateErrorView *errorView))process{
   
    AnimateErrorView *errorView = [self errorView];
    if (process) {
        process(errorView);
    }
    [self.view addSubview:errorView];
    [self.view sendSubviewToBack:errorView];
    [self.view sendSubviewToBack:self.nibScrollView];
    
    CGRect r=errorView.frame;
    r.origin.y=_menuBar.frame.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        errorView.frame=r;
    }];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIScrollViewDelegate Methods
// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger page=offset.x / bounds.size.width;
    _menuBar.selectedItemIndex=page;
}
#pragma mark LightMenuBarDelegate
- (NSUInteger)itemCountInMenuBar:(LightMenuBar *)menuBar {
    return [JobAreaSoureData count];
}
- (NSString *)itemTitleAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    return [JobAreaSoureData objectAtIndex:index];
}

- (void)itemSelectedAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    if (index==0) {
        [self.couponTableView loadingData];
    }else{
        [self.groupbuyTableView loadingData];
    }
    [self.nibScrollView setContentOffset:CGPointMake(index*self.nibScrollView.bounds.size.width,0) animated:YES];
}

//< Optional
- (CGFloat)itemWidthAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    return 320.0f/2;
}
/****************************************************************************/
//< For Background Area
/****************************************************************************/

/**< Top and Bottom Padding, by Default 5.0f */
- (CGFloat)verticalPaddingInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

/**< Left and Right Padding, by Default 5.0f */
- (CGFloat)horizontalPaddingInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

/**< Corner Radius of the background Area, by Default 5.0f */
- (CGFloat)cornerRadiusOfBackgroundInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

- (UIColor *)colorOfBackgroundInMenuBar:(LightMenuBar *)menuBar {
    return [UIColor colorFromHexRGB:@"f0f0f0"];//5094a8 f0f0f0
}
- (UIFont *)fontOfTitleInMenuBar:(LightMenuBar *)menuBar{
    return defaultBDeviceFont;
}
- (UIColor *)colorOfTitleNormalInMenuBar:(LightMenuBar *)menuBar{
    return [UIColor colorFromHexRGB:@"5094a8"];
}
//选中时的button颜色
- (UIColor *)colorOfButtonHighlightInMenuBar:(LightMenuBar *)menuBar{
    return [UIColor colorFromHexRGB:@"5094a8"];
}
@end
