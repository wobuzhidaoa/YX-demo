//
//  YXTextboxViewController.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/23.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "BaseWithNavViewController.h"

typedef void(^YXTextboxViewBlock)(NSString *str);

@interface YXTextboxViewController : BaseWithNavViewController
@property(nonatomic,copy)YXTextboxViewBlock block;
/**
 是否多行文本 默认NO
 */
@property(nonatomic,assign)BOOL isMoreRow;
/**
 键盘类型
 */
@property(nonatomic,assign)UIKeyboardType keyType;
/**
 限制字数 默认0不限制
 */
@property(nonatomic,assign)NSInteger type;
@end
