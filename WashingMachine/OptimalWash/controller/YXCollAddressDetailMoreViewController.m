//
//  YXCollAddressDetailMoreViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/8.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXCollAddressDetailMoreViewController.h"
#import "CollAddressDetailMoreView.h"
@interface YXCollAddressDetailMoreViewController ()<UIScrollViewDelegate,CollAddressDetailMoreDelegate>
{
    UIView *navLine;
    
    BOOL isCollection;
    
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSArray *tableArray;
@property(nonatomic,strong)CollAddressDetailMoreView *selectView;
@property(nonatomic,strong)UIView *blackView;
@end

@implementation YXCollAddressDetailMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取导航栏分割线
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    navLine = backgroundView.subviews.firstObject;
    
    UINavigationBar *nav = [UINavigationBar appearance];
    nav.barTintColor = [YXColor backGrayColor];
    [nav setTitleTextAttributes:@{NSForegroundColorAttributeName:[YXColor blackColor]}];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"popup_arrow_b" highImage:nil target:self action:@selector(leftBarButtonClick:)];
    
    NSString *imageStr = self.isCollection ? @"popup_icon_collection_pre" : @"popup_icon_collection";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:imageStr highImage:nil target:self action:@selector(rightBarButtonClick:)];
    
    [self listRequest];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    navLine.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    navLine.hidden = NO;
    UINavigationBar *nav = [UINavigationBar appearance];
    nav.barTintColor = [YXColor blueFirColor];
    [nav setTitleTextAttributes:@{NSForegroundColorAttributeName:[YXColor whiteColor]}];
}
- (void)leftBarButtonClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightBarButtonClick:(UIButton *)sender{
    //collcetionLaundry.do?type=2&userId=11&laundryId=75e8cc5fd830414e82dd8a77cbfbc38a
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSString *type = isCollection ? @"2" : @"1";
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",type,@"type",self.getInfo[@"laundryId"],@"laundryId", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"collcetionLaundry.do" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"] integerValue];
        if (code == 0) {
            self.isCollection = !self.isCollection;
            NSString *imageStr = self.isCollection ? @"popup_icon_collection_pre" : @"popup_icon_collection";
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:imageStr highImage:nil target:self action:@selector(rightBarButtonClick:)];
        }
    } failed:^(id obj) {
        
    }];
    
}
#pragma mark 洗衣机价格
- (void)listRequest{
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    [mdic setValue:userInfo[@"userId"] forKey:@"userId"];
    [mdic setValue:self.getInfo[@"laundryNum"] forKey:@"washingMachineId"];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:nil requestUrl:@"laundryModel.do" present:self success:^(id obj) {
        isCollection = [obj[@"data"][@"iscollection"] boolValue];
        _tableArray = obj[@"data"][@"washingMachineModelList"];
        [self initView];
    } failed:^(id obj) {
        
    }];
}
#pragma mark 预约
- (void)sureButtonClick:(UIButton *)sender{
    NSDictionary *dic = self.tableArray[self.selectView.tag - 1000];
    
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    [mdic setValue:userInfo[@"userId"] forKey:@"userId"];
    [mdic setValue:dic[@"modelid"] forKey:@"modelid"];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:mdic requestUrl:@"make_an_appointment.do" present:self success:^(id obj) {
        
    } failed:^(id obj) {
        
    }];
}
#pragma mark 界面
- (void)initView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, navHight, SCREEN_WIDTH, SCREEN_HEIGHT - navHight - 90)];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(SCREEN_WIDTH/2.0 - 50, CGRectGetMaxY(self.scrollView.frame)+24, 100, 40);
    [sureButton setBackgroundColor:[YXColor blueFirColor]];
    [sureButton setTitle:@"立即预约" forState:UIControlStateNormal];
    [sureButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sureButton];
    sureButton.layer.masksToBounds = YES;
    sureButton.layer.cornerRadius = sureButton.height/2.0;
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //默认高度72 间隔12
    CGFloat height = 72;
    CGFloat spacing = 12;
    for (NSInteger i = 0; i<_tableArray.count; i++) {
//        @property(nonatomic,strong)UIImageView *iconImageView;
//        @property(nonatomic,strong)UILabel *timeLabel;
//        @property(nonatomic,strong)UILabel *machineStyleLabel;
//        @property(nonatomic,strong)UILabel *contentLabel;
//        @property(nonatomic,strong)UILabel *moneyLabel;
//        @property(nonatomic,strong)UIImageView *chooseStyleImageView;
        NSDictionary *dic = _tableArray[i];
        CollAddressDetailMoreView *collView = [[CollAddressDetailMoreView alloc]initWithFrame:CGRectMake(10, (height+spacing)*i, SCREEN_WIDTH - 20, height)];
        collView.delegate = self;
        [collView.iconImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"modelIcon"]] placeholderImage:[UIImage imageNamed:@"details_pic_default"]];
        collView.machineStyleLabel.text = dic[@"modelname"];
        collView.moneyLabel.text = [YXShortcut moneyNumber:[dic[@"price"] doubleValue] formatter:NSNumberFormatterCurrencyStyle];
        collView.timeLabel.text = [NSString stringWithFormat:@"%@min",dic[@"laundrytime"]];
        collView.contentLabel.text = dic[@"modeldesc"];
        [self.scrollView addSubview:collView];
        collView.tag = 1000+i;
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height*8 + spacing*7);
}

#pragma mark CollAddressDetailMoreView delegate
- (void)selectCollAddressDetailMoreView:(CollAddressDetailMoreView *)view{
    if (view == self.selectView) {
        self.selectView.backgroundColor = [YXColor whiteColor];
        [self.scrollView bringSubviewToFront:self.selectView];
    }
    else{
        self.selectView.chooseStyleImageView.image = [UIImage imageNamed:@"icon_plus"];
        self.selectView.backgroundColor = YXColors(249, 250, 251, 1);
        self.selectView = view;
        self.blackView.hidden = NO;
        [self.scrollView bringSubviewToFront:self.selectView];
        self.selectView.chooseStyleImageView.image = [UIImage imageNamed:@"icon_right"];
        self.selectView.backgroundColor = [YXColor whiteColor];
    }
}
- (UIView *)blackView{
    if (!_blackView) {
        _blackView = [[UIView alloc]initWithFrame:self.scrollView.bounds];
        _blackView.backgroundColor = [YXColor blackColor];
        _blackView.alpha = 0.6;
    }
    return _blackView;
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
