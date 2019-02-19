//
//  CustomTextField.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/2.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

// 返回placeholderLabel的bounds，改变返回值，是调整placeholderLabel的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0 , self.bounds.size.width, self.bounds.size.height);
}
// 这个函数是调整placeholder在placeholderLabel中绘制的位置以及范围
- (void)drawPlaceholderInRect:(CGRect)rect {
    [super drawPlaceholderInRect:CGRectMake(0, 0 , self.bounds.size.width, self.bounds.size.height)];
}

@end
