//
//  YXShortcut.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXShortcut : NSObject
+ (NSString *) md5:(NSString *) input;
+(NSString *)moneyNumber:(double)value formatter:(NSNumberFormatterStyle )formatterType;
+ (void)setTableView:(UITableView *)tableView footInfo:(BOOL)isHidden;
+ (void)showText:(NSString *)message;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (NSString *)getIDFV;
+ (void)getReachabilityTypeComplete:(void(^)(BOOL isNetWork))complete;
+ (NSMutableAttributedString *)AttributedStringFromStringF:(NSString *)strF stringS:(NSString *)strS withColorF:(UIColor *)colorF withColorS:(UIColor *)colorS withFont:(UIFont *)font;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message controller:(id)vc buttonNumber:(BOOL)isTwo;
+ (void)deleteTableViewBlankline:(UITableView *)tableView;
+ (void)setTextFieldPlaceholder:(UITextField *)textField;
+ (UIImage*)createImageWithColor:(UIColor*)color;
+ (void)setImageView:(UIImageView *)imageView WithUrlStr:(NSString *)urlStr;
@end
