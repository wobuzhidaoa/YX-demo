//
//  YXThirdParty.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/10.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#ifndef YXThirdParty_h
#define YXThirdParty_h

//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#define shareKey @"2011334a79470"

//支付宝
#import <AlipaySDK/AlipaySDK.h>

#define safPayId @"2017091608767202"
#define safPayKey @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCNg4WFGhd7Qa6R6nIvXGXf8I5Ktplty7ziLlcvD2k4kOCrxhA0XTq+9r7Mj/VaxQsTlpuKmu/MSkW38K7PBw0HGnfDdwmy+sNvtE60ni1dw/a7kPDLJxSaKxp4kgEiCX+4PdH1e4A8IUggVzyWsELuZ77B5MgVFlEyoeIVk2k06tXJF/QWZElGaDq7a5nyFeW/c+Gd8z6wqEEfyjw5pklggNiZCz8RvmjtxK+2ZyvTjaCLtHNwBRANJp+nWE8DRqQtdrRt4Aj1ZwuNByXlYvRrQb2xYUdZTXIiPpTMr+Yz6ZRThI4spluFQAY4FQPvtcfNUk9MyAVFM5kcjCB/cmz7AgMBAAECggEAKtNHf91Ch+l7o+rYPV7v8ZJB7XhO/Dww4B34AmTeieDGLRWWZ9Ji6dGQMiXKsXp5/KaSUaLLuP4tFRpAPKS8m461+bA3fjOHG3Hsc5p+ziZ0r5SQWlpsUK+EpkJBF4TaYu5KcMi8KPZFdowP6OZUiwNYZiMPLdqAHhuBaNggeYO4MqN2ZFrvcYkxEiMyJtw9ghkEbA/Y1lzz9K3BUi1/PfIsVPaFl0/hoNMxlFx28u9uEoNyhP3bXwti5QTXAdW9L8NmPkuxtt3kNrqJCS0S8sOxOp5jLY/MR5jD+V9D6rAILYSr7+Idyb8ADiDHq7+8NoYpKaXPt5PZLcHzFYURuQKBgQDOjMaq3ppS+wg5ie2MYQEkaY2uAEjnvfXm8DQdtPshAQo3op/cto/gyuj4FxtVm61ejjRrN7m7ABQm1iN0PrDLAa3l7D41sK1EF5n6WEfq71iaWs3ceoSp6HkVfw47m+w64+94miGoWvgpxe3pRHQD31gDiUACReHFG1+EJ0zYxQKBgQCvZL/DZ8NN5LliGccBCFS7/MOkCqe7yzbpPBJrz5Zyved9pSdq5zzsuvPz7uKR4RrigxoSuJ5ZsvqegLDvzIOVYsOUNLPbeHcVZplA07JkXqqS+TtTEad4HWmZc9/JrR7O3R6mRjhDpMqKw4nWoA+EDv2x2pkLlsJjGvZcgmEKvwKBgBEwagAiUlmBhqezMM+z6vJqzl2irG6MwoAbkVq/iv6uJXmH0SH/F24vtL+gvKedMwphbz9U/eHwGb05qO2toezjEOPHi03QjDrUc/3/hsyoaok98U/d6lhxflIppreTPE+SVIWG3jIyj+B6FliJV9ZSqfJxY6BMzIMoygQneR+5AoGAAT6Uwb0tvJK/4ftO1yoI9+B+Pt64e/OgKx16//rUFXJVfyW51t9XJlLZQkTSpLhVKYBGohVfQkGr144QM1NfJ6Mwwg9xqz/6kFNPCQ+3d1DYovxTuG4qowaKZkVVNCgfTNZyzjk3UvuLWFq00qoGEijNEgL8DQH/1RYu408lgx8CgYEAgF1EAACoL6cf/pkUbEUcRGJrUU/DkpOU6CNr6NCYTt+KGMRNkAEVjGrDznCR4DEc6qoCG8cCc4/kW++N/hiEe3dyvilLI8SzYj/D0i599PZU4DCWByTZd1k0bcdHzzt5lmClB8Ut2m1b6cNbrahssGUykdJE/PY5Odx7DlRjxUs="

//微信
#import "WXApi.h"
#define wxPayKey @""

//高德
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#define MAPKEY @"2285de8384b6de37d010b4dfe13a0409"

/** 地图定位时间 */
#define DefaultLocationTimeout  3
#define DefaultReGeocodeTimeout 3

//个推
#import <GeTuiSdk.h>
#define gtAppId @""
#define gtAppKey @""
#define gtAppSecret @""

#endif
