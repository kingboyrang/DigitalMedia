//
//  Global.h
//  Eland
//
//  Created by aJia on 13/9/27.
//  Copyright (c) 2013年 rang. All rights reserved.
//

//http://60.251.51.217/Pushs.Admin/WebServices/Push.asmx

#define DataAccessURL @"http://60.251.51.217/Pushs.Admin/WebServices/CasesAdminURL.aspx?get=elandmc"

#define DataWebPath [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]
#define DataServicesSource [NSArray arrayWithContentsOfFile:DataWebPath]
#define DataCaseUrlPre [DataServicesSource objectAtIndex:0]
#define DataPushUrlPre [DataServicesSource objectAtIndex:1]

//测试
#define defaultWebServiceUrl [NSString stringWithFormat:@"%@MDC.asmx",DataCaseUrlPre]
#define defaultWebServiceNameSpace @"http://tempuri.org/"
//推播信息webservice
#define PushWebServiceUrl [NSString stringWithFormat:@"%@WebServices/Push.asmx",DataPushUrlPre]
#define PushWebServiceNameSpace @"http://CIRMSG.e-land.gov.tw/"


//获取设备的物理大小
#define IOSVersion [[UIDevice currentDevice].systemVersion floatValue]
#define DeviceRect [UIScreen mainScreen].bounds
#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define StatusBarHeight 20 //状态栏高度
#define TabHeight 59 //工具栏高度
#define DeviceRealHeight DeviceHeight-20
#define DeviceRealRect CGRectMake(0, 0, DeviceWidth, DeviceRealHeight)
//路径设置
#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define TempPath NSTemporaryDirectory()
//设备
#define DeviceIsPad UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad

//界面颜色设置
#define defaultDeviceFontColorName @"e32600"
#define defaultDeviceFontName @"Courier-Bold"
#define defaultDeviceFontColor [UIColor colorFromHexRGB:defaultDeviceFontColorName]
#define defaultBDeviceFont [UIFont fontWithName:defaultDeviceFontName size:16]
#define defaultSDeviceFont [UIFont fontWithName:defaultDeviceFontName size:14]
#define defaultSmallFont [UIFont fontWithName:@"Courier" size:14]

//数据库配置路径
//#define HEDBPath [[NSBundle mainBundle] pathForResource:@"HsinchuElderly" ofType:@"sqlite"]
#define HEDBPath [DocumentPath stringByAppendingPathComponent:@"HsinchuElderly.sqlite"]

//图片上传 
#define DataWebserviceURL @"http://192.168.123.150:8080/WebService.asmx"
#define DataWeserviceNameSpace @"http://tempuri.org/"

//宜蘭縣政府
#define EGovURL @"http://www.e-land.gov.tw/"
//宜蘭縣政府Facebook
#define EGovFacebookURL @"http://www.facebook.com/PlanEland?fref=ts&rf=143095005752739"
//宜蘭百寶箱
#define EGovBoxURL @"http://APPS.e-land.gov.tw"
#define CountyZoneFacebookURL @"http://www.facebook.com/pages/幸福宜蘭-林聰賢/150474111655916"
#define CountyZonePlurkURL @"http://www.plurk.com/YilanFirst"






