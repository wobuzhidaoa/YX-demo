//
//  AppDelegate.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomViewController.h"
#import "LoginViewController.h"
#import "BaseTabBarViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

//你好啊，测试下
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    BOOL isFirst = [UserDefaultsUtils boolValueWithKey:@"isFirst"];//判断第一次安装 第一次NO
    if (!isFirst) {
        [UserDefaultsUtils saveBoolValue:YES withKey:@"isFirst"];
        WelcomViewController *vc = [[WelcomViewController alloc]init];
        self.window.rootViewController = vc;
    }
    else{
//        NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
//        if (userInfo) {//是否登录
            BaseTabBarViewController *vc = [[BaseTabBarViewController alloc]init];
            self.window.rootViewController = vc;
//        }
//        else{
//            LoginViewController *vc = [[LoginViewController alloc]init];
//            self.window.rootViewController = vc;
//        }
    }
    
    
    [self initShareSDK];
    [self initMap];
    [self initGetuiSdk];
    
    [self registerUserNotification];
    
    return YES;
}

#pragma mark ====================高德
- (void)initMap{
    //配置高德地图用户Key
    [AMapServices sharedServices].apiKey = MAPKEY;
}
#pragma mark ====================个推
-(void)initGetuiSdk{
    // [ GTSdk ]：是否允许APP后台运行
    [GeTuiSdk runBackgroundEnable:YES];
    
    // [ GTSdk ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    
    // [ GTSdk ]：自定义渠道
    [GeTuiSdk setChannelId:@"GT-Channel"];
    
    // [ GTSdk ]：使用APPID/APPKEY/APPSECRENT创建个推实例
    [GeTuiSdk startSdkWithAppId:gtAppId appKey:gtAppKey appSecret:gtAppSecret delegate:self];
    
}
/** 注册用户通知 */
- (void)registerUserNotification {
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    // Register to receive notifica。tions.
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
        
    }else if ([identifier isEqualToString:@"answerAction"]){
        
    }
}
#endif

#pragma mark  从APNs服务器获取deviceToken后回调此方法
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    NLog(@"token = %@",token);
    
    
    // 个推设置deviceToken。
    [GeTuiSdk registerDeviceToken:token];
    
    [UserDefaultsUtils saveValue:token forKey:@"DeviceToken"];
}

#pragma mark - 远程通知(推送)回调
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err{
    NLog(@"\n>>>[DeviceToken Error]:%@\n\n", err.description);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    //是通过推送栏进入系统的标示;
    [UserDefaultsUtils saveValue:@"yes" forKey:@"PushLogin"];
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    // 控制台打印接收APNs信息
    NLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    NLog(@"%@",notification);
}
#pragma mark 个推回调
- (void)bindAlias:(NSString *)aAlias{
    return [GeTuiSdk bindAlias:aAlias andSequenceNum:@"绑定"];
}
- (void)unbindAlias:(NSString *)aAlias{
    return [GeTuiSdk unbindAlias:aAlias andSequenceNum:@"解绑"];
}
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NLog(@"\n>>[GTSdk RegisterClient]:%@\n\n", clientId);
}
/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}
/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:payloadData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    NLog(@"收到个推消息,推送dic=%@",dic);
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>[GTSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 通知SDK运行状态
    NSLog(@"\n>>[GTSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>[GTSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>[GTSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}
#pragma mark 程序的前后台切换
- (void)applicationWillResignActive:(UIApplication *)application {
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    if (!userInfo) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }else{
        NSString *numStr = [UserDefaultsUtils valueWithKey:@"redNumber"];
        NSInteger number = [numStr integerValue];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
        
        //个推角标同步
        [GeTuiSdk setBadge:number]; //同步本地角标值到服务器
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
    }
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self initGetuiSdk];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
}
#pragma mark ====================分享
- (void)initShareSDK{
    [ShareSDK registerApp:shareKey activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                                                     @(SSDKPlatformTypeSMS),
                                                     @(SSDKPlatformTypeWechat),
                                                     @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                                                         switch (platformType)
                                                         {
                                                             case SSDKPlatformTypeWechat:
                                                                 [ShareSDKConnector connectWeChat:[WXApi class]];
                                                                 break;
                                                             case SSDKPlatformTypeQQ:
                                                                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                                 break;
                                                             case SSDKPlatformTypeSinaWeibo:
                                                                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                                 break;
                                                             default:
                                                                 break;
                                                         }
                                                     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                                         switch (platformType)
                                                         {
                                                             case SSDKPlatformTypeSinaWeibo:
                                                                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                                                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1982173970"
                                                                                           appSecret:@"21ebd9f6fd3f16a88d628cf303389bdf"
                                                                                         redirectUri:@"http://www.sharesdk.cn"
                                                                                            authType:SSDKAuthTypeBoth];
                                                                 break;
                                                             case SSDKPlatformTypeWechat:
                                                                 [appInfo SSDKSetupWeChatByAppId:@"wx3839f3c1c20b7898"
                                                                                       appSecret:@"cf07cfd67468d3d0f5eaaa19c88d6568"];
                                                                 break;
                                                             case SSDKPlatformTypeQQ:
                                                                 [appInfo SSDKSetupQQByAppId:@"1106342586"
                                                                                      appKey:@"RSw1ti7ydmktxuZR"
                                                                                    authType:SSDKAuthTypeBoth];
                                                                 break;
                                                             default:
                                                                 break;
                                                         }
                                                     }];
}

#pragma mark ====================支付宝
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    //微信处理结果
    if ([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    
    return YES;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    
    //微信处理结果
    if ([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}


#pragma mark ====================微信
- (void)setWxPay{
    [WXApi registerApp:@""];
}
//前面的两个方法被iOS9弃用了，如果是Xcode7.2网上的话会出现无法进入进入微信的onResp回调方法，就是这个原因。本来我是不想写着两个旧方法的，但是一看官方的demo上写的这两个，我就也写了。。。。

//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}
@end
