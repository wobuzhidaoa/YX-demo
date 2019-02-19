//
//  UIBarButtonItem+Extension.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
// 设置导航栏的左右两边的item属性
+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

// 设置返回按钮
+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action title:(NSString *)title;

// 处理本项目的返回箭头
+ (UIBarButtonItem *)leftBarButtonItemWithImage:(NSString *)image  target:(id)target action:(SEL)action;
@end
