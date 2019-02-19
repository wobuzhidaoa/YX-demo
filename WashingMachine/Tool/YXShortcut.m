//
//  YXShortcut.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXShortcut.h"
#import "YXColor.h"
#import "MYKeyChainTool.h"
#import<CommonCrypto/CommonDigest.h>
@implementation YXShortcut
//md5加密
+ (NSString *) md5:(NSString *) input{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
//金额格式化
+(NSString *)moneyNumber:(double)value formatter:(NSNumberFormatterStyle )formatterType{
    
    //    enum {
    //        NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle,
    //        NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle,
    //        NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle,
    //        NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle,
    //        NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle,
    //        NSNumberFormatterSpellOutStyle = kCFNumberFormatterSpellOutStyle
    //    };
    //    typedef NSUInteger NSNumberFormatterStyle;
    //    各个枚举对应输出数字格式的效果如下：
    //    [1243:403] Formatted number string:123456789
    //    [1243:403] Formatted number string:123,456,789
    //    [1243:403] Formatted number string:￥123,456,789.00
    //    [1243:403] Formatted number string:-539,222,988%
    //    [1243:403] Formatted number string:1.23456789E8
    //    [1243:403] Formatted number string:一亿二千三百四十五万六千七百八十九
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = formatterType;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithDouble:value]];
    return string;
}
//黑色文字提示
+ (void)showText:(NSString *)message
{
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 12;
    hud.contentColor = [YXColor whiteColor];
    hud.bezelView.backgroundColor = [YXColor blackColor];
    hud.detailsLabel.text = message;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    [hud hideAnimated:YES afterDelay:1];
}
// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    
    //    联通号段:130/131/132/155/156/185/186/145/176
    
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
    
}

/**
 获取设备标识符
 */
+ (NSString *)getIDFV
{
    NSString *IDFV = (NSString *)[MYKeyChainTool load:@"IDFV"];
    
    if ([IDFV isEqualToString:@""] || !IDFV) {
        
        IDFV = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [MYKeyChainTool save:@"IDFV" data:IDFV];
    }
    
    return IDFV;
}

+ (void)getReachabilityTypeComplete:(void(^)(BOOL isNetWork))complete{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [manger startMonitoring];
    
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (complete) {
            BOOL isnet = (status == AFNetworkReachabilityStatusNotReachable) ? NO : YES;
            complete(isnet);
        }
    }];
    
}

/** 加载网络图片 */
+ (void)setImageView:(UIImageView *)imageView WithUrlStr:(NSString *)urlStr{
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"details_pic_default"]];
}
/** 两段富文本处理   例：   名称：内容 */
+ (NSMutableAttributedString *)AttributedStringFromStringF:(NSString *)strF stringS:(NSString *)strS withColorF:(UIColor *)colorF withColorS:(UIColor *)colorS withFont:(UIFont *)font
{
    NSString *str = [NSString stringWithFormat:@"%@%@",strF,strS];
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutStr addAttribute:NSForegroundColorAttributeName value:colorF range:NSMakeRange(0,strF.length)];
    [mutStr addAttribute:NSForegroundColorAttributeName value:colorS range:NSMakeRange(strF.length,str.length-strF.length)];
    [mutStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,strF.length)];
    [mutStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(strF.length,str.length-strF.length)];
    
    return mutStr;
}

//alert弹框
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message controller:(id)vc buttonNumber:(BOOL)isTwo{//Yes:两按钮 No:只有确定
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (isTwo) {
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击确认");
    }]];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

//去掉tableview底部空行
+ (void)deleteTableViewBlankline:(UITableView *)tableView{
    [tableView setTableFooterView:[[UIView alloc] init]];
    
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
}
//YES不显示 NO显示暂无数据
+ (void)setTableView:(UITableView *)tableView footInfo:(BOOL)isHidden{
    if (isHidden) {
        tableView.tableFooterView = [[UIView alloc]init];
    }else{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = ORDINARYFONT;
        tableView.tableFooterView = label;
    }
}
//设置textfield的Placeholder
+ (void)setTextFieldPlaceholder:(UITextField *)textField{
    [textField setValue:[YXColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:ORDINARYFONT forKeyPath:@"_placeholderLabel.font"];
    
    UILabel * placeholderLabel = [textField valueForKey:@"_placeholderLabel"];
    placeholderLabel.frame = textField.bounds;
}
//根据颜色生成图片
+ (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    return theImage;
}
@end
