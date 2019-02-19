//
//  OptimalWashViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "OptimalWashViewController.h"
#import "OrderTableViewCell.h"
#import "CollAddressTableViewCell.h"
#import "CollMachineTableViewCell.h"
#import "YXOrderDetailViewController.h"
#import "YXCollAddressDetailViewController.h"
#import "WebViewController.h"
#import "AdScrollView.h"
#import "YXCollAddressDetailMoreViewController.h"
#import "BaseNavViewController.h"
@interface OptimalWashViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AdScrollViewDelegate,AdScrollViewDataSource>
{
    //bool 用于判断界面是pop返回还是tabbar切换 yes:pop
    BOOL appearType;
}
@property(nonatomic,strong)AdScrollView *imageScrollView;
@property(nonatomic,strong)NSArray *imageViewInfoArray;
//主目录
@property(nonatomic,strong)UIButton *selectButton;
@property(nonatomic,strong)NSArray *btnImageArray;
@property(nonatomic,strong)NSArray *btnSelectImageArray;

//滑动view
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UITableView *orderTableView;
@property(nonatomic,strong)NSArray *orderArray;

@property(nonatomic,strong)UITableView *collectionTableView;
@property(nonatomic,strong)NSArray *collAddressArray;
@property(nonatomic,strong)NSArray *collMachineArray;

//收藏目录
@property(nonatomic,strong)NSArray *collChooseArray;
@property(nonatomic,strong)UIView *collChooseView;
@property(nonatomic,strong)UIButton *collChooseButton;
@property(nonatomic,strong)UIView *collChooseLine;
@end

@implementation OptimalWashViewController

