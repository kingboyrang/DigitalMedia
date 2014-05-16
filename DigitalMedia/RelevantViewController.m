//
//  RelevantViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "RelevantViewController.h"
#import "TKMenuItemCell.h"
#import "AppHelper.h"
@interface RelevantViewController ()

@end

@implementation RelevantViewController

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
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _menuTable=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _menuTable.bounces=NO;
    _menuTable.dataSource=self;
    _menuTable.delegate=self;
    _menuTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_menuTable];
    
    
    TKMenuItemCell *cell1=[[TKMenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell1.leftMenuItem setImage:[self deviceImageWithName:@"ElandGov" forType:@"png"] forState:UIControlStateNormal];
    [cell1.leftMenuItem addTarget:self action:@selector(buttonElandGovClick:) forControlEvents:UIControlEventTouchUpInside];
    cell1.leftLabel.text=@"宜蘭縣政府";
    [cell1.rightMenuItem setImage:[self deviceImageWithName:@"facebook_box" forType:@"png"] forState:UIControlStateNormal];
    [cell1.rightMenuItem addTarget:self action:@selector(buttonFacebookClick:) forControlEvents:UIControlEventTouchUpInside];
    cell1.rightLabel.text=@"宜蘭縣政府Facebook";
    
    TKMenuItemCell *cell2=[[TKMenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell2.leftMenuItem setImage:[self deviceImageWithName:@"trebox" forType:@"png"] forState:UIControlStateNormal];
    [cell2.leftMenuItem addTarget:self action:@selector(buttonBoxClick:) forControlEvents:UIControlEventTouchUpInside];
    cell2.leftLabel.text=@"宜蘭百寶箱";
    [cell2.rightMenuItem setImage:[self deviceImageWithName:@"publishing" forType:@"png"] forState:UIControlStateNormal];
    cell2.rightLabel.text=@"數位出版品";
    
    TKMenuItemCell *cell3=[[TKMenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell3.leftMenuItem setImage:[self deviceImageWithName:@"push" forType:@"png"] forState:UIControlStateNormal];
    cell3.leftLabel.text=@"推播訊息中心";
    [cell3.rightMenuItem setImage:[self deviceImageWithName:@"news" forType:@"png"] forState:UIControlStateNormal];
    cell3.rightLabel.text=@"最新消息";
    
    TKMenuItemCell *cell4=[[TKMenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell4.leftMenuItem setImage:[self deviceImageWithName:@"job" forType:@"png"] forState:UIControlStateNormal];
    cell4.leftLabel.text=@"求職專區";
    [cell4.rightMenuItem setImage:[self deviceImageWithName:@"benfit" forType:@"png"] forState:UIControlStateNormal];
    cell4.rightLabel.text=@"福利資訊";
    
    self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4, nil];
}
//宜蘭縣政府
- (void)buttonElandGovClick:(UIButton*)btn{
    [AppHelper openUrl:EGovURL];
}
//宜蘭縣政府Facebook
- (void)buttonFacebookClick:(UIButton*)btn{
    [AppHelper openUrl:EGovFacebookURL];
}
//宜蘭百寶箱
- (void)buttonBoxClick:(UIButton*)btn{
    [AppHelper openUrl:EGovBoxURL];
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
    CGFloat h=DeviceIsPad?256.0f:128.0f;
    return h+30;
}
@end
