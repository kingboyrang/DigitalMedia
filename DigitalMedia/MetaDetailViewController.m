//
//  MetaDetailViewController.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/23.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MetaDetailViewController.h"
#import "ASIServiceHTTPRequest.h"
#import "SubMetaData.h"
#import "MetaDataBar.h"
#import "MovieScroll.h"
#import "ImageScroll.h"
#import "FileDownloadManager.h"
#import "MovieStore.h"
@interface MetaDetailViewController ()<MovieDataSrcollDelegate>

@end

@implementation MetaDetailViewController

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
    self.fileHelper=[[FileHttpRequest alloc] initWithDelegate:self];
    
     CGFloat topY=0,h=0;
    //資料別 1:圖片； 2：影音；3：聲音；4：檔案
    int type=[self.Entity.DTYPE intValue];
    if (type!=4) {
         topY= (self.view.bounds.size.height-[self topHeight]-44)/2;
         h=topY;
    }
    MetaDataBar *metaBar=[[MetaDataBar alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width, 44)];
    [metaBar.leftButton addTarget:self action:@selector(buttonPrevClick:) forControlEvents:UIControlEventTouchUpInside];
    [metaBar.rightButton addTarget:self action:@selector(buttonNextClick:) forControlEvents:UIControlEventTouchUpInside];
    [metaBar.fileButton addTarget:self action:@selector(buttonDownloadClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:metaBar];
    topY=metaBar.frame.origin.y+metaBar.frame.size.height;
    _dataTable=[[MetaDataTable alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width,self.view.bounds.size.height-[self topHeight]-topY)];
    [self.view addSubview:_dataTable];
    
    if (!self.hasNewWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    [self showLoadingAnimatedWithTitle:@"正在加載,請稍後..."];
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.methodName=@"GetSubMetaList";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.META_PK,@"metaPK", nil], nil];
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request success:^{
        BOOL boo=NO;
        XmlNode *node=[request.ServiceResult methodNode];
        if (node) {
            [self hideLoadingViewAnimated:nil];
            boo=YES;
            [request.ServiceResult.xmlParse setDataSource:node.InnerText];
             self.subMetas=[request.ServiceResult.xmlParse selectNodes:@"//SubMetaList" className:@"SubMetaData"];
            if (self.subMetas&&[self.subMetas count]>0) {
                [_dataTable loadingSourceDataWithModel:self.subMetas[0] withModel:self.Entity];
            }
           
            /********加载资料********/
            if (type==1) {//图片
                ImageScroll *imageScroll=[[ImageScroll alloc] initWithData:[self moviesWithType:type] frame:CGRectMake(0, 0, self.view.bounds.size.width, h)];
                imageScroll.tag=600;
                imageScroll.delegate=self;
                imageScroll.backgroundColor=[UIColor grayColor];
                [self.view addSubview:imageScroll];
            }else if(type==4){//檔案
                
            }else{
                MovieScroll *moviewScroll=[[MovieScroll alloc] initWithData:[self moviesWithType:type] youtube:[self yuTuBeURLs] frame:CGRectMake(0, 0, self.view.bounds.size.width, h)];
                moviewScroll.tag=600;
                moviewScroll.delegate=self;
                [self.view addSubview:moviewScroll];
                
            }
            /********加载资料********/
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:@"加載失敗!" completed:nil];
        }
    } failure:^{
        [self hideLoadingFailedWithTitle:@"加載失敗!" completed:nil];
    }];
}
- (NSArray*)moviesWithType:(int)type{
    NSMutableArray *source=[NSMutableArray array];
    if ([self.subMetas count]==0) {
        return source;
    }
    for (SubMetaData *item in self.subMetas) {
        if (type==1) {//1:圖片
            [source addObject:item.ImgPath];
        }
        if (type==2) {//影音
            [source addObject:item.MP4Path];
        }
        if (type==3) {//聲音
            [source addObject:item.DownLoadPath];
        }
        
    }
    return source;
}
- (NSArray*)yuTuBeURLs{
    int type=[self.Entity.DTYPE intValue];
    NSMutableArray *source=[NSMutableArray array];
    if ([self.subMetas count]==0) {
        return source;
    }
    int index=0;
    for (SubMetaData *item in self.subMetas) {
        if (type==2) {
            if (item.YoutubeVideo&&[item.YoutubeVideo length]>0) {
                 [source addObject:[NSDictionary dictionaryWithObjectsAndKeys:item.YoutubeVideo,@"value",[NSString stringWithFormat:@"%d",index],@"key", nil]];
            }
        }
        index++;
    }
    return source;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -FileHttpRequestDelegate Methods
-(void)startFileDownload:(NSString*)url withFileName:(NSString*)fileName{
    MovieStore *entity=[[MovieStore alloc] init];
    entity.Guid=[NSString createGUID];
    entity.DTYPE=self.Entity.DTYPE;
    entity.Dept=self.Entity.DEPT_NAME;
    entity.Name=[fileName lastPathComponent];
    //开始下载
    [[FileDownloadManager shareInitialization] downloadFile:url path:fileName withEntity:entity];
}
#pragma mark -MovieDataSrcollDelegate Methods
- (void)selectedItemWithIndex:(int)index sender:(id)sender{
    
}
- (void)stopScrollWithIndex:(int)index{
    [self.dataTable loadingSourceDataWithModel:self.subMetas[index] withModel:self.Entity];
}
#pragma mark -MetaDataBar Methods
//上一步
- (void)buttonPrevClick:(UIButton*)btn{
    if ([self.view viewWithTag:600]) {
        id v=[self.view viewWithTag:600];
        if ([v isKindOfClass:[MovieScroll class]]) {
            MovieScroll *item=(MovieScroll*)v;
            [item loadPrevMovie];
            [self.dataTable loadingSourceDataWithModel:self.subMetas[item.selectItemIndex] withModel:self.Entity];
        }else{
            ImageScroll *item=(ImageScroll*)v;
            [item buttonPrevImg];
             [self.dataTable loadingSourceDataWithModel:self.subMetas[item.selectItemIndex] withModel:self.Entity];
        }
    }
    
}
//下一步
- (void)buttonNextClick:(UIButton*)btn{
    if ([self.view viewWithTag:600]) {
        id v=[self.view viewWithTag:600];
        if ([v isKindOfClass:[MovieScroll class]]) {
            MovieScroll *item=(MovieScroll*)v;
            [item loadNextMovie];
            [self.dataTable loadingSourceDataWithModel:self.subMetas[item.selectItemIndex] withModel:self.Entity];
        }else{
            ImageScroll *item=(ImageScroll*)v;
            [item buttonNextImg];
            [self.dataTable loadingSourceDataWithModel:self.subMetas[item.selectItemIndex] withModel:self.Entity];
        }
    }
}
//文件下载
- (void)buttonDownloadClick:(UIButton*)btn{
    if ([self.view viewWithTag:600]) {
        id v=[self.view viewWithTag:600];
        int selectedRow;
        if ([v isKindOfClass:[MovieScroll class]]) {//影音
            MovieScroll *item=(MovieScroll*)v;
            selectedRow=item.selectItemIndex;
        }else{//圖片
            ImageScroll *scroll=(ImageScroll*)v;
            selectedRow=scroll.selectItemIndex;
        }
        if (self.subMetas&&[self.subMetas count]>0) {
            //資料別 1:圖片； 2：影音；3：聲音；4：檔案 DownLoadPath
            int type=[self.Entity.DTYPE intValue];
            SubMetaData *entity=self.subMetas[selectedRow];
            NSString *movieUrl=entity.DownLoadPath;
            if (type==2) {
                movieUrl=entity.MP4Path;
            }
            
            NSString *customFileName=[NSString stringWithFormat:@"%@_%d",entity.C_NAME,selectedRow];
            self.fileHelper.customDownloadFileName=customFileName;
            self.fileHelper.movieType=self.Entity.DTYPE;
            [self.fileHelper startFileRequest:movieUrl];

        }
       
    }
}
@end
