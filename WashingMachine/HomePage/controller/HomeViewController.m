//
//  HomeViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "HomeViewController.h"
#import "YXRecommendCodeViewController.h"
#import "YXNearAddressViewController.h"
#import "YXScanViewController.h"
#import "HomeMessageViewController.h"
@interface HomeViewController ()
{
    //导航栏分割线
    UIView *navLine;
}
@property(nonatomic,strong)UIButton *washButton;
@property(nonatomic,strong)UIButton *scanningButton;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航栏线
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    navLine = backgroundView.subviews.firstObject;
    
    self.view.backgroundColor = [YXColor blueFirColor];
    //导航左箭头
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"nav_information" highImage:nil target:self action:@selector(rightItemBarButton)];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    navLine.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    navLine.hidden = NO;
}
#pragma mark 界面
- (void)initView{
    //按比例计算高度
    //图片高度
    CGFloat washImageH = (SCREEN_WIDTH - 80)*866/920.0;
    //图片与其他间隔
    NLog(@"%f",SCREEN_HEIGHT);
    CGFloat spacing = ((SCREEN_HEIGHT - navHight - tabbarHight)*0.9 - washImageH)/2.0;
    
    UIImageView *washImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, spacing+SCREEN_HEIGHT*0.03, SCREEN_WIDTH - 80, washImageH)];
    washImageView.image = [UIImage imageNamed:@"pic_home"];
    [self.view addSubview:washImageView];
    
    UILabel *conLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, washImageView.height*0.64-20, washImageView.width, 40)];
    conLabel.textColor = [YXColor colorWithHexString:@"#2196f3"];
    conLabel.font = [UIFont systemFontOfSize:12];
    conLabel.textAlignment = NSTextAlignmentCenter;
    conLabel.text = @"开启你的第一次洗衣";
    [washImageView addSubview:conLabel];
    
    self.washButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.washButton.frame =CGRectMake(35, CGRectGetMaxY(washImageView.frame)+spacing-SCREEN_HEIGHT*0.03, 100, 40);
    [self.washButton setTitle:@"我要洗衣" forState:UIControlStateNormal];
    [self.view addSubview:self.washButton];
    [self setButtonStyle:self.washButton withNumber:0];
    [self.washButton addTarget:self action:@selector(washButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.scanningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.scanningButton.frame =CGRectMake(SCREEN_WIDTH-135,self.washButton.y, 100, 40);
    [self.scanningButton setTitle:@"扫一扫" forState:UIControlStateNormal];
    [self.view addSubview:self.scanningButton];
    [self setButtonStyle:self.scanningButton withNumber:1];
    [self.scanningButton addTarget:self action:@selector(scanningButtonClick) forControlEvents:UIControlEventTouchUpInside];
}
//设置button样式
- (void)setButtonStyle:(UIButton *)button withNumber:(NSInteger)number{
    [button.titleLabel setFont:ORDINARYFONT];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.height/2.0;
    
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[YXColor colorWithHexString:@"63c5f1"] CGColor];
    
    if (number == 0) {
        [button setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[YXShortcut createImageWithColor:YXColors(64, 199, 246, 1)] forState:UIControlStateNormal];
    }
    
    if (number == 1) {
        [button setTitleColor:[YXColor colorWithHexString:@"63c5f1"] forState:UIControlStateNormal];
        [button setBackgroundImage:[YXShortcut createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    }
}
//点击气泡
- (void)rightItemBarButton{
    HomeMessageViewController *vc = [[HomeMessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//点击洗衣
- (void)washButtonClick{
    YXNearAddressViewController *vc = [[YXNearAddressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//点击扫描
- (void)scanningButtonClick{
    YXScanViewController *vc = [[YXScanViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
