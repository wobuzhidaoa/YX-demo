//
//  YXColor.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/3.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXColor : NSObject
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
/** 主体颜色 导航栏，图标，按钮背景 */
+ (UIColor *)blueFirColor;
/** 和主体颜色相区分的辅助色 */
+ (UIColor *)greenColor;
/** 按钮点击颜色 */
+ (UIColor *)blueSecColor;
/** 未激活的按钮背景色，登录等 */
+ (UIColor *)blueThrColor;
/** 文字黑 */
+ (UIColor *)blackColor;
/** 文字灰 */
+ (UIColor *)grayColor;
/** 文字蓝 */
+ (UIColor *)blueColor;
/** 位子淡灰 输入框提示性文字 */
+ (UIColor *)lightGrayColor;
/** 边框，分割线 */
+ (UIColor *)lineColor;
/** 列表项点击色（tableview点击可不用） */
+ (UIColor *)clickBackColor;
/** 背景灰 */
+ (UIColor *)backGrayColor;
/** 白色 */
+ (UIColor *)whiteColor;

@end
