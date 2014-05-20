//
//  JobEmploymentHelper.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "JobEmploymentHelper.h"
#import "XmlParseHelper.h"
@implementation JobEmploymentHelper
- (id)init{
    if (self=[super init]) {
        self.pager=[[DataPager alloc] init];
        self.operType=1;
    }
    return self;
}
- (NSString*)methodName{
    if (self.operType==1) {//職缺資訊
        return @"GetRecruitersList";
    }
    return @"GetActivityList";//求材活動資訊
}
- (NSString*)searchXpath{
    if (self.operType==1) {//職缺資訊
        return @"//Recruiters";
    }
    return @"//Activity";//求材活動資訊
}
- (ASIServiceArgs*)searchArgs{
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.pager.CurPage],@"curPage", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.pager.PageSize],@"pageSize", nil]];
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.methodName=[self methodName];
    args.soapParams=params;
    return args;
}
- (NSArray*)xmlSerializationWithXml:(NSString*)xml{
    XmlParseHelper *parse=[[XmlParseHelper alloc] init];
    [parse setDataSource:xml];
    //取得最大页数
        NSArray *arr=[parse selectNodes:@"//Pager" className:@"DataPager"];
        if (arr&&[arr count]>0) {
            self.pager=[arr objectAtIndex:0];
        }
    //查询所要的数据
    return [parse selectNodes:[self searchXpath] className:@"JobEmployment"];
}
@end
