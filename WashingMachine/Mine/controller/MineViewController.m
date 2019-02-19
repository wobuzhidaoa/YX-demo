//
//  MineViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "YXMineInfoViewController.h"
#import "BaseNavViewController.h"
#import "YXSetViewController.h"
#import "YXHelpViewController.h"
#import "YXAboutUsViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MineMessageViewController.h"
#import "MineDiscountViewController.h"
#import "MineInvitationViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //bool 用于判断界面是pop返回还是tabbar切换 yes:pop
    BOOL appearType;
    
    NSDictionary *userInfo;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *tabImageArray;
@property (nonatomic,strong)NSArray *tabTitleArray;

//个人信息view
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIImageView *headPortraitImageView;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *schoolLabel;
@end

@implementation MineViewController
- (UIImageView *)headPortraitImageView{
    if (!_headPortraitImageView) {
        _headPortraitImageView = [[UIImageView alloc]init];
    }
    return _headPortraitImageView;
}
- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.textColor = [YXColor whiteColor];
        _phoneLabel.font = TITIEFONT;
    }
    return _phoneLabel;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [YXColor whiteColor];
        _nameLabel.font = TITIEFONT;
    }
    return _nameLabel;
}
- (UILabel *)schoolLabel{
    if (!_schoolLabel) {
        _schoolLabel = [[UILabel alloc]init];
        _schoolLabel.textColor = [YXColor whiteColor];
        _schoolLabel.font = SMALLFONT;
    }
    return _schoolLabel;
}
#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    
    self.tabTitleArray = @[@[@""],@[@"个人资料",@"我的消息"],@[@"商家优惠",@"邀请好友"],@[@"帮助中心",@"分享给好友"]];
    self.tabImageArray = @[@[@""],@[@"user_icon_personal",@"user_icon_information"],@[@"user_icon_discount",@"user_icon_friends"],@[@"user_icon_help",@"user_icon_share"]];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:appearType];
    
    //人物信息更新
    userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    self.phoneLabel.text = userInfo[@"phone"];
    self.nameLabel.text = userInfo[@"username"];
    self.schoolLabel.text = userInfo[@"school"];
    [self.headPortraitImageView sd_setImageWithURL:[NSURL URLWithString:userInfo[@"userPic"]] placeholderImage:[UIImage imageNamed:@"user_head_portrait"]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    appearType = (self.navigationController.viewControllers.count == 1) ? NO : YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark UI
- (void)initView{
    //底部图片
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2.0)];
    topImageView.image = [YXShortcut createImageWithColor:[YXColor blueFirColor]];
    [self.view addSubview:topImageView];
    
    
    [self initTopView];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [YXShortcut deleteTableViewBlankline:self.tableView];
    self.tableView.backgroundColor = [YXColor backGrayColor];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell"];
}
- (void)initTopView{
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = [YXColor blueFirColor];
    UIImageView *topBackImageView = [[UIImageView alloc]init];
    topBackImageView.image = [UIImage imageNamed:@"user_bg"];
    [self.topView addSubview:topBackImageView];
    
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setButton setImage:[UIImage imageNamed:@"nav_set_up"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    setButton.frame = CGRectMake(SCREEN_WIDTH - 45, 20, 44, 44);
    [setButton setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
    [self.topView addSubview:setButton];
    
    //头像宽高 60
    CGFloat phoneH = 60;
    //label 高
    CGFloat lableH = 20;
    //label 间隔
    CGFloat spacing = 5;
    
    self.phoneLabel.text = userInfo[@"phone"];
    self.phoneLabel.frame = CGRectMake(phoneH+25, CGRectGetMaxY(setButton.frame)+20, SCREEN_WIDTH-85, lableH);
    [self.topView addSubview:self.phoneLabel];
    
    self.nameLabel.text = userInfo[@"username"];
    self.nameLabel.frame = CGRectMake(self.phoneLabel.x, CGRectGetMaxY(self.phoneLabel.frame)+spacing, self.phoneLabel.width, self.phoneLabel.height);
    [self.topView addSubview:self.nameLabel];
    
    
    self.schoolLabel.text = userInfo[@"school"];
    self.schoolLabel.frame = CGRectMake(self.phoneLabel.x, CGRectGetMaxY(self.nameLabel.frame)+spacing, self.phoneLabel.width, self.phoneLabel.height);
    [self.topView addSubview:self.schoolLabel];
    
    [self.headPortraitImageView sd_setImageWithURL:[NSURL URLWithString:userInfo[@"userPic"]] placeholderImage:[UIImage imageNamed:@"user_head_portrait"]];
    self.headPortraitImageView.frame = CGRectMake(10, self.nameLabel.centerY-phoneH/2.0, phoneH, phoneH);
    [self.topView addSubview:self.headPortraitImageView];
    self.headPortraitImageView.layer.masksToBounds = YES;
    self.headPortraitImageView.layer.cornerRadius = self.headPortraitImageView.width/8.0;
    
    //需要高度
    CGFloat needHight = CGRectGetMaxY(self.schoolLabel.frame)+20;
    //图片比例高度
    CGFloat photoHight = SCREEN_WIDTH*393/1080.0;
    if (needHight>photoHight) {
        self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, needHight);
        topBackImageView.frame = CGRectMake(0, needHight-photoHight, SCREEN_WIDTH, photoHight);
    }
    else{
        self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*393/1080.0);
        topBackImageView.frame = self.topView.bounds;
    }
    
}

#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tabTitleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return TABLEVIEWSECTIONHIGHT;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.tabTitleArray[section];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.topView.height;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:self.topView];
        }
        
        return cell;
    }
    else{
        MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.contentLabel.text = self.tabTitleArray[indexPath.section][indexPath.row];
        cell.tImageView.image = [UIImage imageNamed:self.tabImageArray[indexPath.section][indexPath.row]];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self mineInfomation];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        [self mineMessage];
    }else if (indexPath.section == 2 && indexPath.row == 0){
        [self mineDiscount];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        [self mineInvitation];
    }else if (indexPath.section == 3 && indexPath.row == 0){
        [self mineHelp];
    }else if (indexPath.section == 3 && indexPath.row == 1){
        [self mineShare];
    }
}
//个人资料
- (void)mineInfomation{
    YXMineInfoViewController *vc = [[YXMineInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//我的消息
- (void)mineMessage{
    MineMessageViewController *vc = [[MineMessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//商家优惠
- (void)mineDiscount{
    MineDiscountViewController *vc = [[MineDiscountViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//邀请好友
- (void)mineInvitation{
    MineInvitationViewController *vc = [[MineInvitationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//帮助中心
- (void)mineHelp{
    YXHelpViewController *vc = [[YXHelpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//分享给好友
- (void)mineShare{
    
    
    
    
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"about_logo"]];//如果要分享网络图片images:@[@"http://mob.com"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"这是一条测试信息"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"www.baidu.com"]
                                          title:@"测试"
                                           type:SSDKContentTypeAuto];
        //微博客户端授权
        [shareParams SSDKEnableUseClientShare];
        
        //2、分享
        [ShareSDK showShareActionSheet:self.view.window items:nil
                           shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    [YXShortcut alertWithTitle:@"分享成功" message:nil controller:self buttonNumber:NO];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    [YXShortcut alertWithTitle:@"分享失败" message:nil controller:self buttonNumber:NO];
                    break;
                }
                default:
                    break;
            }
        }];

    }
    
}
#pragma mark 设置
- (void)setButtonClick:(UIButton *)sender{
    YXSetViewController *vc = [[YXSetViewController alloc]init];
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
