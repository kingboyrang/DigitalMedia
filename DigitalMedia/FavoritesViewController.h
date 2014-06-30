//
//  FavoritesViewController.h
//  DigitalMedia
//
//  Created by aJia on 2014/5/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStoreHelper.h"
@interface FavoritesViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>{

}
@property (nonatomic,strong) UITableView *movieTable;
@property (nonatomic,strong) UIDocumentInteractionController *documentController;
@property (nonatomic,strong) MovieStoreHelper *storeHelper;
@end
