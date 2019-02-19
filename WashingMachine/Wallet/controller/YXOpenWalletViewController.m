//
//  YXOpenWalletViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/23.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXOpenWalletViewController.h"
#import "YXChangePayPsdViewController.h"
@interface YXOpenWalletViewController ()
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)UIButton *termsButton;
@property(nonatomic,strong)UIImageView *termsImageView;
@end

@implementation YXOpenWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包开通协议";
    [self initView];
}

- (void)initView{
    
    [self initfootView];
}
- (void)initfootView{
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80)];
    self.footView.backgroundColor = [YXColor whiteColor];
    [self.view addSubview:self.footView];
    
    self.termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.termsButton.frame = CGRectMake(0, 0, self.footView.width, 30);
    [self.termsButton addTarget:self action:@selector(termsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footView addSubview:self.termsButton];
    
    self.termsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 10, 10)];
    self.termsImageView.image = [UIImage imageNamed:@"login_unchecked"];
    [self.termsButton addSubview:self.termsImageView];
    
    UILabel *termsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.termsImageView.frame)+5, 0, self.termsButton.width - 5 - CGRectGetMaxX(self.termsImageView.frame), self.termsButton.height)];
//    termsLabel.attributedText = [YXShortcut AttributedStringFromStringF:@"我已阅读并同意" stringS:@"《XXXX服务协议》" withColorF:[YXColor blackColor] withColorS:[YXColor blueColor] withFont:SMALLFONT];
    termsLabel.text = @"同意海狸钱包开通协议";
    [self.termsButton addSubview:termsLabel];
    
    //开通
    UIButton * openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openButton.backgroundColor = [YXColor blueColor];
    [openButton setTitle:@"开通钱包" forState:UIControlStateNormal];
    [openButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    openButton.frame = CGRectMake(self.termsImageView.x, CGRectGetMaxY(self.termsButton.frame)+5, SCREEN_WIDTH - self.termsImageView.x * 2, 40);
    openButton.layer.masksToBounds = YES;
    openButton.layer.cornerRadius = openButton.height/2.0;
    [self.footView addSubview:openButton];
}

- (void)termsButtonClick:(UIButton *)sender{
    self.termsImageView.image = sender.selected ? [UIImage imageNamed:@"login_unchecked"] : [UIImage imageNamed:@"login_checked"];
    
    sender.selected = !sender.selected;
}

- (void)openButtonClick:(UIButton *)sender{
    if (self.termsButton.selected) {
        YXChangePayPsdViewController *vc = [[YXChangePayPsdViewController alloc]init];
        vc.title = @"设置支付密码";
        vc.topStr = @"请输入支付密码";
        vc.type = @"set";
        [self.navigationController pushViewController:vc animated:YES];
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
