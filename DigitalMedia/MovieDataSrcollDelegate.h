//
//  MovieDataSrcollDelegate.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/23.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MovieDataSrcollDelegate <NSObject>
@optional
- (void)scrollToPrevPageWithTarget:(id)sender;
- (void)scrollToNextPageWithTarget:(id)sender;
- (void)selectedItemWithIndex:(int)index sender:(id)sender;
- (void)stopScrollWithIndex:(int)index;
@end
