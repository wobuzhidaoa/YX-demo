//
//  YXCollAddressDetailViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/7.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXCollAddressDetailViewController.h"
#import "CollAddressDetailTableViewCell.h"
#import "YXCollAddressDetailMoreViewController.h"
#import "BaseNavViewController.h"
@interface YXCollAddressDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *navLine;
    UIButton *rightButton;//导航栏button
}
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIImageView *launImageView;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UILabel *infoLabel;

@property(nonatomic,strong)UIScrollView *directoryView;
@property(nonatomic,strong)NSArray *directoryArray;
@property(nonatomic,strong)UIButton *selectButton;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *listInfoArray;
@property(nonatomic,strong)NSMutableArray *tableArray;
@end

@implementation YXCollAddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航栏线
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    navLine = backgroundView.subviews.firstObject;
    
    [self setNavRightbarButton];
    
    [self initView];
    [self buildInfoRequest];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    navLine.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    navLine.hidden = NO;
}
- (void)rightBarButtonClick:(UIButton *)sender{
    //collectionBuild.do?type=2&userId=11&buildId=0decd8e9ddac403da88cb22c5817931e
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSString *type = self.isCollection ? @"2" : @"1";
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",type,@"type",_addInfo[@"laundryplaceId"],@"buildId", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"collectionBuild.do" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"] integerValue];
        if (code == 0) {
            self.isCollection = !self.isCollection;
            [self setNavRightbarButton];
        }
    } failed:^(id obj) {
        
    }];
}
- (void)setNavRightbarButton{
    NSString *imageStr = self.isCollection ? @"popup_icon_collection_pre" : @"popup_icon_collection";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:imageStr highImage:nil target:self action:@selector(rightBarButtonClick:)];
}
#pragma mark 楼层信息
- (void)buildInfoRequest{
    //buildInfo.do?schoolNumId=0decd8e9ddac403da88cb22c5817931e&userId=11
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",_addInfo[@"laundryplaceId"],@"schoolNumId", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"buildInfo.do" present:self success:^(id obj) {
//        _listInfoArray = obj[@"data"];
//        _tableArray = [NSMutableArray arrayWithArray:_listInfoArray];
//        [_tableView reloadData];
        NSDictionary *dic = obj[@"data"];
        [YXShortcut setImageView:_launImageView WithUrlStr:dic[@"schoolNumIcon"]];
        self.isCollection = [dic[@"isCollection"] integerValue] == 2 ? YES : NO;
        self.addressLabel.text = dic[@"schoolNum"];
        self.infoLabel.text = [NSString stringWithFormat:@"设备：%@ | 数量：%@",dic[@"equipmentName"],dic[@"laundryNum"]];
    } failed:^(id obj) {
        
    }];
}
#pragma mark 界面
- (void)initView{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, navHight, SCREEN_WIDTH, 48)];
    self.topView.backgroundColor = [YXColor blueFirColor];
    [self.view addSubview:self.topView];
    
    _launImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SIDESSPACING, 4, 40, 40)];
    [self.topView addSubview:_launImageView];
    [YXShortcut setImageView:_launImageView WithUrlStr:@""];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_launImageView.frame)+10, _launImageView.y, SCREEN_WIDTH - CGRectGetMaxX(_launImageView.frame) - 20, 20)];
    self.addressLabel.text = _addInfo[@"laundryplaceName"];
    self.addressLabel.textColor = [YXColor whiteColor];
    self.addressLabel.font = TITIEFONT;
    [self.topView addSubview:self.addressLabel];
    
    self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.addressLabel.x, CGRectGetMaxY(self.addressLabel.frame), self.addressLabel.width, self.addressLabel.height)];
    self.infoLabel.text = @"设备：洗衣机 | 数量：6";
    self.infoLabel.textColor = [YXColor whiteColor];
    self.infoLabel.font = TITIEFONT;
    [self.topView addSubview:self.infoLabel];
    
    [self initDirView];
}
//目录选择栏
- (void)initDirView{
    self.directoryView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, 48)];
    self.directoryView.backgroundColor = [YXColor whiteColor];
    [self.view addSubview:self.directoryView];
    [self.directoryView setShowsHorizontalScrollIndicator:NO];
    self.directoryArray = @[@"全部",@"1层",@"2层",@"3层",@"4层",@"5层",@"6层",@"7层",@"8层",@"9层"];
    CGFloat X = 0;
    for (NSInteger i = 0; i<self.directoryArray.count; i++) {
        UIButton *dirButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dirButton.tag = 1000+i;
        [dirButton addTarget:self action:@selector(dirButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *dirStr = self.directoryArray[i];
        CGFloat width = 16*dirStr.length + 10;
        dirButton.frame = CGRectMake(X, 0, width, self.directoryView.height);
        [self.directoryView addSubview:dirButton];
        X += width;
        
        if (i == 0) {
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:dirStr];
            [mutStr addAttribute:NSForegroundColorAttributeName value:[YXColor blackColor] range:NSMakeRange(0,dirStr.length)];
            [mutStr addAttribute:NSFontAttributeName value:TITIEFONT range:NSMakeRange(0,dirStr.length)];
            [dirButton setAttributedTitle:mutStr forState:UIControlStateNormal];
            self.selectButton = dirButton;
        }
        else{
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:dirStr];
            [mutStr addAttribute:NSForegroundColorAttributeName value:[YXColor lightGrayColor] range:NSMakeRange(0,dirStr.length)];
            [mutStr addAttribute:NSFontAttributeName value:ORDINARYFONT range:NSMakeRange(0,dirStr.length-1)];
            [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(dirStr.length - 1,1)];
            
            [dirButton setAttributedTitle:mutStr forState:UIControlStateNormal];
        }
    }
    
    self.directoryView.contentSize = CGSizeMake(X, self.directoryView.height);
    
    
    [self initTableView];
}
- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.directoryView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.directoryView.frame) - 10)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [YXShortcut deleteTableViewBlankline:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CollAddressDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollAddressDetailTableViewCell"];
}
#pragma mark 目录栏点击
- (void)dirButtonClick:(UIButton *)sender{
    if (sender != self.selectButton) {
        [self setButtonAttText:self.selectButton colorBool:NO];
        self.selectButton = sender;
        [self setButtonAttText:self.selectButton colorBool:YES];
    }
}
- (void)setButtonAttText:(UIButton *)sender colorBool:(BOOL)bColor{
    UIColor *color = bColor ? [YXColor blackColor] : [YXColor lightGrayColor];
    NSInteger number = sender.tag - 1000;
    NSString *dirStr = self.directoryArray[number];
    if (number == 0) {
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:dirStr];
        [mutStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,dirStr.length)];
        [mutStr addAttribute:NSFontAttributeName value:TITIEFONT range:NSMakeRange(0,dirStr.length)];
        [sender setAttributedTitle:mutStr forState:UIControlStateNormal];
    }
    else{
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:dirStr];
        [mutStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,dirStr.length-1)];
        [mutStr addAttribute:NSForegroundColorAttributeName value:[YXColor lightGrayColor] range:NSMakeRange(dirStr.length-1,1)];
        [mutStr addAttribute:NSFontAttributeName value:ORDINARYFONT range:NSMakeRange(0,dirStr.length-1)];
        [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(dirStr.length - 1,1)];
        
        [sender setAttributedTitle:mutStr forState:UIControlStateNormal];
    }
}
#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollAddressDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollAddressDetailTableViewCell"];
//    @property (weak, nonatomic) IBOutlet UILabel *buildingNumberLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *layerNumberLabel;
//    @property (weak, nonatomic) IBOutlet UIImageView *machineImageView;
//    @property (weak, nonatomic) IBOutlet UILabel *styleLabel;
    
//    NSDictionary *dic = _tableArray[indexPath.row];
//    cell.buildingNumberLabel.text = [NSString stringWithFormat:@"%@#",dic[@""]];
//    cell.contentLabel.text = [NSString stringWithFormat:@"%@%@层%@号机",dic[@"schoolNum"],dic[@"floor"],dic[@"laundryNum"]];
//    cell.layerNumberLabel.text = [NSString stringWithFormat:@"%@层",dic[@"floor"]];
//    cell.styleLabel.text = [NSString stringWithFormat:@"%@",dic[@"status"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CollAddressDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    YXCollAddressDetailMoreViewController *vc = [[YXCollAddressDetailMoreViewController alloc]init];
    BaseNavViewController *nav = [[BaseNavViewController alloc]initWithRootViewController:vc];
    vc.title = cell.contentLabel.text;
//    vc.getInfo = _tableArray[indexPath.row];
    [self presentViewController:nav animated:YES completion:nil];
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
