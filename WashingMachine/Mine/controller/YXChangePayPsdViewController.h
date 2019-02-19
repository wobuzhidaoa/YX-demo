//
//  YXChangePayPsdViewController.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/9.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "BaseWithNavViewController.h"

typedef void(^YXChangePayPsdBlcok)();

@interface YXChangePayPsdViewController : BaseWithNavViewController
@property(nonatomic,copy)YXChangePayPsdBlcok block;

/** 是否显示忘记密码 */
@property(nonatomic,assign)BOOL neegForget;

/** 顶部label显示文字 */
@property(nonatomic,copy)NSString *topStr;

/** 密码 */
@property(nonatomic,copy)NSString *psdwordStr;

/** 修改类型 */
@property(nonatomic,copy)NSString *type;
@end
