//
//  UploadDownLoad.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/10/9.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "UploadDownLoad.h"
#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return;}
#define DATA(X) [X dataUsingEncoding:NSUTF8StringEncoding]

// Posting constants
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; fileName=\"image.jpg\"\r\n Content-Type: image/jpeg/file\r\n\r\n"
#define STRING_CONTENT @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"

@interface UploadDownLoad()
@property (nonatomic, strong) NSMutableArray *paths;
@end

@implementation UploadDownLoad
#pragma mark ==========上传
//创建postdata
- (NSData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
{
    id boundary = @"------------0x0x0x0x0x0x0x0x";
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
    
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([value isKindOfClass:[NSData class]])
        {
            // handle image data
            NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT, [keys objectAtIndex:i]];
            [result appendData: DATA(formstring)];
            [result appendData:value];
        }
        else
        {
            // all non-image fields assumed to be strings
            NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
            [result appendData: DATA(formstring)];
            [result appendData:DATA(value)];
        }
        
        NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
    
    NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
}
- (NSMutableURLRequest *)setHeader:(NSMutableURLRequest *)mutRequest{
    [mutRequest setHTTPMethod: @"POST"];
    [mutRequest setValue:MULTIPART forHTTPHeaderField: @"Content-Type"];//上传的图片,格式为enctype="multipart/form-data"
    return mutRequest;
}
//上传图片
- (NSDictionary *) UpLoading:(NSData *)data
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *str = [formatter stringFromDate:[NSDate date]];
//    NSString *name = [NSString stringWithFormat:@"%@.png", str];
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
//    [post_dict setObject:name forKey:@"fileName"];
    [post_dict setObject:data forKey:@"file"];
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    [post_dict setObject:userInfo[@"userId"] forKey:@"userId"];
    
    NSData *postData = [self generateFormDataFromPostDictionary:post_dict];
    
    NSString * baseurl = [NSString stringWithFormat:@"%@imgupload",MURL];//@"http://zhixiang.tunnel.qydev.com/wechat/api/"
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [self setHeader:urlRequest];
    [urlRequest setHTTPBody:postData];
    
    // Submit & retrieve results
    NSError *error;
    NSURLResponse *response;
    NLog(@"开始上传---");
    NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (!result)
    {
        [YXShortcut showText:@"上传失败"];
        return nil;
    }
    // Return result
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        [YXShortcut showText:@"上传失败"];
        NLog(@"json解析失败：%@",err);
        return nil;
    }
    NLog(@"成功---");
    return dic;
}
#pragma mark ==========下载
- (NSMutableArray *)paths {
    
    if (!_paths) {
        
        _paths = [[NSMutableArray alloc] init];
    }
    
    return _paths;
}

#pragma mark - 类方法

+ (unsigned long long)fileSizeForPath:(NSString *)path {
    
    return [[self alloc] fileSizeForPath:path];
}

+ (NSURLSessionDownloadTask *)downloadFileWithURLString:(NSString *)URLString cachePath:(NSString *)cachePath progressBlock:(DownloadProgress)progressBlock successBlock:(DownloadSuccess)successBlock failureBlock:(DownloadFailure)failureBlock {
    
    return [[self alloc] downloadFileWithURLString:URLString
                                         cachePath:cachePath
                                     progressBlock:progressBlock
                                      successBlock:successBlock
                                      failureBlock:failureBlock];
}

+ (void)pauseWithOperation:(NSURLSessionDownloadTask *)operation {
    
    [[self alloc] pauseWithOperation:operation];
}

#pragma mark - 实例方法

- (unsigned long long)fileSizeForPath:(NSString *)path {
    
    signed long long fileSize = 0;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSError *error = nil;
        
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        
        if (!error && fileDict) {
            
            fileSize = [fileDict fileSize];
        }
    }
    
    return fileSize;
}

- (NSURLSessionDownloadTask *)downloadFileWithURLString:(NSString *)URLString cachePath:(NSString *)cachePath progressBlock:(DownloadProgress)progressBlock successBlock:(DownloadSuccess)successBlock failureBlock:(DownloadFailure)failureBlock {
    //远程地址
    NSURL *URL = [NSURL URLWithString:URLString];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    NSURLSessionDownloadTask *operation = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
            progressBlock(downloadProgress.completedUnitCount / downloadProgress.completedUnitCount,0,downloadProgress.totalUnitCount);
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = cachePath;
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        if (error) {
            failureBlock(response,filePath,error);
        }else{
            successBlock(response,filePath,error);
        }
    }];
    [operation resume];
    
    // 为了做暂停，把这个下载任务返回
    return operation;
}

- (void)pauseWithOperation:(NSURLSessionDownloadTask *)operation {
    
    
    [operation suspend];
}
@end
