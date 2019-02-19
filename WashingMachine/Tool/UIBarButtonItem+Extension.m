//
//  UIBarButtonItem+Extension.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
// 设置导航栏的左右两边的item属性
+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置图片
    if (image.length) {
        [Btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [Btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    }
    
    [Btn sizeToFit];
    
    // 监听点击
    [Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:Btn];
}

+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置图片
    if (image.length) {
        [Btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [Btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    }
    
    [Btn setTitle:title forState:UIControlStateNormal];
    
    // 设置文字
    [Btn setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
    [Btn setTitleColor:[YXColor whiteColor] forState:UIControlStateHighlighted];
    
    // 设置文字大小
    Btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [Btn sizeToFit];
    
    // 监听点击
    [Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:Btn];
}

// 处理本项目的返回箭头
+ (UIBarButtonItem *)leftBarButtonItemWithImage:(NSString *)image  target:(id)target action:(SEL)action
{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置图片
    [Btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [Btn sizeToFit];
    Btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    // 监听点击
    [Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:Btn];
}
@end
