//
//  WalletViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletTableViewCell.h"
#import "YXTopupViewController.h"
#import "YXOpenWalletViewController.h"
#import "YXHelpViewController.h"
@interface WalletViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    //导航栏分割线
    UIView *navLine;
    
    UIButton *walletButton;
    BOOL isOpen;//钱包是否开通
    
    NSInteger type;//记录时间
}
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UILabel *moneyNumberLabel;
@property(nonatomic,strong)UIView *timeChooseView;
@property(nonatomic,strong)UIScrollView *listScrollView;
@property(nonatomic,strong)NSArray *timeArray;
@property(nonatomic,strong)NSMutableArray *tableViews;
//当前显示的tableview
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *tableViewArray1;
@property(nonatomic,strong)NSArray *tableViewArray2;
@property(nonatomic,strong)NSArray *tableViewArray3;
//蓝色线条
@property(nonatomic,strong)UIView *blueLine;
//蓝色线条上的button
@property(nonatomic,strong)UIButton *selectLineButton;
@end

@implementation WalletViewController


- (UIView *)blueLine{
    if (!_blueLine) {
        _blueLine = [[UIView alloc]init];
        _blueLine.backgroundColor = [YXColor blueFirColor];
    }
    return _blueLine;
}
- (NSMutableArray *)tableViews{
    if (!_tableViews) {
        _tableViews = [NSMutableArray new];
    }
    return _tableViews;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"钱包";
    
    //隐藏导航栏线
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    navLine = backgroundView.subviews.firstObject;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"nav_help" highImage:nil target:self action:@selector(rightBarButton:)];
    
    isOpen = ([[UserDefaultsUtils valueWithKey:@"walletInfo"][@"isOpen"] integerValue] == 1) ? YES : NO;
    
    [self initView];
    [self setNotifacation];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    navLine.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    navLine.hidden = NO;
}
- (void)setNotifacation{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(walletStatus) name:@"openWallet" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWallet) name:@"walletNumber" object:nil];
}
- (void)walletStatus{
    [walletButton removeFromSuperview];
}
#pragma mark 界面
- (void)initView{
    //顶部view
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, navHight, SCREEN_WIDTH, 84)];
    self.topView.backgroundColor = [YXColor blueFirColor];
    [self.view addSubview:self.topView];
    
    
    if (!isOpen) {
        walletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        walletButton.frame = CGRectMake(SCREEN_WIDTH - SIDESSPACING - 80, 10, 80, 24);
        walletButton.layer.masksToBounds = YES;
        walletButton.layer.cornerRadius = walletButton.height/2.0;
        [walletButton setTitle:@"开通钱包" forState:UIControlStateNormal];
        [walletButton.titleLabel setFont:ORDINARYFONT];
        [walletButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
        [walletButton setBackgroundColor:[YXColor colorWithHexString:@"#63c5f1"]];
        [walletButton addTarget:self action:@selector(walletButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:walletButton];
    }
    
    UIButton *topupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topupButton.frame = CGRectMake(SCREEN_WIDTH - SIDESSPACING - 60, self.topView.height - 44, 60, 24);
    topupButton.layer.masksToBounds = YES;
    topupButton.layer.cornerRadius = topupButton.height/2.0;
    [topupButton setTitle:@"充值" forState:UIControlStateNormal];
    [topupButton.titleLabel setFont:ORDINARYFONT];
    [topupButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
    [topupButton setBackgroundColor:[YXColor colorWithHexString:@"#63c5f1"]];
    [topupButton addTarget:self action:@selector(topupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:topupButton];
    
    
    UILabel *moneyTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SIDESSPACING, 14, SCREEN_WIDTH - topupButton.x, 20)];
    moneyTitleLabel.text = @"账户余额";
    moneyTitleLabel.textColor = [YXColor whiteColor];
    moneyTitleLabel.font = SMALLFONT;
    [self.topView addSubview:moneyTitleLabel];
    
    
    self.moneyNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyTitleLabel.x, CGRectGetMaxY(moneyTitleLabel.frame), moneyTitleLabel.width, 30)];
    self.moneyNumberLabel.text = [NSString stringWithFormat:@"%.2f",[[UserDefaultsUtils valueWithKey:@"walletInfo"][@"accountbalance"]floatValue]];
    self.moneyNumberLabel.textColor = [YXColor whiteColor];
    self.moneyNumberLabel.font = [UIFont systemFontOfSize:18];
    [self.topView addSubview:self.moneyNumberLabel];
    
    
    //中间view
    [self midView];
}
- (void)midView{
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(SIDESSPACING, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH- SIDESSPACING*2, 30)];
    mLabel.text = @"钱包明细";
    mLabel.textColor = [YXColor grayColor];
    mLabel.font = ORDINARYFONT;
    [self.view addSubview:mLabel];
    
    self.timeArray = @[@"最近一周",@"最近一个月",@"最近三个月"];
    self.timeChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(mLabel.frame), SCREEN_WIDTH, 40)];
    self.timeChooseView.backgroundColor = [YXColor whiteColor];
    [self.view addSubview:self.timeChooseView];
    
    //列表view
    [self initScrollView];
    
    
    for (int i = 0; i<self.timeArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000+i;
        [button setTitle:self.timeArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:ORDINARYFONT];
        [button setTitleColor:[YXColor blueColor] forState:UIControlStateSelected];
        [button setTitleColor:[YXColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(timeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeChooseView addSubview:button];
        button.frame = CGRectMake(SCREEN_WIDTH/3.0*i, 0, SCREEN_WIDTH/3.0, self.timeChooseView.height);
        
        if (i == 0) {
            self.selectLineButton = button;
            [self setBlueLineFrame:button];
        }
    }
    
    self.selectLineButton.selected = YES;
    [self.timeChooseView addSubview:self.blueLine];
}
- (void)initScrollView{
    self.listScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.timeChooseView.frame),SCREEN_WIDTH,SCREEN_HEIGHT-tabbarHight - CGRectGetMaxY(self.timeChooseView.frame))];
    self.listScrollView.bounces = NO;
    self.listScrollView.pagingEnabled = YES;
    self.listScrollView.directionalLockEnabled = YES;
    self.listScrollView.showsHorizontalScrollIndicator = NO;
    self.listScrollView.showsVerticalScrollIndicator = NO;
    self.listScrollView.delegate = self;
    [self.view addSubview:self.listScrollView];
    self.listScrollView.contentSize = CGSizeMake(self.listScrollView.width*3, self.listScrollView.height);
    
    //顶部添加线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.listScrollView.y, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [YXColor lineColor];
    [self.view addSubview:lineView];
    
    [self setUpTableView];
}

