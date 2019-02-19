//
//  YXChangePsdViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/9.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXChangePsdViewController.h"

@interface YXChangePsdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *OldPsdTextField;
@property (weak, nonatomic) IBOutlet UITextField *NewPsdTextField;
@property (weak, nonatomic) IBOutlet UITextField *NewPsdSecTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation YXChangePsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改登录密码";
    
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = self.sureButton.height/2.0;
}

#pragma mark 点击确定
- (IBAction)sureButtonClick:(UIButton *)sender {
    NLog(@"_%@_%@_%@",_OldPsdTextField.text,_NewPsdTextField.text,_NewPsdSecTextField.text);
    if (_OldPsdTextField.text.length == 0) {
        [YXShortcut showText:@"请输入原密码"];
    }else if (_NewPsdTextField.text.length == 0){
        [YXShortcut showText:@"请输入新密码"];
    }else if (![_NewPsdTextField.text isEqualToString:_NewPsdSecTextField.text]){
        [YXShortcut showText:@"两次密码输入不一样"];
    }else{
        [self editPayPsdRequest];
    }
}
//修改登录密码
- (void)editPayPsdRequest{
    //modifyLoginPassword.do?userId=11&oldPassword=123456&newPassword=1234567
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",[YXShortcut md5:_OldPsdTextField.text],@"oldPassword",[YXShortcut md5:_NewPsdTextField.text],@"newPassword", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"modifyLoginPassword.do" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"] integerValue];
        if (code == 0) {
            [YXShortcut showText:obj[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
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
