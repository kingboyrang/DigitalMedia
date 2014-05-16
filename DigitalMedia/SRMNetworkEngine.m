//
//  SRMNetworkEngine.m
//  MKNetworkKit-iOS-Demo
//
//  Created by aJia on 2014/4/24.
//  Copyright (c) 2014年 Steinlogic. All rights reserved.
//

#import "SRMNetworkEngine.h"

@implementation SRMNetworkEngine
-(MKNetworkOperation*) operationWithArgs:(ServiceArgs*) args{
    MKNetworkOperation *op=[self operationWithPath:[args operationPath] params:nil httpMethod:args.httpMethod];
    op.stringEncoding=args.defaultEncoding;
    //body内容
    if (args.httpWay!=ServiceHttpGet) {
        [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
            return args.bodyMessage;
        } forType:args.contentType];
    }
    //设置请求头
    if(args.headers&&[args.headers count]>0)
    {
        [op addHeaders:args.headers];
    }
    [self enqueueOperation:op];
    return op;
}
- (void)requestWithArgs:(ServiceArgs*) args success:(MKNKResponseBlock)response failure:(MKNKResponseErrorBlock)error{
    MKNetworkOperation *opr=[self operationWithArgs:args];
    [opr addCompletionHandler:response errorHandler:error];
}
@end
