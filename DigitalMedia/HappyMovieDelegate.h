//
//  HappyMovieDelegate.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HappyMovieDelegate <NSObject>
-(void)selectedItemWithModel:(id)entity type:(int)type sender:(id)sender;
@end
