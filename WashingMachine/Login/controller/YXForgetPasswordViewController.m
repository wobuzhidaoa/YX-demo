//
//  YXForgetPasswordViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/2.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXForgetPasswordViewController.h"

@interface YXForgetPasswordViewController ()
{
    NSString *valCodeNumber;//验证码
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *validationTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *validationButton;


//定时器
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger timerNumber;

@end

@implementation YXForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    
    //设置圆角
    self.validationButton.layer.masksToBounds = YES;
    self.validationButton.layer.cornerRadius = self.validationButton.height/2.0;
    [self.validationButton setBackgroundColor:[YXColor blueThrColor]];
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = self.sureButton.height/2.0;
    
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
//点击返回
- (void)leftItemBarButton{
    [self dismissViewControllerAnimated:YES completion:nil];
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
//验证码定时器
- (void)validationTimer{
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
}//点击提交
- (IBAction)sureButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![YXShortcut isMobileNumber:_phoneTextField.text]) {
        [YXShortcut showText:@"请输入正确的手机号"];
    }else if (![valCodeNumber isEqualToString:_validationTextField.text]){
        [YXShortcut showText:@"请输入正确的验证码"];
    }else if (_psdTextField.text.length == 0){
        [YXShortcut showText:@"请输入新密码"];
    }else{
        [self saveRequest];
    }
    
}
//提交接口
- (void)saveRequest{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_phoneTextField.text,@"phone",_psdTextField.text,@"newPassword", nil];
    BaseHandler *handler = [[BaseHandler alloc] init];
    [handler requestData:dic requestUrl:@"forgotpassword.do" present:self success:^(id obj) {
        [YXShortcut showText:obj[@"msg"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failed:^(id obj) {
        
    }];
}
//验证码接口
- (void)codeRequest{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_phoneTextField.text,@"phone", nil];
    BaseHandler *handler = [[BaseHandler alloc] init];
    [handler requestData:dic requestUrl:@"getVerificationByPhone.do" present:self success:^(id obj) {
        NSDictionary *dataDic = obj[@"data"];
        valCodeNumber = [NSString stringWithFormat:@"%@",dataDic[@"verificationCode"]];
        self.validationButton.enabled = YES;
        [self validationTimer];
    } failed:^(id obj) {
        self.validationButton.enabled = YES;
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
