//
//  OrganViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "OrganViewController.h"
#import "ASIServiceHTTPRequest.h"
#import "Department.h"
#import "OrgenMovieViewController.h"
@interface OrganViewController ()

@end

@implementation OrganViewController

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
    self.view.backgroundColor=[UIColor redColor];
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _menuTable=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _menuTable.bounces=NO;
    _menuTable.dataSource=self;
    _menuTable.delegate=self;
    [self.view addSubview:_menuTable];
    
     [self showLoadingAnimatedWithTitle:@"正在加載,請稍後..."];
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.methodName=@"GetFirstDeptList";
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request success:^{
        [self hideLoadingViewAnimated:nil];
        XmlNode *node=[request.ServiceResult methodNode];
        if (node) {
            [request.ServiceResult.xmlParse setDataSource:node.InnerText];
            self.listData=[request.ServiceResult.xmlParse selectNodes:@"//Department" className:@"Department"];
            [_menuTable reloadData];
        }
        
    } failure:^{
        [self hideLoadingFailedWithTitle:@"加載失敗!" completed:nil];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellDeptIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    Department *entity=self.listData[indexPath.row];
    cell.textLabel.text=entity.DEPT_NAME;
    cell.textLabel.font=[UIFont fontWithName:defaultDeviceFontName size:17];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"影片數量:%@",entity.MetaCount];
    cell.detailTextLabel.font=[UIFont fontWithName:defaultDeviceFontName size:17];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrgenMovieViewController *orginMovie=[[OrgenMovieViewController alloc] init];
    [self.navigationController pushViewController:orginMovie animated:YES];
}
@end
