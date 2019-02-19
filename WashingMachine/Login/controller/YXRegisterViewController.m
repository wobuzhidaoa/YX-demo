//
//  YXRegisterViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXRegisterViewController.h"
#import "YXAddressChooseViewController.h"
#import "YXRecommendCodeViewController.h"
@interface YXRegisterViewController ()<UITextFieldDelegate>
{
    NSString *valCodeNumber;//验证码
    NSString *recommendationcode;//邀请码
    NSString *school;//学校
}
//输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *validationTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
//验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *validationButton;
//地址
@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//推荐码
@property (weak, nonatomic) IBOutlet UIImageView *recommendImageView;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
//注册
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

//定时器
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger timerNumber;

@end

@implementation YXRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    
    //设置圆角
    self.validationButton.layer.masksToBounds = YES;
    self.validationButton.layer.cornerRadius = self.validationButton.height/2.0;
    [self.validationButton setBackgroundColor:[YXColor blueThrColor]];
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.layer.cornerRadius = self.registerButton.height/2.0;
    
    //设置输入框
    [self setTextField:_phoneTextField];
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self setTextField:_validationTextField];
    _validationTextField.keyboardType = UIKeyboardTypePhonePad;
    [self setTextField:_psdTextField];
    _psdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [self.timer invalidate];
    self.timer = nil;
}
//设置输入框
- (void)setTextField:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    [YXShortcut setTextFieldPlaceholder:textField];
}
// 控制输入框输入的长度
- (void)textFiledDidChange:(NSNotification *)noti
{
    UITextField *textFiled = noti.object;
    
    if (textFiled.text.length > 11) {
        textFiled.text = [textFiled.text substringToIndex:11];
    }
}
//点击返回
- (void)leftItemBarButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击获取验证码
- (IBAction)validationButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([YXShortcut isMobileNumber:_phoneTextField.text]) {
        sender.enabled = NO;
        [self codeRequest];
    }else{
        [YXShortcut showText:@"请输入正确的手机号"];
    }
}
//获取验证码后处理
- (void)successValidation{
    [self.validationButton setBackgroundColor:[YXColor colorWithHexString:@"#bfbfbf"]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(vtimer:) userInfo:nil repeats:YES];
    self.timerNumber = 60;
}
- (void)vtimer:(NSTimer *)timer{
    self.timerNumber -= 1;
    [self.validationButton setTitle:[NSString stringWithFormat:@"获取验证码(%ld)",self.timerNumber] forState:UIControlStateNormal];
    if (self.timerNumber == 0) {
        [self.validationButton setBackgroundColor:[YXColor blueThrColor]];
        [self.validationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
        
        _validationButton.enabled = YES;
    }
}
//点击了注册
- (IBAction)registerButton:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![YXShortcut isMobileNumber:_phoneTextField.text]) {
        [YXShortcut showText:@"请输入正确的手机号"];
    }else if (![valCodeNumber isEqualToString:_validationTextField.text]){
        [YXShortcut showText:@"请输入正确的验证码"];
    }else if (_psdTextField.text.length == 0){
        [YXShortcut showText:@"请输入密码"];
    }else{
        [self registerRequest];
    }
}
//点击位置选择
- (IBAction)addressButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    YXAddressChooseViewController *vc = [[YXAddressChooseViewController alloc]init];
    vc.block = ^(NSDictionary *dic) {
        school = dic[@"schoolname"];
        self.addressLabel.text = school;
        self.addressImageView.image = school.length ? [UIImage imageNamed:@"register_checked"] :[UIImage imageNamed:@"register_unchecked"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//点击邀请码选择
- (IBAction)recommendButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    YXRecommendCodeViewController *vc = [[YXRecommendCodeViewController alloc]init];
    vc.block = ^(NSString *code) {
        recommendationcode = code;
        self.recommendLabel.text = recommendationcode;
        self.recommendImageView.image = code.length ? [UIImage imageNamed:@"register_checked"] :[UIImage imageNamed:@"register_unchecked"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark request
/**
 短信验证码接口
 */
- (void)codeRequest{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_phoneTextField.text,@"phone", nil];
    BaseHandler *handler = [[BaseHandler alloc] init];
    [handler requestData:dic requestUrl:@"getVerificationByPhone.do" present:self success:^(id obj) {
        NSDictionary *dataDic = obj[@"data"];
        valCodeNumber = [NSString stringWithFormat:@"%@",dataDic[@"verificationCode"]];
        self.validationButton.enabled = YES;
        [self successValidation];
    } failed:^(id obj) {
        self.validationButton.enabled = YES;
    }];
}

- (void)registerRequest{
    //register.do?phone=18588221401&password=123456&recommendationcode=18739975070&school=河南大学
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    [mdic setValue:_phoneTextField.text forKey:@"phone"];
    [mdic setValue:_psdTextField.text forKey:@"password"];
    [mdic setValue:recommendationcode forKey:@"recommendationcode"];
    [mdic setValue:school forKey:@"school"];
    BaseHandler *handler = [[BaseHandler alloc] init];
    [handler requestData:mdic requestUrl:@"register.do" present:self success:^(id obj) {
        [YXShortcut showText:obj[@"msg"]];
        [UserDefaultsUtils saveValue:_phoneTextField.text forKey:@"currentPhone"];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failed:^(id obj) {
        
    }];
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
