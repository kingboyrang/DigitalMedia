//
//  NewsViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "NewsViewController.h"
#import "ASIServiceHTTPRequest.h"
#import "NewsView.h"
#import "NewsDetailViewController.h"
#define MenuSoureData [NSArray arrayWithObjects:@"最新活動", @"縣政新聞", @"最新影音", @"招標公告", @"徵材公告", @"報乎你知", nil]
@interface NewsViewController ()<NewsViewDelegate>

@end

@implementation NewsViewController

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
    _newsScrollView=[[UIScrollView alloc] initWithFrame:r];
    //開啟捲動分頁功能，如果不需要這個功能關閉即可
    [_newsScrollView setPagingEnabled:YES];
    //隐藏横向與縱向的捲軸
    [_newsScrollView setShowsVerticalScrollIndicator:NO];
    [_newsScrollView setShowsHorizontalScrollIndicator:NO];
    //在本類別中繼承scrollView的整體事件
    [_newsScrollView setDelegate:self];
    [_newsScrollView setContentSize:CGSizeMake(r.size.width*[MenuSoureData count],r.size.height)];
    
    for (int i=0; i<6; i++) {
        NewsView *item=[[NewsView alloc] initWithFrame:CGRectMake(i*r.size.width, 0, r.size.width,r.size.height)];
        item.newsHelper.operType=i+1;
        item.tag=100+i;
        item.delegate=self;
        [_newsScrollView addSubview:item];
        if (i==0) {
            [item loadingData];
        }
    }
    [self.view addSubview:_newsScrollView];
    [self.view sendSubviewToBack:_newsScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger page=offset.x / bounds.size.width;
    _menuBar.selectedItemIndex=page;
}
#pragma mark NewsViewDelegate Methods
- (void)showNetworkError:(id)sender{
    [self showErrorNetWorkNotice:nil];
}
- (void)showLoadingFailureError:(id)sender{
    
}
- (void)selectedItemWithType:(int)type model:(WebNews*)entity sender:(id)sender{
    NewsDetailViewController *detail=[[NewsDetailViewController alloc] init];
    detail.Entity=entity;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark LightMenuBarDelegate
- (NSUInteger)itemCountInMenuBar:(LightMenuBar *)menuBar {
    return [MenuSoureData count];
}
- (NSString *)itemTitleAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    return [MenuSoureData objectAtIndex:index];
}

- (void)itemSelectedAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    NewsView *item=(NewsView*)[_newsScrollView viewWithTag:100+index];
    if (item) {
        [item loadingData];
    }
    [_newsScrollView setContentOffset:CGPointMake(index*_newsScrollView.bounds.size.width,0) animated:YES];
}

//< Optional
- (CGFloat)itemWidthAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    return 91.0f;
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
