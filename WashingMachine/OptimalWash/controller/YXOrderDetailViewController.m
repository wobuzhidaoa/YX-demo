//
//  YXOrderDetailViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/7.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#define orderGreenColor @"#22ac38"
#define orderGrayColor @"#e5e5e5"

#import "YXOrderDetailViewController.h"

@interface YXOrderDetailViewController ()
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *orderView;

@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)NSTimer *timer;
//最大时间
@property(nonatomic,assign)NSInteger maxTime;

//流程图片数组
@property(nonatomic,strong)NSArray *orderArray;
@property(nonatomic,strong)NSArray *orderSelectArray;

@property(nonatomic,strong)UIButton *sureButton;


@property(nonatomic,assign)NSInteger style;//默认0：已下单 1：验证机器 2：支付
@end

@implementation YXOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [self initView];
    [self initOrderView];
    
    [self collectionAddressRequest];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [self.timer invalidate];
    self.timer = nil;
}
//获取时间
- (void)collectionAddressRequest{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",self.orderInfo[@"orderID"],@"orderId", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"countdown.do" present:self success:^(id obj) {
        
    } failed:^(id obj) {
       
    }];
}
#pragma mark 界面

- (void)initView{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, navHight, SCREEN_WIDTH, 30)];
    self.topView.backgroundColor = [YXColor colorWithHexString:@"#fc9a30"];
    [self.view addSubview:self.topView];
    
    
    UILabel *topTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SIDESSPACING, 0, SCREEN_WIDTH-90-SIDESSPACING, self.topView.height)];
    topTitleLabel.text = @"每个订单下单到支付要在15分钟内完成！";
    topTitleLabel.textColor = [YXColor whiteColor];
    topTitleLabel.font = [UIFont systemFontOfSize:11];
    [self.topView addSubview:topTitleLabel];
    
    UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 7.5, 15, 15)];
    timeImageView.image = [UIImage imageNamed:@"order_icon_time"];
    [self.topView addSubview:timeImageView];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 0, 65, self.topView.height)];
    self.timeLabel.textColor = [YXColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.topView addSubview:self.timeLabel];
    
    //创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    self.maxTime = 15*60;//15分钟
}
- (void)timer:(NSTimer *)timer{
    self.maxTime -= 1;
    [self setTimeLabelText];
    
    if (self.maxTime == 0) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
//设置时间显示
- (void)setTimeLabelText{
    NSInteger minutes = self.maxTime/60;
    NSInteger seconds = self.maxTime%60;
    
    NSString *minutesStr = [NSString stringWithFormat:@"%ld",minutes];
    NSString *secondsStr = [NSString stringWithFormat:@"%ld",seconds];
    NSString *str = [NSString stringWithFormat:@"%@分%@秒",minutesStr,secondsStr];
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str];
//    [mutStr addAttribute:NSForegroundColorAttributeName value:[YXColor whiteColor] range:NSMakeRange(0,minutesStr.length)];
//    [mutStr addAttribute:NSForegroundColorAttributeName value:[YXColor whiteColor] range:NSMakeRange(minutesStr.length,1)];
//    [mutStr addAttribute:NSForegroundColorAttributeName value:[YXColor whiteColor] range:NSMakeRange(minutesStr.length + 1, secondsStr.length)];
//    [mutStr addAttribute:NSForegroundColorAttributeName value:[YXColor whiteColor] range:NSMakeRange(minutesStr.length + 1 + secondsStr.length, 1)];
    [mutStr addAttribute:NSFontAttributeName value:TITIEFONT range:NSMakeRange(0,minutesStr.length)];
    [mutStr addAttribute:NSFontAttributeName value:SMALLFONT range:NSMakeRange(minutesStr.length,1)];
    [mutStr addAttribute:NSFontAttributeName value:TITIEFONT range:NSMakeRange(minutesStr.length + 1, secondsStr.length)];
    [mutStr addAttribute:NSFontAttributeName value:SMALLFONT range:NSMakeRange(minutesStr.length + 1 + secondsStr.length, 1)];
    self.timeLabel.attributedText = mutStr;;
}

