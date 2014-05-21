//
//  WebNewsHelper.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "WebNewsHelper.h"
#import "XmlParseHelper.h"
@implementation WebNewsHelper
- (id)init{
    if (self=[super init]) {
        self.pager=[[DataPager alloc] init];
        self.operType=1;
    }
    return self;
}
- (ASIServiceArgs*)searchArgs{
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.operType],@"type", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.pager.CurPage],@"curPage", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.pager.PageSize],@"pageSize", nil]];
    ASIServiceArgs *args=[[ASIServiceArgs alloc] init];
    args.methodName=@"GetWebNewsByType";
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
    return [parse selectNodes:@"//WebNews" className:@"WebNews"];
}
@end
