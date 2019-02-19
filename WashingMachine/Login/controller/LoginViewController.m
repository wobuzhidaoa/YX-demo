//
//  LoginViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "LoginViewController.h"
#import "ImageTextFieldView.h"
#import "BaseTabBarViewController.h"
#import "BaseNavViewController.h"
#import "YXRegisterViewController.h"
#import "YXForgetPasswordViewController.h"
@interface LoginViewController ()
{
    //手机输入view
    ImageTextFieldView *userView;
    ImageTextFieldView *psdView;
}
@property(nonatomic,strong)UIImageView *termsImageView;
@property(nonatomic,strong)UIButton *termsButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSString *phone = [UserDefaultsUtils valueWithKey:@"currentPhone"];
    if (phone != nil) {
        userView.fTextField.text = phone;
    }
}
#pragma mark 界面
- (void)initView{
    //标题
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 58, SCREEN_WIDTH, 20)];
    titleLable.font = [UIFont systemFontOfSize:18];
    titleLable.textColor = [YXColor blackColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"账号登录";
    [self.view addSubview:titleLable];
    
    //输入框
    userView = [[ImageTextFieldView alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(titleLable.frame)+24, SCREEN_WIDTH-70, 50) WithImageStr:@"login_icon_phone" WithTextFieldPlaceHodler:@"请输入手机号"];
    userView.fTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:userView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChange:) name:UITextFieldTextDidChangeNotification object:userView.fTextField];
    
    psdView = [[ImageTextFieldView alloc]initWithFrame:CGRectMake(userView.x, CGRectGetMaxY(userView.frame)+16, userView.width, userView.height) WithImageStr:@"login_icon_password" WithTextFieldPlaceHodler:@"请输入密码"];
    [psdView.fTextField setSecureTextEntry:YES];
    [self.view addSubview:psdView];
    
    //条款
    self.termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.termsButton.frame = CGRectMake(userView.x, CGRectGetMaxY(psdView.frame)+20, userView.width, 30);
    [self.termsButton addTarget:self action:@selector(termsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.termsButton];
    
    self.termsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 10, 10)];
    self.termsImageView.image = [UIImage imageNamed:@"login_unchecked"];
    [self.termsButton addSubview:self.termsImageView];
    
    UILabel *termsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.termsImageView.frame)+5, 0, self.termsButton.width - 5 - CGRectGetMaxX(self.termsImageView.frame), self.termsButton.height)];
    termsLabel.attributedText = [YXShortcut AttributedStringFromStringF:@"我已阅读并同意" stringS:@"《XXXX服务协议》" withColorF:[YXColor blackColor] withColorS:[YXColor blueColor] withFont:SMALLFONT];
    [self.termsButton addSubview:termsLabel];
    
    //登录
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [YXColor blueColor];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(LoginClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.frame = CGRectMake(userView.x, CGRectGetMaxY(self.termsButton.frame)+16, userView.width, 40);
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = loginButton.height/2.0;
    [self.view addSubview:loginButton];
    
    
    //忘记密码
    UIButton *fpsdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fpsdButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [fpsdButton setTitleColor:[YXColor blueColor] forState:UIControlStateNormal];
    [fpsdButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [fpsdButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [fpsdButton addTarget:self action:@selector(fpsdButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    fpsdButton.frame = CGRectMake(userView.x, CGRectGetMaxY(loginButton.frame)+18, 65, 30);
    [self.view addSubview:fpsdButton];
    
    //注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[YXColor blueColor] forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [registerButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.frame = CGRectMake(CGRectGetMaxX(userView.frame)-40, fpsdButton.y, 40, 30);
    [self.view addSubview:registerButton];
}
// 控制输入框输入的长度
- (void)textFiledDidChange:(NSNotification *)noti
{
    UITextField *textFiled = noti.object;
    
    if (textFiled == userView.fTextField && textFiled.text.length > 11) {
        textFiled.text = [textFiled.text substringToIndex:11];
    }
}
#pragma mark 点击条款
- (void)termsButtonClick:(UIButton *)sender{
    [self.view endEditing:YES];
    
    self.termsImageView.image = sender.selected ? [UIImage imageNamed:@"login_unchecked"] : [UIImage imageNamed:@"login_checked"];
    
    sender.selected = !sender.selected;
}

#pragma mark 点击登录
- (void)LoginClick:(UIButton *)sender{
    if (self.termsButton.selected) {
        if (![YXShortcut isMobileNumber:userView.fTextField.text]){
            [YXShortcut showText:@"请输入正确的手机号码"];
        }else if (psdView.fTextField.text.length == 0){
            [YXShortcut showText:@"请输入密码"];
        }else{
            [self loginRequest];
        }
        
    }else{
        [YXShortcut showText:@"需同意协议"];
    }
}
- (void)loginRequest{
    //login.do?username=18588221409&password=123456
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userView.fTextField.text,@"username",[YXShortcut md5:psdView.fTextField.text],@"password", nil];
    BaseHandler *handler = [[BaseHandler alloc] init];
    [handler requestData:dic requestUrl:@"login.do" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"]integerValue];
        if (code == 0) {
            NSDictionary *dic = obj[@"data"];
            [UserDefaultsUtils saveValue:dic[@"accessToken"] forKey:@"accessToken"];
            [UserDefaultsUtils saveValue:dic[@"walletInfo"] forKey:@"walletInfo"];
            [UserDefaultsUtils saveValue:dic[@"userInfo"] forKey:@"userInfo"];
            [UserDefaultsUtils saveValue:dic[@"userInfo"][@"phone"] forKey:@"currentPhone"];
            self.view.window.rootViewController = [[BaseTabBarViewController alloc]init];
        }
    } failed:^(id obj) {
        
    }];
}
#pragma mark 点击忘记密码
- (void)fpsdButtonClick:(UIButton *)sender{
    YXForgetPasswordViewController *vc = [[YXForgetPasswordViewController alloc]init];
    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark 点击注册
- (void)registerButtonClick:(UIButton *)sender{
    YXRegisterViewController *vc = [[YXRegisterViewController alloc]init];
    BaseNavViewController *nav = [[BaseNavViewController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
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
