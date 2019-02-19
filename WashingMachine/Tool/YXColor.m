//
//  YXColor.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/3.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//



//蓝色字体
#define BLUECOLOR [UIColor colorWithRed:53/255.0 green:183/255.0 blue:250/255.0 alpha:1]
//灰色字体
#define GRAYCOLOR [UIColor colorWithRed:168/255.0 green:169/255.0 blue:170/255.0 alpha:1]
//背景灰色
#define BACKGRAYCOLOR  [UIColor colorWithRed:239/255.0 green:240/255.0 blue:241/255.0 alpha:1]


#import "YXColor.h"

@implementation YXColor

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


/** 主体颜色 导航栏，图标，按钮背景 */
+ (UIColor *)blueFirColor{
    return [YXColor colorWithHexString:@"#2196f3"];
}
/* 和主体颜色相区分的辅助色 */
+ (UIColor *)greenColor{
    return [self colorWithHexString:@"#42ab46"];
}
/* 按钮点击颜色 */
+ (UIColor *)blueSecColor{
    return [self colorWithHexString:@"#1976d3"];
}
/* 未激活的按钮背景色，登录等 */
+ (UIColor *)blueThrColor{
    return [self colorWithHexString:@"#63c5f2"];
}
/* 文字黑 */
+ (UIColor *)blackColor{
    return [self colorWithHexString:@"#000000"];
}
/* 文字灰 */
+ (UIColor *)grayColor{
    return [self colorWithHexString:@"#959595"];
}
/* 文字蓝 */
+ (UIColor *)blueColor{
    return [self colorWithHexString:@"#54b9f3"];
}
/* 位子淡灰 输入框提示性文字 */
+ (UIColor *)lightGrayColor{
    return [self colorWithHexString:@"#aaaaaa"];
}
/* 边框，分割线 */
+ (UIColor *)lineColor{
    return [self colorWithHexString:@"#d2d2d2"];
}
/* 列表项点击色（tableview点击可不用） */
+ (UIColor *)clickBackColor{
   return  [self colorWithHexString:@"#e5e5e5"];
}
/* 背景灰 */
+ (UIColor *)backGrayColor{
    return [self colorWithHexString:@"#f0f0f0"];
}
/* 白色 */
+ (UIColor *)whiteColor{
    return [self colorWithHexString:@"#ffffff"];
}

@end
