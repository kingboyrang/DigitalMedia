//
//  OpenHttpFileViewController.h
//  MediaCenter
//
//  Created by aJia on 13/1/24.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenHttpFileViewController : BasicViewController<UIDocumentInteractionControllerDelegate>{
    BOOL        _isShowing;
}

@property(nonatomic,copy) NSString *fileUrl;
@property(nonatomic,copy) NSString *fileDownLoadName;
@property(nonatomic,copy) NSString *fileType;
@property (nonatomic, retain) UIDocumentInteractionController *docInteractionController;
-(id)initWithURL:(NSURL*)aURL;
-(void)openWinPreview:(NSString*)filePath;
@end
