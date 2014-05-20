//
//  JobAreaViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "JobAreaViewController.h"
#import "ASIServiceHTTPRequest.h"
@interface JobAreaViewController ()

@end

@implementation JobAreaViewController

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
    _topView=[[JobTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [self.view addSubview:_topView];
    
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"curPage", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pageSize", nil]];
    
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.methodName=@"GetRecruitersList";
    args.soapParams=params;
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request success:^{
        XmlNode *node=[request.ServiceResult methodNode];
        NSLog(@"xml=%@",node.InnerText);
    } failure:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
