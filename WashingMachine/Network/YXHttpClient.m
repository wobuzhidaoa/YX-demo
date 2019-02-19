//
//  YXHttpClient.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/11.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXHttpClient.h"

@implementation YXHttpClient


- (id)init{
    if (self = [super init]){
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
        self.manager.requestSerializer.timeoutInterval = 30.f;
        
        [self.manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
        
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        [securityPolicy setAllowInvalidCertificates:YES];
        [securityPolicy setValidatesDomainName:NO];
        self.manager.securityPolicy = securityPolicy;
    }
    return self;
}

+ (YXHttpClient *)defaultClient
{
    static YXHttpClient *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters prepareExecute:(PrepareExecuteBlock)prepareExecute
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [YXShortcut getReachabilityTypeComplete:^(BOOL isNetWork) {
        if (isNetWork) {
            
            //请求前处理
            if (prepareExecute) {
                prepareExecute();
            }
            
            [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
               //加载进度
            } success:success failure:failure];
        }
        else{
            [YXShortcut alertWithTitle:NETWORKERROR message:nil controller:[[UIApplication sharedApplication]keyWindow] buttonNumber:NO];
        }
    }];
}

@end
