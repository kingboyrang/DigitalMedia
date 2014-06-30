//
//  FavoritesViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "FavoritesViewController.h"
#import "UIBarButtonItem+TPCategory.h"
#import "MovieStore.h"
#import "AlertHelper.h"
#import "OpenHttpFileViewController.h"
@interface FavoritesViewController ()
-(void)openDocumentUrl:(NSString*)fileUrl;
@end

@implementation FavoritesViewController

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
    
    self.storeHelper=[[MovieStoreHelper alloc] init];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonWithTitle:@"編輯" target:self action:@selector(buttonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _movieTable=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _movieTable.delegate=self;
    _movieTable.dataSource=self;
    [self.view addSubview:_movieTable];
}
//編輯
- (void)buttonEditClick:(UIButton*)btn{
    [self.movieTable setEditing:!self.movieTable.editing animated:YES];
	if(self.movieTable.editing)
		[btn setTitle:@"完成" forState:UIControlStateNormal];
	else {
        [btn setTitle:@"編輯" forState:UIControlStateNormal];
	}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//打开一个档案
-(void)openDocumentUrl:(NSString*)fileUrl{
    NSURL *url=[NSURL fileURLWithPath:fileUrl];
    if (self.documentController) {
        self.documentController=nil;
    }
    self.documentController = [UIDocumentInteractionController  interactionControllerWithURL:url];
    self.documentController.delegate=self;
    CGRect navRect = self.navigationController.navigationBar.frame;
    navRect.size = CGSizeMake(1500.0f, 40.0f);
    [self.documentController presentOptionsMenuFromRect:navRect inView:self.view  animated:YES];
}
#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate Methods
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
{
    return self;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.view.frame;
}
// 点击预览窗口的“Done”(完成)按钮时调用
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)_controller
{
    self.documentController=nil;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.storeHelper.storeMovies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellFavoriteIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    MovieStore *entity=self.storeHelper.storeMovies[indexPath.row];
    cell.textLabel.text=entity.Name;
    
    cell.detailTextLabel.numberOfLines=0;
    cell.detailTextLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n單位:%@",entity.Date,entity.Dept];
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
//默认编辑模式为删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [AlertHelper initWithTitle:@"提示" message:@"確定是否刪除?" cancelTitle:@"取消" cancelAction:nil confirmTitle:@"確定" confirmAction:^{
        [self.storeHelper deleteStoreWithRow:indexPath.row];
        //行的删除
        NSMutableArray *indexPaths = [NSMutableArray array];
        [indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        [self.movieTable beginUpdates];
        [self.movieTable deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.movieTable endUpdates];
        [AlertHelper initWithTitle:@"提示" message:@"刪除成功!"];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     MovieStore *entity=self.storeHelper.storeMovies[indexPath.row];
     [self openDocumentUrl:entity.path];
}
@end