- (UIView *)collChooseLine{
    if (!_collChooseLine) {
        _collChooseLine = [[UIView alloc]init];
        _collChooseLine.backgroundColor = [YXColor blueFirColor];
    }
    return _collChooseLine;
}
-(AdScrollView *)imageScrollView
{
    if (!_imageScrollView) {
        _imageScrollView = [[AdScrollView alloc] initWithTarget:self interval:4 style:nil];
        _imageScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 192*SCREEN_HEIGHT/540.0);
    }
    return _imageScrollView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self imageRequest];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:appearType];
    [self.imageScrollView startAnimation];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    appearType = (self.navigationController.viewControllers.count == 1) ? NO : YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.imageScrollView stopAnimation];
}
#pragma mark 界面
- (void)initView{
    //参考屏幕比例 540*360  192
    _imageViewInfoArray = @[@""];
    [self.view addSubview:self.imageScrollView];
    
    
    //按钮列表
    self.btnSelectImageArray = @[@"youxi_tab_order_pre",@"youxi_tab_hourglass_pre",@"youxi_tab_voucher_pre",@"youxi_tab_collection_pre"];
    self.btnImageArray = @[@"youxi_tab_order",@"youxi_tab_hourglass",@"youxi_tab_voucher",@"youxi_tab_collection"];
    NSArray *btnTitleArray = @[@"订单",@"排队",@"洗衣卷",@"收藏"];
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame)+10, SCREEN_WIDTH, 34)];
    whiteView.backgroundColor = [YXColor whiteColor];
    [self.view addSubview:whiteView];
    //按钮宽
    CGFloat btnWidth = (SCREEN_WIDTH - SIDESSPACING*5)/4.0;
    for (int i = 0; i<btnTitleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SIDESSPACING + (btnWidth+SIDESSPACING)*i, 9, btnWidth, 25);
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:SMALLFONT];
        [btn setTitleColor:[YXColor lightGrayColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.btnImageArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        [whiteView addSubview:btn];
        [self setButtonRoundedCorners:btn];
        
        if (i == 0) {
            self.selectButton = btn;
        }
    }
    
    [self initScollViewWithY:CGRectGetMaxY(whiteView.frame)];
    [self setSelectButtonStyle];
}
//设置选中btn
- (void)setSelectButtonStyle{
    [self.selectButton setBackgroundColor:[YXColor blueFirColor]];
    [self.selectButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:self.btnSelectImageArray[self.selectButton.tag - 1000]] forState:UIControlStateNormal];
    
    if (_selectButton.tag == 1000) {
        if (_orderArray.count == 0) {
            [self.orderTableView.mj_header beginRefreshing];
        }
    }else if (_selectButton.tag == 1003){
        if ((_collAddressArray.count == 0 && _collChooseButton.tag == 1000) || (_collMachineArray.count == 0 && _collChooseButton.tag == 1001)) {
            [self.collectionTableView.mj_header beginRefreshing];
        }
    }
}
//设置btn圆角 约束
- (void)setButtonRoundedCorners:(UIButton *)sender{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sender.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = sender.bounds;
    maskLayer.path = maskPath.CGPath;
    sender.layer.mask = maskLayer;
    
    [sender setImageEdgeInsets:UIEdgeInsetsMake(2.5, 10, 2.5, sender.width-30)];
    [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
}

- (void)initScollViewWithY:(CGFloat)Y{
    //scrollview高度
    CGFloat scrhight = SCREEN_HEIGHT - tabbarHight - Y - 10;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Y+10, SCREEN_WIDTH, scrhight)];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, self.scrollView.height);
    self.scrollView.pagingEnabled = YES;
    
    //订单
    [self initOrderView];
    //排队
    [self initLineUpView];
    //洗衣卷
    [self initLaundryView];
    //收藏
    [self initCollectionView];
}
//订单
- (void)initOrderView{
    self.orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    [self.scrollView addSubview:self.orderTableView];
    [YXShortcut deleteTableViewBlankline:self.orderTableView];
    [self.orderTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.orderTableView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderTableViewCell"];
    
    self.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self orderListRequest];
    }];
}
//排队
- (void)initLineUpView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    view.backgroundColor = [YXColor backGrayColor];
    [self.scrollView addSubview:view];
}
//洗衣卷
- (void)initLaundryView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height)];
    view.backgroundColor = [YXColor backGrayColor];
    [self.scrollView addSubview:view];
}
//收藏
- (void)initCollectionView{
    self.collChooseArray = @[@"洗衣点",@"洗衣机"];
    self.collChooseView = [[UIView alloc]initWithFrame:CGRectMake(self.scrollView.width *3, 0, SCREEN_WIDTH, 40)];
    self.collChooseView.backgroundColor = [YXColor whiteColor];
    [self.scrollView addSubview:self.collChooseView];
    
    
    for (int i = 0; i<self.collChooseArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000+i;
        [button setTitle:self.collChooseArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:ORDINARYFONT];
        [button setTitleColor:[YXColor blueColor] forState:UIControlStateSelected];
        [button setTitleColor:[YXColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(collChooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.collChooseView addSubview:button];
        button.frame = CGRectMake(SCREEN_WIDTH/2.0*i, 0, SCREEN_WIDTH/2.0, self.collChooseView.height);
        
        if (i == 0) {
            [self setBlueLineFrame:button];
            self.collChooseButton = button;
        }
    }
    
    self.collChooseButton.selected = YES;
    [self.collChooseView addSubview:self.collChooseLine];
    
    self.collectionTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.scrollView.width *3, CGRectGetMaxY(self.collChooseView.frame), self.scrollView.width, self.scrollView.height - CGRectGetMaxY(self.collChooseView.frame))];
    self.collectionTableView.delegate = self;
    self.collectionTableView.dataSource = self;
    [self.scrollView addSubview:self.collectionTableView];
    [YXShortcut deleteTableViewBlankline:self.collectionTableView];
    [self.collectionTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.collectionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.collChooseButton.tag == 1000) {
            [self collectionAddressRequest];
        }else{
            [self collectionMachineRequest];
        }
    }];
}
//设置蓝色线条位置
- (void)setBlueLineFrame:(UIButton *)button{
    CGFloat width = button.titleLabel.text.length * 14 ;
    
    self.collChooseLine.frame = CGRectMake(button.x + button.width/2.0 - width/2.0, button.height - 0.5, width, 0.5);
}
#pragma mark 选择列表
//主目录选择列表
- (void)chooseButtonClick:(UIButton *)sender{
    [self.selectButton setBackgroundColor:[YXColor whiteColor]];
    [self.selectButton setTitleColor:[YXColor lightGrayColor] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:self.btnImageArray[self.selectButton.tag - 1000]] forState:UIControlStateNormal];
    self.selectButton = sender;
    [self setSelectButtonStyle];
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.width * (sender.tag - 1000), 0);
}
//收藏目录选择列表
- (void)collChooseButtonClick:(UIButton *)sender{
    if (self.collChooseButton.tag != sender.tag) {
        //按钮改变
        self.collChooseButton.selected = NO;
        self.collChooseButton = sender;
        self.collChooseButton.selected = YES;
        
        //移动蓝色线
        [self setBlueLineFrame:sender];
        
        
        //刷新tableview
        [self.collectionTableView reloadData];
        if ((sender.tag == 1000 && _collAddressArray.count == 0) || (sender.tag == 1001 && _collMachineArray.count == 0)) {
            [self.collectionTableView.mj_header beginRefreshing];
        }
    }
}
#pragma mark AdScrollView delegate
-(NSInteger)adScrollView:(AdScrollView *)adScrollView numberOfRowsInSection:(NSInteger)index
{
    return _imageViewInfoArray.count;
}
-(UIView *)adScrollView:(AdScrollView *)adScrollView cellForRowAtIndexPath:(NSUInteger)index
{
    UIImageView *view = [[UIImageView alloc] init];
    for (id data in _imageViewInfoArray) {
        if ([data isKindOfClass:[NSString class]]) {
            view.image = [UIImage imageNamed:@"details_pic_default"];
        }else{
            NSDictionary *dic = _imageViewInfoArray[index];
            [view sd_setImageWithURL:[NSURL URLWithString:dic[@"bannerUrl"]] placeholderImage:[UIImage imageNamed:@"details_pic_default"]];
        }
    }
    view.userInteractionEnabled = YES;
    return view;
}
-(void)adScrollView:(AdScrollView *)adScrollView didSelectAtIndex:(NSInteger)index
{
    if (_imageViewInfoArray.count == 0) {
        return;
    }
    id data = _imageViewInfoArray[0];
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = _imageViewInfoArray[index];
        WebViewController *vc = [[WebViewController alloc]init];
        vc.title = dic[@"title"];
        vc.url = dic[@"Url"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)adClick:(NSInteger)count
{
    
}
#pragma mark 请求
//收藏洗衣点列表
- (void)collectionAddressRequest{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    handler.hideLoading = YES;
    [handler requestData:dic requestUrl:@"getCollectionLaundryPlaceList.do" present:self success:^(id obj) {
        _collAddressArray = obj[@"data"][@"laundryPlaceList"];
        [_collectionTableView reloadData];
        [_collectionTableView.mj_header endRefreshing];
        [self setcollectionAddressListFooter];
    } failed:^(id obj) {
        [_collectionTableView.mj_header endRefreshing];
        [self setcollectionAddressListFooter];
    }];
}
- (void)setcollectionAddressListFooter{
    BOOL isFoot = _collAddressArray.count == 0 ? NO :YES;
    [YXShortcut setTableView:_collectionTableView footInfo:isFoot];
}

//收藏洗衣机列表
- (void)collectionMachineRequest{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    handler.hideLoading = YES;
    [handler requestData:dic requestUrl:@"getCollectioWashingmachineList.do" present:self success:^(id obj) {
        _collMachineArray = obj[@"data"][@"washMachineList"];
        [_collectionTableView reloadData];
        [_collectionTableView.mj_header endRefreshing];
        [self setcollectionMachineListFooter];
    } failed:^(id obj) {
        [_collectionTableView.mj_header endRefreshing];
        [self setcollectionMachineListFooter];
    }];
}
- (void)setcollectionMachineListFooter{
    BOOL isFoot = _collMachineArray.count == 0 ? NO :YES;
    [YXShortcut setTableView:_collectionTableView footInfo:isFoot];
}
//订单列表
- (void)orderListRequest{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    handler.hideLoading = YES;
    [handler requestData:dic requestUrl:@"getOrderList.do" present:self success:^(id obj) {
        _orderArray = obj[@"data"][@"orderList"];
        [_orderTableView reloadData];
        
        [_orderTableView.mj_header endRefreshing];
        [self setOrderListFooter];
    } failed:^(id obj) {
        [_orderTableView.mj_header endRefreshing];
        [self setOrderListFooter];
    }];
}
- (void)setOrderListFooter{
    BOOL isFoot = _orderArray.count == 0 ? NO :YES;
    [YXShortcut setTableView:_orderTableView footInfo:isFoot];
}
//轮播图
- (void)imageRequest{
    BaseHandler *handler = [[BaseHandler alloc]init];
    handler.hideLoading = YES;
    [handler requestData:nil requestUrl:@"getBannerList.do" present:self success:^(id obj) {
        _imageViewInfoArray = obj[@"data"][@"bannerUrlList"];
        [self.imageScrollView reloadData];
    } failed:^(id obj) {
        
    }];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.orderTableView) {
        return _orderArray.count;
    }
    else{
        if ([self.collChooseButton.titleLabel.text isEqualToString:@"洗衣点"]) {//收藏洗衣点
            return _collAddressArray.count;
        }
        else{//收藏洗衣机
            return _collMachineArray.count;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.orderTableView) {//订单
        return 82;
    }
    else{
        if ([self.collChooseButton.titleLabel.text isEqualToString:@"洗衣点"]) {//收藏洗衣点
            return 48;
        }
        else{//收藏洗衣机
            return 86;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.orderTableView) {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell"];
        
        NSDictionary *dic = _orderArray[indexPath.row];
        
        cell.orderNumberLabel.text = [NSString stringWithFormat:@"订单号 %@",dic[@"orderNum"]];
        cell.orderAddressLabel.attributedText = [YXShortcut AttributedStringFromStringF:[NSString stringWithFormat:@"#%@",dic[@"laundrynum"]] stringS:[NSString stringWithFormat:@"%@%@",dic[@"laundryAddress"],dic[@"laundrynum"]] withColorF:[YXColor blueColor] withColorS:[YXColor grayColor] withFont:ORDINARYFONT];
        cell.orderMoneyLabel.text = [NSString stringWithFormat:@"订单金额 %@",[YXShortcut moneyNumber:[dic[@"orderPrice"] doubleValue] formatter:NSNumberFormatterCurrencyStyle]];
        
        cell.orderStyleLabel.text = [NSString stringWithFormat:@"%@",dic[@"orderStatus"]];
        
        return cell;
    }
    
    if ([self.collChooseButton.titleLabel.text isEqualToString:@"洗衣点"]) {//收藏洗衣点
        CollAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollAddressTableViewCell"];
        if (!cell) {
            cell = (CollAddressTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"CollAddressTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSDictionary *dic = _collAddressArray[indexPath.row];
        cell.addressLabel.text = dic[@"laundryplaceName"];
        
        return cell;
    }
    else{//收藏洗衣机
        CollMachineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollMachineTableViewCell"];
        if (!cell) {
            cell = (CollMachineTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"CollMachineTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
//        @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//        @property (weak, nonatomic) IBOutlet UILabel *numberLabel;//层数
//        @property (weak, nonatomic) IBOutlet UIImageView *styleImageView;
//        @property (weak, nonatomic) IBOutlet UILabel *styleLabel;
//        @property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
//        @property (weak, nonatomic) IBOutlet UILabel *addressLabel;

        NSDictionary *dic = _collMachineArray[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@层 %@号机",dic[@"schoolNum"],dic[@"floor"],dic[@"laundryNum"]];
        cell.numberLabel.text = [NSString stringWithFormat:@"%@层",dic[@"floor"]];
        cell.styleLabel.text = [NSString stringWithFormat:@"%@",dic[@"Status"]];
        cell.addressLabel.text = dic[@"address"];
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (tableView == self.orderTableView) {//订单
        YXOrderDetailViewController *vc = [[YXOrderDetailViewController alloc]init];
        vc.orderInfo = _orderArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        if ([self.collChooseButton.titleLabel.text isEqualToString:@"洗衣点"]) {//收藏洗衣点
            NSDictionary *dic = _collAddressArray[indexPath.row];
            CollAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            YXCollAddressDetailViewController *vc = [[YXCollAddressDetailViewController alloc]init];
            vc.title = cell.addressLabel.text;
            vc.addInfo = dic;
            vc.isCollection = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{//收藏洗衣机
            CollMachineTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            YXCollAddressDetailMoreViewController *vc = [[YXCollAddressDetailMoreViewController alloc]init];
            BaseNavViewController *nav = [[BaseNavViewController alloc]initWithRootViewController:vc];
            vc.title = cell.titleLabel.text;
            vc.getInfo = _collMachineArray[indexPath.row];
            vc.isCollection = YES;
            [self presentViewController:nav animated:YES completion:nil];
        }
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
