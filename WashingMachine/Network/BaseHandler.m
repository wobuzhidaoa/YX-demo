//
//  BaseHandler.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/11.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "BaseHandler.h"
#import "YXHttpClient.h"

@interface BaseHandler ()
@property(nonatomic,strong)YXHttpClient *client;
@property (nonatomic ,strong)MBProgressHUD *hud;
@end

@implementation BaseHandler

- (instancetype)init{
    if ( self == [super init]) {
        self.client = [YXHttpClient defaultClient];
    }
    return self;
}

#pragma mark 网络请求
- (void) requestData:(NSDictionary *)param requestUrl:(NSString *)url present:(UIViewController *)vc success:(SuccessBlock)success failed:(FailedBlock)failed
{
    url = [NSString stringWithFormat:@"%@%@",MURL,url];
    PrepareExecuteBlock prepar = ^(void){
        //处理loading 之类
        if (!self.hideLoading) {
            [self showLoadingForViewController:vc];
        }
    };
    
    //请求
    [self.client requestWithPath:url method:YXHttpRequestPost parameters:param prepareExecute:prepar success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功
        NLog(@"url=%@ dic=%@ responseObject=%@",url,param,responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if (![code isEqualToString:@"0"]) {
            [YXShortcut showText:responseObject[@"msg"]];
        }
        success(responseObject);
        
        if (!self.hideLoading) {
            [self dismissLoading];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //失败
        NLog(@"url=%@ dic=%@ error=%@",url,param,error);
        failed(error);
        if (!self.hideLoading) {
            [self dismissLoading];
        }
    }];
}
#pragma mark 撤销请求
- (void)undoRequestUrl:(NSString *)urlStr withParam:(NSDictionary *)param isAll:(BOOL)isAllRequest
{
    NSURL *URL = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionDataTask *task = [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    if (isAllRequest) {
        //取消当前所有
        [manager.operationQueue cancelAllOperations];
    }
    else{
        //取消单个请求
        [task cancel];
    }
}

#pragma mark loading
- (void)showLoadingForViewController:(UIViewController *)vc
{
    if(vc != nil &&  [vc isKindOfClass:[UIViewController class]]){
        _hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    }else{
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        _hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    }
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.margin = 8;
    _hud.label.text = @" 加载中... ";
    _hud.label.font = [UIFont systemFontOfSize:15];
    _hud.contentColor = [YXColor whiteColor];
    _hud.customView.bounds = CGRectMake(0, 0, 50, 50);
    _hud.bezelView.backgroundColor = [YXColor blackColor];
}

- (void)dismissLoading
{
    [_hud hideAnimated:YES afterDelay:.5];
    [_hud removeFromSuperview];
}

@end