- (void )setUpTableView
{
    for (int i = 0; i<3; i++) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.frame = CGRectMake(i*self.listScrollView.width, 0, self.listScrollView.width, self.listScrollView.height);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [YXColor backGrayColor];
        [self.listScrollView addSubview:tableView];
        [tableView registerNib:[UINib nibWithNibName:@"YXWalletTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXWalletTableViewCell"]; //注册cell
        [self.tableViews addObject:tableView];
        [YXShortcut deleteTableViewBlankline:tableView];
        
        [tableView registerNib:[UINib nibWithNibName:@"WalletTableViewCell" bundle:nil] forCellReuseIdentifier:@"WalletTableViewCell"];
        
        [self setupRefreshWith:tableView];
    }
    
    self.tableView = self.tableViews[0];
}
//设置蓝色线条位置
- (void)setBlueLineFrame:(UIButton *)button{
    CGFloat width = button.titleLabel.text.length * 14 ;
    
    self.blueLine.frame = CGRectMake(button.x + button.width/2.0 - width/2.0, button.height - 0.5, width, 0.5);
    
    type = button.tag - 1000 + 1;
    
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 集成上下拉刷新界面
- (void)setupRefreshWith:(UITableView *)tableView
{
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self listRequest];
    }];
}
#pragma mark 刷新钱包接口
- (void)refreshWallet{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"updateAccountbalance.do" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"] integerValue];
        if (code == 0) {
            self.moneyNumberLabel.text = [NSString stringWithFormat:@"%.2f",[obj[@"data"][@"accountbalance"] floatValue]];
            //刷新本地数据
            NSDictionary *walletInfo = [UserDefaultsUtils valueWithKey:@"walletInfo"];
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:walletInfo];
            [mdic setValue:obj[@"data"][@"accountbalance"] forKey:@"accountbalance"];
            [UserDefaultsUtils saveValue:mdic forKey:@"walletInfo"];
        }
    } failed:^(id obj) {
        
    }];
}
#pragma mark 请求
//充值记录
- (void)listRequest{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",[NSString stringWithFormat:@"%ld",type],@"type", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    handler.hideLoading = YES;
    [handler requestData:dic requestUrl:@"getaccountdetaillist.do" present:self success:^(id obj) {
        NSArray *array = obj[@"data"][@"accountDetaillist"];
        [self setListArray:array];
        [self.tableView reloadData];
        [_tableView.mj_header endRefreshing];
        BOOL ishave = array.count == 0 ? NO : YES;
        [YXShortcut setTableView:_tableView footInfo:ishave];
    } failed:^(id obj) {
        [_tableView.mj_header endRefreshing];
        [YXShortcut setTableView:_tableView footInfo:NO];
    }];
}
- (void)setListArray:(NSArray *)array{
    if (type == 1) {
        _tableViewArray1 = array;
    }else if (type == 2){
        _tableViewArray2 = array;
    }else{
        _tableViewArray3 = array;
    }
}
- (NSArray *)listArray{
    if (type == 1) {
        return _tableViewArray1;
    }else if (type == 2){
        return _tableViewArray2;
    }else{
        return _tableViewArray3;
    }
}
#pragma mark tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self listArray];
    return [array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletTableViewCell"];
    
//    @property (weak, nonatomic) IBOutlet UILabel *titleContentLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *moneyNumberLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *styleLabel;
    NSDictionary *dic = [self listArray][indexPath.row];
    cell.titleContentLabel.text = dic[@"accountType"];
    cell.orderNumberLabel.text = [NSString stringWithFormat:@"订单号 %@",dic[@"orderId"]];
    cell.timeLabel.text = dic[@"accountTime"];
    cell.moneyNumberLabel.text = [YXShortcut moneyNumber:[dic[@"accountmoney"] doubleValue] formatter:NSNumberFormatterCurrencyStyle];
    cell.styleLabel.text = [self stringWithStatus:[dic[@"status"] integerValue]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSString *)stringWithStatus:(NSInteger)number{
    //1表示充值成功 2表示充值失败 3表示消费成功 4表示消费失败
    if (number == 1) {
        return @"充值成功";
    }
    else if (number == 2){
        return @"充值失败";
    }
    else if (number == 3){
        return @"消费成功";
    }
    else{
        return @"消费失败";
    }
}
#pragma mark scrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.listScrollView) {
        NSInteger number = scrollView.contentOffset.x/SCREEN_WIDTH;
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+number];
        [self timeButton:button];
    }
}
#pragma mark button点击
//点击时间段选择
- (void)timeButton:(UIButton *)sender{
    if (self.selectLineButton.tag != sender.tag) {
        //按钮改变
        self.selectLineButton.selected = NO;
        self.selectLineButton = sender;
        self.selectLineButton.selected = YES;
        
        //移动蓝色线
        [self setBlueLineFrame:sender];
        
        //移动scrollview
        NSInteger number = sender.tag - 1000;
        self.listScrollView.contentOffset = CGPointMake(number*self.listScrollView.width, 0);
        self.tableView = self.tableViews[number];
        
        [self.tableView.mj_header beginRefreshing];
    }
    
}
#pragma mark 点击充值
- (void)topupButtonClick:(UIButton *)sender{
    YXTopupViewController *vc = [[YXTopupViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 点击问号
- (void)rightBarButton:(id)sender{
    YXHelpViewController *vc = [[YXHelpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 开通钱包
- (void)walletButtonClick:(UIButton *)sender{
    YXOpenWalletViewController *vc = [[YXOpenWalletViewController alloc]init];
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
