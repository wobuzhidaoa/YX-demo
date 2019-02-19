//
//  BaseHandler.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/11.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Handler处理完成后调用的Block
 */
typedef void (^CompleteBlock)();

/**
 *  Handler处理成功时调用的Block
 */
typedef void (^SuccessBlock)(id obj);

/**
 *  Handler处理失败时调用的Block
 */
typedef void (^FailedBlock)(id obj);


@interface BaseHandler : NSObject
/**
 是否显示loading 默认显示NO 不显示Yes
 */
@property(nonatomic,assign)BOOL hideLoading;
- (void) requestData:(NSDictionary *)param requestUrl:(NSString *)url present:(UIViewController *)vc success:(SuccessBlock)success failed:(FailedBlock)failed;
- (void)undoRequestUrl:(NSString *)urlStr withParam:(NSDictionary *)param isAll:(BOOL)isAllRequest;

@end
