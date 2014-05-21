//
//  PushDetailViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "PushDetailViewController.h"
#import "ShowPushDetail.h"
#import "ASIServiceHTTPRequest.h"
#import "CacheHelper.h"
@interface PushDetailViewController ()
@property(nonatomic,strong) UILabel *labTitle;
@property(nonatomic,strong) ShowPushDetail *showDetail;
@end

@implementation PushDetailViewController

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
    _labTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
	_labTitle.backgroundColor=[UIColor colorFromHexRGB:@"f0f0f0"];
    _labTitle.font=defaultBDeviceFont;
    _labTitle.textColor=[UIColor blackColor];
    _labTitle.numberOfLines=0;
    _labTitle.lineBreakMode=NSLineBreakByWordWrapping;
    _labTitle.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_labTitle];
    
    CGRect r=self.view.bounds;
    r.origin.y=_labTitle.frame.size.height;
    r.size.height-=[self topHeight]+r.origin.y;
    _showDetail=[[ShowPushDetail alloc] initWithFrame:r];
    [self.view addSubview:_showDetail];
    
    if (self.Entity) {
        if (![self.Entity.Subject isEqual:[NSNull null]]&&[self.Entity.Subject length]>0) {
            [self updateUIShow];
        }else{
            [self loadPushDetail:self.Entity.GUID];
        }
    }

}
-(void)updateUIShow{
    CGSize size=[self.Entity.Subject textSize:[UIFont boldSystemFontOfSize:16] withWidth:self.view.bounds.size.width];
    CGRect frame=_labTitle.frame;
    frame.size.height=size.height;
    if (size.height<40) {
        frame.size.height=40;
    }
    _labTitle.frame=frame;
    _labTitle.text=self.Entity.Subject;
    
    frame=_showDetail.frame;
    frame.origin.y=_labTitle.frame.size.height;
    frame.size.height=self.view.bounds.size.height-_labTitle.frame.size.height-[self topHeight];
    _showDetail.frame=frame;
    [_showDetail setTextContent:self.Entity.Body];
}
//加载一笔资料
-(void)loadPushDetail:(NSString*)guid{
    [self showLoadingAnimatedWithTitle:@"正在加載,請稍後..."];
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.serviceURL=PushWebServiceUrl;
    args.serviceNameSpace=PushWebServiceNameSpace;
    args.methodName=@"GetMessage";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:guid,@"guid", nil], nil];
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request success:^{
        BOOL boo=NO;
        XmlNode *node=[request.ServiceResult methodNode];
        if (node) {
             NSString *xml=[node.InnerText stringByReplacingOccurrencesOfString:@"xmlns=\"PushResult\"" withString:@""];
            [request.ServiceResult.xmlParse setDataSource:xml];
             NSArray *arr=[request.ServiceResult.xmlParse selectNodes:@"//Entity" className:@"PushResult"];
            if (arr&&[arr count]>0) {
                boo=YES;
                [self hideLoadingViewAnimated:nil];
                self.Entity=[arr objectAtIndex:0];
                [CacheHelper cacheCasePushResult:self.Entity];
                [self updateUIShow];
            }
            
        }
        if (!boo) {
             [self hideLoadingFailedWithTitle:@"資料加載失敗!" completed:nil];
        }
    } failure:^{
        [self hideLoadingFailedWithTitle:@"資料加載失敗!" completed:nil];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
