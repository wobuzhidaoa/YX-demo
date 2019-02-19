//
//  YXForgetPayPsdViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/9.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXForgetPayPsdViewController.h"
#import "YXChangePayPsdViewController.h"
@interface YXForgetPayPsdViewController ()
{
    NSString *valCodeNumber;//验证码
    
    NSString *phone;//电话
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *validationCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *validationButton;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger timerNumber;
@end

@implementation YXForgetPayPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"忘记支付密码";
    
    
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    phone = userInfo[@"phone"];
    self.titleLabel.text = [NSString stringWithFormat:@"验证码发送至%@",[self phoneFormatFromPhone:phone]];
    
    self.validationCodeButton.layer.masksToBounds = YES;
    self.validationCodeButton.layer.cornerRadius = self.validationCodeButton.height/2.0;
    
    self.validationButton.layer.masksToBounds = YES;
    self.validationButton.layer.cornerRadius = self.validationButton.height/2.0;
}
//电话截取处理
- (NSString *)phoneFormatFromPhone:(NSString *)phone
{
    NSString *newPhone = phone;
    if (phone.length > 5) {
        NSString *firstNumber = [phone substringToIndex:5];
        newPhone = [NSString stringWithFormat:@"%@*****",firstNumber];
    }
    
    return newPhone;
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
//点击发送验证码
- (IBAction)validationCodeButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([YXShortcut isMobileNumber:phone]) {
        sender.enabled = NO;
        [self codeRequest];
    }else{
        [YXShortcut showText:@"请输入正确的手机号"];
    }
}
//获取验证码后处理
- (void)successValidation{
    [self.validationCodeButton setBackgroundColor:[YXColor colorWithHexString:@"#bfbfbf"]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(vtimer:) userInfo:nil repeats:YES];
    self.timerNumber = 60;
}
- (void)vtimer:(NSTimer *)timer{
    self.timerNumber -= 1;
    [self.validationCodeButton setTitle:[NSString stringWithFormat:@"获取验证码(%ld)",self.timerNumber] forState:UIControlStateNormal];
    if (self.timerNumber == 0) {
        [self.validationCodeButton setBackgroundColor:[YXColor blueThrColor]];
        [self.validationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
        
        _validationButton.enabled = YES;
    }
}
#pragma mark request
/**
 短信验证码接口
 */
- (void)codeRequest{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo[@"userId"],@"userId", nil];
    BaseHandler *handler = [[BaseHandler alloc] init];
    [handler requestData:dic requestUrl:@"getVerificationByPhone.do" present:self success:^(id obj) {
        NSDictionary *dataDic = obj[@"data"];
        valCodeNumber = [NSString stringWithFormat:@"%@",dataDic[@"verificationCode"]];
        
        [self successValidation];
        
        self.validationCodeButton.enabled = YES;
    } failed:^(id obj) {
        self.validationCodeButton.enabled = YES;
    }];
}
//点击验证
- (IBAction)validationButtonClick:(id)sender {
    if ([self.textField.text isEqualToString:valCodeNumber]) {
        YXChangePayPsdViewController *vc = [[YXChangePayPsdViewController alloc]init];
        vc.neegForget = NO;
        vc.topStr = @"请输入支付密码";
        vc.title = @"设置支付密码";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [YXShortcut showText:@"验证码错误"];
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
