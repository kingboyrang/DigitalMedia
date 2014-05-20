//
//  SearchMetaDataHelper.m
//  DigitalMedia
//
//  Created by aJia on 2014/5/20.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "SearchMetaDataHelper.h"
#import "XmlParseHelper.h"
@implementation SearchMetaDataHelper
- (id)init{
    if (self=[super init]) {
        self.pager=[[DataPager alloc] init];
    }
    return self;
}
- (NSArray*)xmlSerializationWithXml:(NSString*)xml{
    NSString *filterXml=[xml stringByReplacingOccurrencesOfString:defaultWebServiceNameSpace withString:@""];
    XmlParseHelper *parse=[[XmlParseHelper alloc] init];
    [parse setDataSource:filterXml];
    XmlNode *node=[parse soapXmlSelectSingleNode:@"//CategorySearchMetaDataResult"];
    if (node) {
        [parse setDataSource:node.InnerText];
        //取得最大页数
        
        NSArray *arr=[parse selectNodes:@"//Pager" className:@"DataPager"];
        if (arr&&[arr count]>0) {
            self.pager=[arr objectAtIndex:0];
        }
        //查询所要的数据
        return [parse selectNodes:@"//SearchMetaData" className:@"SearchMetaData"];
    }
    return nil;
}
@end
