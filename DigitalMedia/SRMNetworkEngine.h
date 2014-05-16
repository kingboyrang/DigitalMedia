//
//  SRMNetworkEngine.h
//  MKNetworkKit-iOS-Demo
//
//  Created by aJia on 2014/4/24.
//  Copyright (c) 2014年 Steinlogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceArgs.h"
#import "MKNetworkEngine.h"
@interface SRMNetworkEngine : MKNetworkEngine
- (MKNetworkOperation*) operationWithArgs:(ServiceArgs*) args;
- (void)requestWithArgs:(ServiceArgs*) args success:(MKNKResponseBlock)response failure:(MKNKResponseErrorBlock)error;
@end