//订单流程view
- (void)initOrderView{
    self.orderView = [[UIView alloc]initWithFrame:CGRectMake(SIDESSPACING, CGRectGetMaxY(self.topView.frame)+10, SCREEN_WIDTH - SIDESSPACING*2, 234)];
    self.orderView.backgroundColor = [YXColor whiteColor];
    [self.view addSubview:self.orderView];
    
    //添加流程图
    NSArray *titleArray = @[@"已下单",@"验证机器",@"支付"];
    self.orderArray = @[@"order_icon_order",@"order_icon_code",@"order_icon_payment"];
    self.orderSelectArray = @[@"order_icon_order_pre",@"order_icon_code_pre",@"order_icon_payment-pre"];
    
    CGFloat spacing = (self.orderView.width - 24*2 - 45*3)/2;
    CGFloat imgWidth = 45;
    for (int i = 0; i<titleArray.count; i++) {
        UIImageView *orderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(24+(45+spacing)*i, 18, imgWidth, imgWidth)];
        orderImageView.image = [UIImage imageNamed:self.orderArray[i]];
        orderImageView.tag = 1000+i;
        [self.orderView addSubview:orderImageView];
        
        UILabel *orderLabel = [[UILabel alloc]init];
        orderLabel.center = CGPointMake(orderImageView.center.x, CGRectGetMaxY(orderImageView.frame)+12);
        orderLabel.bounds = CGRectMake(0, 0, orderImageView.width + 40, 15);
        orderLabel.text = titleArray[i];
        orderLabel.font = ORDINARYFONT;
        orderLabel.tag = 2000+i;
        orderLabel.textColor = [YXColor lightGrayColor];
        orderLabel.textAlignment = NSTextAlignmentCenter;
        [self.orderView addSubview:orderLabel];
    }
    
    //添加线
    CGFloat lineWidth = spacing/2.0;
    CGFloat lineX = 24 + 45;
    CGFloat lineY = 18 + 45/2.0 - 0.5;
    for (int i = 0; i<4; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(lineX + i/2*imgWidth + i*lineWidth, lineY, lineWidth, 1)];
        line.backgroundColor = [YXColor colorWithHexString:orderGrayColor];
        [self.orderView addSubview:line];
        
        line.tag = 3000+i;
    }
    
    //默认style = 0
    [self updateOrderProcess];
    
    //预订成功显示
    UIImageView *reservationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.orderView.width/2.0 - 50, 100 + 14, 20, 20)];
    reservationImageView.image = [UIImage imageNamed:@"order_icon_success"];
    [self.orderView addSubview:reservationImageView];
    UILabel *reservationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(reservationImageView.frame)+8, reservationImageView.y, 80, reservationImageView.height)];
    reservationLabel.text = @"预订成功";
    reservationLabel.textColor = [YXColor greenColor];
    reservationLabel.font = TITIEFONT;
    [self.orderView addSubview:reservationLabel];
    
    UILabel *moreInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(reservationImageView.frame)+ 10, self.orderView.width, 20)];
    moreInfoLabel.text = @"带上待洗的衣服，去找到你预定编号的洗衣机吧";
    moreInfoLabel.textColor = [YXColor grayColor];
    moreInfoLabel.textAlignment = NSTextAlignmentCenter;
    moreInfoLabel.font = SMALLFONT;
    [self.orderView addSubview:moreInfoLabel];
    
    
    //验证按钮
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureButton.frame = CGRectMake(self.orderView.width/2.0 - 60, CGRectGetMaxY(moreInfoLabel.frame)+18, 120, 40);
    [self.sureButton setTitle:@"验证机器" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
    [self.sureButton.titleLabel setFont:TITIEFONT];
    [self.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureButton setBackgroundColor:[YXColor blueFirColor]];
    [self.orderView addSubview:self.sureButton];
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = self.sureButton.height/2.0;
}
#pragma mark 根据订单状态修改流程
- (void)updateOrderProcess{
    //图片
    for (NSInteger i = 0; i<self.orderArray.count; i++) {
        UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1000+i];
        UILabel *lab = (UILabel *)[self.view viewWithTag:2000+i];
        if (i<=self.style) {
            imgView.image = [UIImage imageNamed:self.orderSelectArray[i]];
            lab.textColor = [YXColor colorWithHexString:orderGreenColor];
        }else{
            imgView.image = [UIImage imageNamed:self.orderArray[i]];
            lab.textColor = [YXColor colorWithHexString:orderGrayColor];
        }
    }
    //线 0-0 1-2 2-4
    for (NSInteger i = 0; i<4; i++) {
        UIView *line = (UIView *)[self.view viewWithTag:3000+i];
        if (i <= self.style*2 ) {
            line.backgroundColor = [YXColor colorWithHexString:orderGreenColor];
        }else{
            line.backgroundColor = [YXColor colorWithHexString:orderGrayColor];
        }
    }
}
#pragma mark 点击验证按钮
- (void)sureButtonClick:(UIButton *)sender{
    if (self.style < 2) {
        self.style += 1;
    }
    [self updateOrderProcess];
    
    if (self.style == 2) {//支付完成
        
        //定时器移除
        [self.timer invalidate];
        self.timer = nil;
        
        //移除顶部时间
        [self.topView removeFromSuperview];
        
        //修改流程view的frame
        CGRect rect = self.orderView.frame;
        rect.origin.y = navHight + 10;
        self.orderView.frame = rect;
        
        
        [YXShortcut alertWithTitle:@"支付完成" message:nil controller:self buttonNumber:NO];
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
