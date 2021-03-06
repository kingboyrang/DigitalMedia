//
//  AboutUsViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "AboutUsViewController.h"
#import "TKLabelCell.h"
#import "TKLabelLabelCell.h"
#import "UIBarButtonItem+TPCategory.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonWithTitle:@"1030509" target:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _menuTable=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _menuTable.bounces=NO;
    _menuTable.dataSource=self;
    _menuTable.delegate=self;
    _menuTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_menuTable];
    
    TKLabelCell *cell1=[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell1.label.textColor=[UIColor colorFromHexRGB:@"20549e"];
    cell1.label.text=@"·系統介紹:";
    cell1.label.font=defaultBDeviceFont;
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"systemIntroduce" ofType:@"txt"];
    NSString *content=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    TKLabelCell *cell2=[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell2.label.text=[content Trim];
    cell2.label.textAlignment=NSTextAlignmentLeft;
    cell2.label.font=defaultBDeviceFont;
    
    TKLabelLabelCell *cell3=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell3.labName.text=@"·網站連結:";
    cell3.labName.font=defaultBDeviceFont;
    cell3.labName.textColor=[UIColor colorFromHexRGB:@"20549e"];
    cell3.labDetail.text=@"http://dmc.e-land.gov.tw";
    
    TKLabelLabelCell *cell4=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell4.labName.text=@"·版本:";
    cell4.labName.font=defaultBDeviceFont;
    cell4.labName.textColor=[UIColor colorFromHexRGB:@"20549e"];
    cell4.labDetail.text=@"v2.1";
    cell4.labDetail.font=defaultBDeviceFont;
    
    TKLabelLabelCell *cell5=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell5.labName.text=@"·發佈日期:";
    cell5.labName.font=defaultBDeviceFont;
    cell5.labName.textColor=[UIColor colorFromHexRGB:@"20549e"];
    cell5.labDetail.text=@"103/05/01";
    cell5.labDetail.font=defaultBDeviceFont;
    
    TKLabelCell *cell6=[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell6.label.textColor=[UIColor colorFromHexRGB:@"800001"];
    cell6.label.text=@"宜蘭縣政府版權所有";
    cell6.label.font=defaultBDeviceFont;
    
    self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5,cell6, nil];
   
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cells count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=self.cells[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        TKLabelCell *cell=self.cells[indexPath.row];
        CGSize size=[cell.label.text textSize:cell.label.font withWidth:self.view.bounds.size.width-20];
        return size.height+2;
    }
    return 30.0;
}

@end
