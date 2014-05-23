//
//  UIImageView+DispatchLoad.m
//  MediaCenter
//
//  Created by aJia on 13/1/4.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "UIImageView+DispatchLoad.h"
#import "EGOCache.h"
#import "AFNetworking.h"
@implementation UIImageView (DispatchLoad)
- (void) setImageFromUrl:(NSString*)urlString {
    [self setImageFromUrl:urlString completion:NULL];
}
- (void) setImageFromUrl:(NSString*)urlString
              completion:(void (^)(void))completion {
    self.backgroundColor=[UIColor grayColor];
    __block UIActivityIndicatorView *activityIndicator = nil;
    if (!activityIndicator)
    {
        [self addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
        activityIndicator.center = self.center;
        [activityIndicator startAnimating];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *avatarImage = nil;
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        if (avatarImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityIndicator removeFromSuperview];
                activityIndicator = nil;
                CGRect parentRect=[[self superview] frame];
                CGSize size=[self autoZoomSize:parentRect.size orginSize:avatarImage.size];
                
                CGRect rect=CGRectMake((parentRect.size.width-size.width)/2, (parentRect.size.height-size.height)/2,size.width, size.height);
                self.frame=rect;
                self.image =avatarImage;
                if (completion) {
                    completion();
                }
            });
        }
        else {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }
    });
}
-(CGSize)autoZoomSize:(CGSize)defaultSize orginSize:(CGSize)size{
    CGFloat rotioW=size.width/defaultSize.width;
    CGFloat rotioH=size.height/defaultSize.height;
    CGSize newSize=size;
    if (size.width > defaultSize.width|| size.height > defaultSize.height){
        if (rotioW>rotioH) {
            newSize.width=defaultSize.width;
            newSize.height=size.height/rotioW;
        }else{
            newSize.width=size.width/rotioH;
            newSize.height=defaultSize.height;
        }
    }
    return newSize;
}
- (void)loadImageForURLString:(NSString *)aUR{
    [self loadImageForURL:[NSURL URLWithString:aUR] placeImage:nil];
}
- (void)loadImageForURL:(NSURL *)aURL placeImage:(UIImage*)placeimg {
    /**添加正在加载的效果**/
    self.backgroundColor=[UIColor grayColor];
    __block UIActivityIndicatorView *activityIndicator = nil;
    if (!activityIndicator)
    {
        [self addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
        activityIndicator.center = self.center;
        [activityIndicator startAnimating];
    }
    /**添加正在加载的效果**/
    if (placeimg) {
        self.image=placeimg;
    }
    if (!aURL) {
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
        return;
    };
    NSString *cacheKey = [NSString stringWithFormat:@"FSImageLoader-%lu", (unsigned long)[[aURL description] hash]];
    UIImage *anImage = [[EGOCache globalCache] imageForKey:cacheKey];
    if (anImage) {
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
        CGRect parentRect=[[self superview] frame];
        CGSize size=[self autoZoomSize:parentRect.size orginSize:anImage.size];
        CGRect rect=CGRectMake((parentRect.size.width-size.width)/2, (parentRect.size.height-size.height)/2,size.width, size.height);
        self.frame=rect;
        self.image =anImage;
    }
    else {
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:aURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0f];
        AFHTTPRequestOperation *imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        imageRequestOperation.outputStream= [NSOutputStream outputStreamToMemory];
        
        [imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            UIImage *image = [UIImage imageWithData:responseObject];
            [[EGOCache globalCache] setImage:image forKey:cacheKey];
            
            CGRect parentRect=[[self superview] frame];
            CGSize size=[self autoZoomSize:parentRect.size orginSize:image.size];
            
            CGRect rect=CGRectMake((parentRect.size.width-size.width)/2, (parentRect.size.height-size.height)/2,size.width, size.height);
            self.frame=rect;
            self.image =image;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }];
        [imageRequestOperation start];
    }
}
@end
