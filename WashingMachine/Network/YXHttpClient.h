//
//  YXHttpClient.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/11.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, YXHttpRequestType) {
    YXHttpRequestGet,
    YXHttpRequestPost,
    YXHttpRequestDelete,
    YXHttpRequestPut,
};


/**
 *  请求开始前预处理Block
 */
typedef void(^PrepareExecuteBlock)(void);

@interface YXHttpClient : NSObject

@property(nonatomic,strong)AFHTTPSessionManager *manager;

+ (YXHttpClient *)defaultClient;
/**
 *  HTTP请求（GET、POST、DELETE、PUT）
 *
 *  url
 *  @param method     RESTFul请求类型
 *  @param parameters 请求参数
 *  @param prepare    请求前预处理块
 *  @param success    请求成功处理块
 *  @param failure    请求失败处理块
 */
- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock) prepare
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;




@end
