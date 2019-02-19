//
//  UploadDownLoad.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/10/9.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownloadProgress)(CGFloat progress, CGFloat totalMBRead, CGFloat totalMBExpectedToRead);
typedef void(^DownloadSuccess)(NSURLResponse * response, NSURL * filePath, NSError * error);
typedef void(^DownloadFailure)(NSURLResponse * response, NSURL * filePath, NSError * error);

@interface UploadDownLoad : NSObject
#pragma mark ==========上传
- (NSDictionary *)UpLoading:(NSData *)data;
#pragma mark ==========下载
#pragma mark - 类方法

/**
 *  开始下载文件
 *
 *  @param URLString     文件链接
 *  @param cachePath          本地路径
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 *
 *  @return 下载任务
 */
+ (NSURLSessionDownloadTask *)downloadFileWithURLString:(NSString *)URLString
                                              cachePath:(NSString *)cachePath
                                          progressBlock:(DownloadProgress)progressBlock
                                           successBlock:(DownloadSuccess)successBlock
                                           failureBlock:(DownloadFailure)failureBlock;
/**
 *  暂停下载文件
 *
 *  @param operation 下载任务
 */
+ (void)pauseWithOperation:(NSURLSessionDownloadTask *)operation;

/**
 *  获取文件大小
 *
 *  @param path 本地路径
 *
 *  @return 文件大小
 */
+ (unsigned long long)fileSizeForPath:(NSString *)path;

#pragma mark - 实例方法

/**
 *  开始下载文件
 *
 *  @param URLString     文件链接
 *  @param cachePath          本地路径
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 *
 *  @return 下载任务
 */
- (NSURLSessionDownloadTask *)downloadFileWithURLString:(NSString *)URLString
                                              cachePath:(NSString *)cachePath
                                          progressBlock:(DownloadProgress)progressBlock
                                           successBlock:(DownloadSuccess)successBlock
                                           failureBlock:(DownloadFailure)failureBlock;
/**
 *  暂停下载文件
 *
 *  @param operation 下载任务
 */
- (void)pauseWithOperation:(NSURLSessionDownloadTask *)operation;

/**
 *  获取文件大小
 *
 *  @param path 本地路径
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeForPath:(NSString *)path;
@end
