//
//  MovieViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MovieViewController.h"
#import "TKMenuItemCell.h"
#import "OrganViewController.h"
#import "HotMovieViewController.h"
#import "BasicMetaDataController.h"
#import "HappyMoviewController.h"
@interface MovieViewController ()

@end

@implementation MovieViewController

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
    CGFloat h=DeviceIsPad?256.0f:128.0f;
    CGRect r=self.view.bounds;
    r.size.height=h*2+30*2;
    //r.origin.y=DeviceIsPad?50:20;
    r.origin.y=(self.view.bounds.size.height-[self topHeight]-r.size.height-30)/2;
    _menuTable=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _menuTable.bounces=NO;
    _menuTable.dataSource=self;
    _menuTable.delegate=self;
    _menuTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_menuTable];
    
    TKMenuItemCell *cell1=[[TKMenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell1.leftMenuItem setImage:[self deviceImageWithName:@"happyEland" forType:@"png"] forState:UIControlStateNormal];
    [cell1.leftMenuItem addTarget:self action:@selector(buttonHappyClick:) forControlEvents:UIControlEventTouchUpInside];
    cell1.leftLabel.text=@"幸福宜蘭";
    [cell1.rightMenuItem setImage:[self deviceImageWithName:@"organMovie" forType:@"png"] forState:UIControlStateNormal];
    [cell1.rightMenuItem addTarget:self action:@selector(buttonOrganClick:) forControlEvents:UIControlEventTouchUpInside];
    cell1.rightLabel.text=@"機關類別";
    
    TKMenuItemCell *cell2=[[TKMenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell2.leftMenuItem setImage:[self deviceImageWithName:@"hotMovie" forType:@"png"] forState:UIControlStateNormal];
    [cell2.leftMenuItem addTarget:self action:@selector(buttonHotMovieClick:) forControlEvents:UIControlEventTouchUpInside];
    cell2.leftLabel.text=@"熱門影音";
    [cell2.rightMenuItem setImage:[self deviceImageWithName:@"newMovie" forType:@"png"] forState:UIControlStateNormal];
    [cell2.rightMenuItem addTarget:self action:@selector(buttonNewsMovieClick:) forControlEvents:UIControlEventTouchUpInside];
    cell2.rightLabel.text=@"最新影音";
    
    self.cells=[NSMutableArray arrayWithObjects:cell1,cell2, nil];
}
//幸福宜蘭
- (void)buttonHappyClick:(UIButton*)btn{
    HappyMoviewController *happyMovie=[[HappyMoviewController alloc] init];
    [self.navigationController pushViewController:happyMovie animated:YES];
}
//機關類別
- (void)buttonOrganClick:(UIButton*)btn{
    OrganViewController *organ=[[OrganViewController alloc] init];
    [self.navigationController pushViewController:organ animated:YES];
}
//熱門影音
- (void)buttonHotMovieClick:(UIButton*)btn{
    HotMovieViewController *hotMovie=[[HotMovieViewController alloc] init];
    [self.navigationController pushViewController:hotMovie animated:YES];
}
//最新影音
- (void)buttonNewsMovieClick:(UIButton*)btn{
    BasicMetaDataController *newsMovie=[[BasicMetaDataController alloc] init];
    newsMovie.dataType=@"4";
    [self.navigationController pushViewController:newsMovie animated:YES];
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
