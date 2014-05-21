//
//  NewsDetailViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *labTitle=[[UILabel alloc] initWithFrame:CGRectZero];
    labTitle.backgroundColor=[UIColor clearColor];
    labTitle.font=defaultBDeviceFont;
    labTitle.textAlignment=NSTextAlignmentCenter;
    labTitle.numberOfLines=0;
    labTitle.lineBreakMode=NSLineBreakByWordWrapping;
    labTitle.text=self.Entity.Title;
    CGSize size=[self.Entity.Title textSize:labTitle.font withWidth:self.view.bounds.size.width];
    labTitle.frame=CGRectMake((self.view.bounds.size.width-size.width)/2, 10, size.width, size.height);
    
    CGRect r=self.view.bounds;
    r.size.height=labTitle.frame.origin.y*2+size.height;
    UIView *viewBg=[[UIView alloc] initWithFrame:r];
    viewBg.backgroundColor=[UIColor colorFromHexRGB:@"f0f0f0"];
    [viewBg addSubview:labTitle];
    [self.view addSubview:viewBg];
    
    r=self.view.bounds;
    r.origin.y=viewBg.frame.size.height;
    r.size.height-=[self topHeight]+r.origin.y;
    UITextView *textView=[[UITextView alloc] initWithFrame:r];
    textView.editable=NO;
    textView.text=self.Entity.Content;
    textView.font=[UIFont fontWithName:defaultSDeviceFontName size:16];
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
