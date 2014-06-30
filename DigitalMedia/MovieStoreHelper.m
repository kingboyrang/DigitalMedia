//
//  MovieStoreHelper.m
//  DigitalMedia
//
//  Created by aJia on 2014/6/30.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MovieStoreHelper.h"
#import "MovieStore.h"
#import "FileHelper.h"
@interface MovieStoreHelper ()
@property (nonatomic,strong) NSMutableArray *movieStores;
@end

@implementation MovieStoreHelper

- (id)init{
    if (self=[super init]) {
        [self reloadData];
    }
    return self;
}

- (NSMutableArray*)storeMovies{
    return self.movieStores;
}
- (BOOL)existsFileName:(NSString*)name{
    if (self.movieStores&&[self.movieStores count]>0) {
        NSString *match=[NSString stringWithFormat:@"SELF.Name =='%@'",name];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [self.movieStores filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            return YES;
        }
    }
    return NO;
}
- (void)addStore:(MovieStore*)entity{
    if (![self existsFileName:entity.Name]) {//不存在
        //新增
        [self.movieStores insertObject:entity atIndex:0];
        [self saveWithSources:self.movieStores];
    }
}
- (void)deleteStoreWithRow:(NSInteger)index{
    //删除文件
    MovieStore *entity=self.movieStores[index];
    NSString *path=[DownFileFolderPath stringByAppendingPathComponent:entity.Name];
    [FileHelper deleteFileWithPath:path];
    [self.movieStores removeObjectAtIndex:index];
    [self saveWithSources:self.movieStores];
}
- (void)reloadData{
    NSString *path = [DocumentPath stringByAppendingPathComponent:@"MediaMovieCollection.db"];
    NSMutableArray *source=[NSMutableArray array];
    if([FileHelper existsFilePath:path]){
        [source addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile: path]];
    }
    self.movieStores=source;
}
//儲存
-(void)saveWithSources:(NSArray*)sources{
    if (sources&&[sources count]>0) {
         NSString *path = [DocumentPath stringByAppendingPathComponent:@"MediaMovieCollection.db"];
        [NSKeyedArchiver archiveRootObject:sources toFile:path];
    }
}
@end
