//
//  OrgenMovieViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "OrgenMovieViewController.h"
#import "TKMetaDataCell.h"
#import "SearchMetaData.h"
#import "ASIServiceHTTPRequest.h"
#import "Department.h"
#import "MetaDetailViewController.h"
@interface OrgenMovieViewController ()

@end

@implementation OrgenMovieViewController

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
    [self.view addSubview:_menuTable];
    
    
    if (!self.hasNewWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.DEPT_CODE,@"topDept", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"childDept", nil]];
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.methodName=@"GetMetaDataByDept";
    args.soapParams=params;
    [self showLoadingAnimatedWithTitle:@"正在加載,請稍後..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request success:^{
        [self hideLoadingViewAnimated:nil];
        XmlNode *node=[request.ServiceResult methodNode];
        if (node) {
            [request.ServiceResult.xmlParse setDataSource:node.InnerText];
             self.listData=[request.ServiceResult.xmlParse selectNodes:@"//MetaDataByDept" className:@"SearchMetaData"];
            [_menuTable reloadData];
        }
    } failure:^{
        [self hideLoadingFailedWithTitle:@"加載失敗!" completed:nil];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.listData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MetaDataCell";
    TKMetaDataCell *cell = (TKMetaDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TKMetaDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    SearchMetaData *entity=self.listData[indexPath.row];
    cell.labTitle.text=[entity.C_NAME Trim];
    cell.labCategory.text=[NSString stringWithFormat:@"類別:%@",[entity.ClassCodeName Trim]];
    //单位
    NSString *unit=@"";
    if (entity.DEPT_NAME&&[entity.DEPT_NAME length]>0) {
        unit=[entity.DEPT_NAME Trim];
    }
    cell.labUnit.text=[NSString stringWithFormat:@"單位:%@",unit];
    cell.labDate.text=entity.formatDateText;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MetaDetailViewController *detail=[[MetaDetailViewController alloc] init];
    detail.Entity=self.listData[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
