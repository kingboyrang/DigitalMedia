//
//  BasicTabBarController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/15.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicTabBarController.h"
#import "UIImage+TPCategory.h"
#import "MovieViewController.h"
#import "CountyZoneViewController.h"
#import "FavoritesViewController.h"
#import "RelevantViewController.h"
#import "AboutUsViewController.h"
@interface BasicTabBarController ()

@end

@implementation BasicTabBarController

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
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor],UITextAttributeTextColor,
                                    [UIFont boldSystemFontOfSize:11],UITextAttributeFont,
                                    [UIColor grayColor],UITextAttributeTextShadowColor,
                                    [NSValue valueWithCGSize:CGSizeMake(1, 1)],UITextAttributeTextShadowOffset,
                                    nil];
    
    UITabBarItem *barItem1=[[UITabBarItem alloc] init];
    [barItem1 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    barItem1.title=@"影音專區";
    barItem1.tag=0;
    [barItem1 setFinishedSelectedImage:[UIImage imageNamed:@"movieArea_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"movieArea_normal.png"]];
    MovieViewController *movieController=[[MovieViewController alloc] init];
    //movieController.tabBarItem=barItem1;
    UINavigationController *nav1=[[UINavigationController alloc] initWithRootViewController:movieController];
    nav1.tabBarItem=barItem1;
    
    
    UITabBarItem *barItem2=[[UITabBarItem alloc] init];
    [barItem2 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    barItem2.title=@"縣長專區";
    barItem2.tag=1;
    [barItem2 setFinishedSelectedImage:[UIImage imageNamed:@"movieDistrict_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"movieDistrict_normal.png"]];
    CountyZoneViewController *CountyZone=[[CountyZoneViewController alloc] init];
    //CountyZone.tabBarItem=barItem2;
    UINavigationController *nav2=[[UINavigationController alloc] initWithRootViewController:CountyZone];
    nav2.tabBarItem=barItem2;
    
    UITabBarItem *barItem3=[[UITabBarItem alloc] init];
    [barItem3 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    barItem3.title=@"影音收藏";
    barItem3.tag=2;
    [barItem3 setFinishedSelectedImage:[UIImage imageNamed:@"moviefavorite_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"moviefavorite_normal.png"]];
    FavoritesViewController *Favorites=[[FavoritesViewController alloc] init];
    //Favorites.tabBarItem=barItem3;
    UINavigationController *nav3=[[UINavigationController alloc] initWithRootViewController:Favorites];
    nav3.tabBarItem=barItem3;
    
    UITabBarItem *barItem4=[[UITabBarItem alloc] init];
    [barItem4 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    barItem4.title=@"相關資訊";
    barItem4.tag=3;
    [barItem4 setFinishedSelectedImage:[UIImage imageNamed:@"box_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"box_normal.png"]];
    RelevantViewController *Relevant=[[RelevantViewController alloc] init];
    //Relevant.tabBarItem=barItem4;
    UINavigationController *nav4=[[UINavigationController alloc] initWithRootViewController:Relevant];
    nav4.tabBarItem=barItem4;
    
    UITabBarItem *barItem5=[[UITabBarItem alloc] init];
    [barItem5 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    barItem5.title=@"關於我";
    barItem5.tag=4;
    [barItem5 setFinishedSelectedImage:[UIImage imageNamed:@"about_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"about_normal.png"]];
    AboutUsViewController *AboutUs=[[AboutUsViewController alloc] init];
    //AboutUs.tabBarItem=barItem5;
    UINavigationController *nav5=[[UINavigationController alloc] initWithRootViewController:AboutUs];
    nav5.tabBarItem=barItem5;
    
    
    //修改背景颜色
    UIView *bgView=[[UIView alloc] initWithFrame:self.tabBar.bounds];
    UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
    [tabBarBgView setImage:[UIImage createImageWithColor:[UIColor colorFromHexRGB:@"2b8299"] imageSize:self.tabBar.bounds.size]];
    [tabBarBgView setContentMode:UIViewContentModeScaleToFill];
    [tabBarBgView setAutoresizesSubviews:YES];
    [tabBarBgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [bgView addSubview:tabBarBgView];
    [bgView setAutoresizesSubviews:YES];
    [bgView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.tabBar insertSubview:bgView atIndex:1];
    self.tabBar.opaque=YES;
    
    self.viewControllers=[NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5, nil];
    //[self setViewControllers:[NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5, nil]];
    //self.selectedIndex=0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
