//
//  ApnsToken.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApnsToken : NSObject<NSCoding>
@property(nonatomic,copy) NSString *AppToken;
@property(nonatomic,assign) BOOL flags;
+(ApnsToken*)unarchiverApnsToken;
-(void)save;
@end
