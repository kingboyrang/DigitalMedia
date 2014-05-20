//
//  JobDetailViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "JobDetailViewController.h"
#import "ASIServiceHTTPRequest.h"
#import "TKDataDetailCell.h"
#import "RecruiterDetail.h"
@interface JobDetailViewController ()

@end

@implementation JobDetailViewController

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
    
    TKDataDetailCell *cell1=[[TKDataDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
   cell1.labName.text=@"廠商名稱:";
    
    TKDataDetailCell *cell2=[[TKDataDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell2.labName setText:@"職位名稱\n(職業類別):"];
    
    TKDataDetailCell *cell3=[[TKDataDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell3.labName setText:@"工作地點:"];
    
    TKDataDetailCell *cell4=[[TKDataDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell4.labName setText:@"計薪方式:"];
    
    TKDataDetailCell *cell5=[[TKDataDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell5.labName setText:@"聯絡方式:"];
    
    TKDataDetailCell *cell6=[[TKDataDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell6.labName setText:@"學經歷要求:"];
    
    self.cells =[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5,cell6, nil];
    
    if (!self.hasNewWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    [self showLoadingAnimatedWithTitle:@"正在加載,請稍後..."];
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.methodName=@"GetRecruitersDetail";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.PK,@"PK", nil], nil];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request success:^{
        BOOL boo=NO;
        
        XmlNode *node=[request.ServiceResult methodNode];
        if (node) {
            [request.ServiceResult.xmlParse setDataSource:node.InnerText];
            NSArray *arr=[request.ServiceResult.xmlParse selectNodes:@"//RecruiterDetail" className:@"RecruiterDetail"];
            if (arr&&[arr count]>0) {
                boo=YES;
                [self hideLoadingViewAnimated:nil];
                RecruiterDetail *mod=(RecruiterDetail*)[arr objectAtIndex:0];
                [self performSelectorOnMainThread:@selector(updateCellWithEntity:) withObject:mod waitUntilDone:NO];
            }
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:@"加載失敗!" completed:nil];
        }
        
    } failure:^{
        [self hideLoadingFailedWithTitle:@"加載失敗!" completed:nil];
    }];
}
- (void)updateCellWithEntity:(RecruiterDetail*)mod{
    TKDataDetailCell *cell1=self.cells[0];
    cell1.labDetail.text=mod.Company;
    
    TKDataDetailCell *cell2=self.cells[1];
    cell2.labDetail.text=mod.JobName;
    
    TKDataDetailCell *cell3=self.cells[2];
    cell3.labDetail.text=mod.WorkAddress;
    
    TKDataDetailCell *cell4=self.cells[3];
    cell4.labDetail.text=mod.PayMode;
    
    TKDataDetailCell *cell5=self.cells[4];
    cell5.labDetail.text=mod.Contact;
    
    TKDataDetailCell *cell6=self.cells[5];
    cell6.labDetail.text=mod.Education;
    
    [self.menuTable reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cells count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=self.cells[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    TKDataDetailCell *cell=self.cells[indexPath.row];
    CGSize size=[cell.labName.text textSize:cell.labName.font withWidth:100];
    CGSize size1=[cell.labDetail.text textSize:cell.labDetail.font withWidth:self.view.bounds.size.width-112-10];
    CGFloat h=size.height>size1.height?size.height:size1.height;
    h+=20;
    if (h>44.0f) {
        return h;
    }
    return 44.0;
}
@end
