//
//  FileHelper.h
//  Eland
//
//  Created by aJia on 13/10/4.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject
/**
 ** @reutrn 取得document文件路徑
 **/
+ (NSString*)documentFilePath;
/**
 ** @reutrn 取得快取文件路徑
 **/
+ (NSString*)cacheFilePath;
/**
 ** @param path 文件路徑
 ** @reutrn 建立文件目錄
 **/
+ (void)createDirectoryWithPath:(NSString*)path;
/**
 ** @param path 文件路徑
 ** @param name 目錄名
 ** @reutrn 建立文件目錄
 **/
+ (NSString*)createDirectoryWithPath:(NSString*)path directoryName:(NSString*)name;
/**
 ** @param name 目錄名
 ** @reutrn 建立document文件目錄
 **/
+ (NSString*)createDocumentDirectoryWithName:(NSString*)name;
/**
 ** @param fromPath copy項從那裡的路徑開始
 ** @param toPath 將copy項保存到這個路徑
 ** @reutrn 將文件cope到另一個文件路徑
 **/
+ (void)copyItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath;
/**
 ** @param fromPath copy項從那裡的路徑開始
 ** @param toPath 將copy項保存到這個路徑
 ** @reutrn 將文件move到另一個文件路徑
 **/
+ (void)moveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath;
/**
 ** @param name 文件路徑
 ** @reutrn 删除文件
 **/
+ (void)deleteFileWithPath:(NSString*)path;
/**
 ** @reutrn 判斷文件是否存在
 **/
+ (BOOL)existsFilePath:(NSString*)path;

@end
