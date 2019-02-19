//
//  YXCollAddressViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/8.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXNearAddressViewController.h"
#import "NearAddressTableViewCell.h"
#import "MapViewController.h"
@interface YXNearAddressViewController ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
{
    MBProgressHUD *_hud;
    CGFloat latitude;
    CGFloat longitude;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *tableArray;
@property (nonatomic,strong)AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@end

@implementation YXNearAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"附近洗衣点";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"nav_map" highImage:nil target:self action:@selector(rightBarButtonClick:)];
    [self initView];
    
    [self initCompleteBlock];
    [self configLocationManager];
    [self.tableView.mj_header beginRefreshing];
}
- (void)rightBarButtonClick:(UIButton *)sender{
    if (_tableArray.count == 0) {
        [YXShortcut showText:@"暂无数据"];
    }else{
        MapViewController *vc = [[MapViewController alloc]init];
        vc.listArray = self.tableArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark 定位
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    //[self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
}

- (void)reGeocodeAction
{
    [self showLoading];
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}
- (void)initCompleteBlock
{
    __weak YXNearAddressViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        [weakSelf dismissLoading];
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            [weakSelf.tableView.mj_header endRefreshing];
            //如果为定位失败的error
            if (error.code == AMapLocationErrorLocateFailed || error.code == AMapLocationErrorNotConnectedToInternet || error.code == AMapLocationErrorTimeOut)
            {
                [YXShortcut showText:@"定位失败"];
                return;
            }
        }
        
        //得到定位信息
        if (location)
        {
            if (regeocode)
            {
                latitude = location.coordinate.latitude;
                longitude = location.coordinate.longitude;
                [weakSelf request];
            }
        }
        
    };
}
- (void)showLoading
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.margin = 8;
    _hud.label.text = @" 定位中... ";
    _hud.label.font = [UIFont systemFontOfSize:15];
    _hud.contentColor = [YXColor whiteColor];
    _hud.customView.bounds = CGRectMake(0, 0, 50, 50);
    _hud.bezelView.backgroundColor = [YXColor blackColor];
}

- (void)dismissLoading
{
    [_hud hideAnimated:YES afterDelay:.5];
    [_hud removeFromSuperview];
}
#pragma mark request
- (void)request{
    //longitude=113.672833&latitude=34.695155
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",longitude],@"longitude",[NSString stringWithFormat:@"%f",latitude],@"latitude", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    handler.hideLoading = YES;
    [handler requestData:dic requestUrl:@"laundryNearby.do" present:self success:^(id obj) {
        _tableArray = obj[@"data"][@"nearlaundryList"];
        [_tableView reloadData];
        
        BOOL isHave = _tableArray.count!=0 ? YES : NO;
        [YXShortcut setTableView:_tableView footInfo:isHave];
        [self.tableView.mj_header endRefreshing];
    } failed:^(id obj) {
        [YXShortcut setTableView:_tableView footInfo:NO];
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark 界面
- (void)initView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navHight, SCREEN_WIDTH, SCREEN_HEIGHT - navHight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [YXShortcut deleteTableViewBlankline:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"NearAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"NearAddressTableViewCell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reGeocodeAction];
    }];
}

#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tableArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEWSECTIONHIGHT;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearAddressTableViewCell"];
    
    NSDictionary *dic = _tableArray[indexPath.row];
    [YXShortcut setImageView:cell.machineImageView WithUrlStr:dic[@"schoolNumIcon"]];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",dic[@"school"],dic[@"buildnum"]];
    cell.styleLabel.text = [NSString stringWithFormat:@"%@台空闲",dic[@"freeLaundryNum"]];
    CGFloat distance = [dic[@"distance"] floatValue];
    cell.distanceLabel.text = (distance > 1000) ? [NSString stringWithFormat:@"%.2f千米",distance/1000] : [NSString stringWithFormat:@"%.2f米",distance];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
