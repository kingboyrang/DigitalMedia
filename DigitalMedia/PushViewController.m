//
//  PushViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "PushViewController.h"
#import "PushDetail.h"
#import "AlertHelper.h"
#import "CacheHelper.h"
#import "UIBarButtonItem+TPCategory.h"
#import "AppHelper.h"
#import "PushDetailViewController.h"
@interface PushViewController ()

@end

@implementation PushViewController

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
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonWithTitle:@"編輯" target:self action:@selector(buttonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _pushTable=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _pushTable.bounces=NO;
    _pushTable.dataSource=self;
    _pushTable.delegate=self;
    [self.view addSubview:_pushTable];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadPushInfo];
    [AppHelper asyncPushWithComplete:^(NSArray *source) {
        [self reloadPushInfo];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//编辑
- (void)buttonEditClick:(UIButton*)btn{
     [_pushTable setEditing:!_pushTable.editing animated:YES];
    if (_pushTable.editing) {
        [btn setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"編輯" forState:UIControlStateNormal];
    }
}
-(void)reloadPushInfo{
    NSArray *arr=[CacheHelper readCacheCasePush];
    if (arr&&[arr count]>0) {
        //排序
        NSSortDescriptor *_sorter  = [[NSSortDescriptor alloc] initWithKey:@"SendTime" ascending:NO];
        NSArray *sortArr=[arr sortedArrayUsingDescriptors:[NSArray arrayWithObjects:_sorter, nil]];
        self.listData=[NSMutableArray arrayWithArray:sortArr];
        [_pushTable reloadData];
    }
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellPushIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        PushDetail *detail=[[PushDetail alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 53)];
        detail.tag=100;
        [cell.contentView addSubview:detail];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    PushResult *entity=[self.listData objectAtIndex:indexPath.row];
    PushDetail *pushDetail=(PushDetail*)[cell viewWithTag:100];
    [pushDetail setDataSource:entity];
    
    return cell;
}
//默认编辑模式为删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger deleteRow=indexPath.row;
    [AlertHelper initWithTitle:@"提示" message:@"確定是否刪除?" cancelTitle:@"取消" cancelAction:nil confirmTitle:@"確定" confirmAction:^{
        PushResult *entity=[self.listData objectAtIndex:deleteRow];
        [CacheHelper cacheDeletePushWithGuid:entity.GUID];
        //删除绑定数据
        [self.listData removeObjectAtIndex:deleteRow];
        //重新写入文件中
        [CacheHelper cacheCasePushFromArray:self.listData];
        //行的删除
        NSMutableArray *indexPaths = [NSMutableArray array];
        [indexPaths addObject:[NSIndexPath indexPathForRow:deleteRow inSection:0]];
        [_pushTable beginUpdates];
        [_pushTable deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [_pushTable endUpdates];
        [AlertHelper initWithTitle:@"提示" message:@"刪除成功!"];
    }];
    
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PushDetailViewController *detail=[[PushDetailViewController alloc] init];
    detail.Entity=self.listData[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
