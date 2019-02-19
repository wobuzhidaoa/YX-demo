//
//  YXChangePayPsdViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/9.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXChangePayPsdViewController.h"
#import "NoCopyTextField.h"
#import "YXForgetPayPsdViewController.h"
#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height 45  //每一个输入框的高度

@interface YXChangePayPsdViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIButton *forgetButton;
@property (nonatomic, strong) NoCopyTextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点
@end

@implementation YXChangePayPsdViewController


- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[NoCopyTextField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.contentLabel.frame)+20, SCREEN_WIDTH - 32, K_Field_Height)];
        //        _textField.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textField.textColor = [UIColor clearColor];
        //输入框光标的颜色为白色
        _textField.tintColor = [UIColor clearColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        //        _textField.layer.borderColor = [[YXColor lineColor] CGColor];
        //        _textField.layer.borderWidth = 1;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, navHight + 60, SCREEN_WIDTH, 40)];
    self.contentLabel.textColor = [YXColor grayColor];
    self.contentLabel.font = TITIEFONT;
    [self.view addSubview:self.contentLabel];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.text = _topStr;
    [self.view addSubview:self.textField];
    
    
    if (_neegForget) {
        self.forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.forgetButton setTitle:@"忘记支付密码" forState:UIControlStateNormal];
        [self.forgetButton setTitleColor:[YXColor blueColor] forState:UIControlStateNormal];
        [self.forgetButton.titleLabel setFont:TITIEFONT];
        self.forgetButton.frame = CGRectMake(self.textField.x, CGRectGetMaxY(self.textField.frame)+10, self.textField.width, 40);
        [self.view addSubview:self.forgetButton];
        [self.forgetButton addTarget:self action:@selector(forgetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //页面出现时让键盘弹出
    [self.textField becomeFirstResponder];
    [self initPwdTextField];
}
#pragma mark 点击忘记密码
- (void)forgetButtonClick:(UIButton *)sender{
    YXForgetPayPsdViewController *vc = [[YXForgetPayPsdViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 输入框
- (void)initPwdTextField
{
    //每个密码输入框的宽度
    CGFloat width = (SCREEN_WIDTH - 32) / kDotCount;
    
    //生成分割线
    for (int i = 0; i < kDotCount; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.textField.x + i * width + 5, CGRectGetMaxY(self.textField.frame), width - 10, 1)];
        lineView.backgroundColor = [YXColor lineColor];
        [self.view addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self.view addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    } else {
        return YES;
    }
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
        NLog(@"输入完毕%@",textField.text);
        
        if ([self.title isEqualToString:@"设置支付密码"]) {
            [self setPayPassword];
        }
        else if ([self.title isEqualToString:@"修改支付密码"]){
            if ([self.topStr isEqualToString:@"请输入原支付密码"]) {
                [self originalPsdtoNextVC];
            }
            else if ([self.topStr isEqualToString:@"请输入支付密码"]){
                [self newPsdToNextVC];
            }
            else if ([self.topStr isEqualToString:@"请再次输入支付密码"]){
                [self editPayPsdRequest];
            }
        }
        
    }
}
- (void)alertTitle:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.title isEqualToString:@"设置支付密码"]){
            [self setPayPsdRequest];
        }
        else if ([self.title isEqualToString:@"请再次输入支付密码"]){
            [self editPayPsdRequest];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setPayPassword{
    if (self.psdwordStr == nil) {
        YXChangePayPsdViewController *vc = [[YXChangePayPsdViewController alloc]init];
        vc.neegForget = NO;
        vc.topStr = @"请再次输入支付密码";
        vc.title = @"设置支付密码";
        vc.type = self.type;
        vc.psdwordStr = self.textField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if ([self.psdwordStr isEqualToString:self.textField.text]) {
            [self setPayPsdRequest];
        }
        else{
            [YXShortcut alertWithTitle:@"两次密码输入不一样" message:nil controller:self buttonNumber:NO];
        }
    }
}
#pragma mark 请求
//设置支付密码
- (void)setPayPsdRequest{
    //setPayPassword.do?userId=11&payPassword=123456
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",@"",@"payPassword", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"setPayPassword.do" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"] integerValue];
        if (code == 0) {
            [self openWalletRequest];
        }
    } failed:^(id obj) {
        
    }];
}
// 开通钱包
- (void)openWalletRequest{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"openwallet.do" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"] integerValue];
        if (code == 0) {
            [YXShortcut showText:obj[@"msg"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"openWallet" object:nil];
        }
    } failed:^(id obj) {
        
    }];
}
//修改支付密码
- (void)editPayPsdRequest{
    //modifyPayPassword.do?userId=11&oldPayPassword=123456&newPayPassword=1234567
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",@"",@"oldPayPassword",@"",@"newPayPassword", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"modifyPayPassword.do" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"] integerValue];
        if (code == 0) {
            [YXShortcut showText:obj[@"msg"]];
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        }
    } failed:^(id obj) {
        
    }];
}
#pragma mark 验证成功跳转
//支付密码 一次
- (void)originalPsdtoNextVC{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *password = userInfo[@"password"];
    if ([password isEqualToString:self.textField.text]) {
        YXChangePayPsdViewController *vc = [[YXChangePayPsdViewController alloc]init];
        vc.neegForget = NO;
        vc.topStr = @"请输入支付密码";
        vc.title = @"修改支付密码";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [YXShortcut alertWithTitle:@"原密码输入错误" message:nil controller:self buttonNumber:NO];
    }
    
    
}

//支付密码 二次验证
- (void)newPsdToNextVC{
    if ([self.psdwordStr isEqualToString:self.textField.text]) {
        YXChangePayPsdViewController *vc = [[YXChangePayPsdViewController alloc]init];
        vc.neegForget = NO;
        vc.topStr = @"请再次输入支付密码";
        vc.title = @"修改支付密码";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [YXShortcut alertWithTitle:@"两次密码输入不一样" message:nil controller:self buttonNumber:NO];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
