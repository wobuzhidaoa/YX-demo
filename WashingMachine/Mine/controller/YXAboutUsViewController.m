//
//  YXAboutUsViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/9.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXAboutUsViewController.h"
#import "YXOpinionViewController.h"
@interface YXAboutUsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *tableArray;
@end

@implementation YXAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableArray = @[@"检查新版本",@"意见反馈",@"联系我们"];
    
    [self initMainView];
}


- (void)initMainView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.contentInset = UIEdgeInsetsMake(180, 0, 100, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [YXShortcut deleteTableViewBlankline:self.tableView];
    
    
    UIImageView *userImage=[[UIImageView alloc] init];
    userImage.layer.cornerRadius=5.0;
    userImage.layer.masksToBounds=YES;
    userImage.image=[UIImage imageNamed:@"about_logo"];
    [self.tableView addSubview:userImage];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    UILabel *Edition = [[UILabel alloc] init];
    Edition.text = [NSString stringWithFormat:@"智享洗衣%@",version];
    Edition.textAlignment = NSTextAlignmentCenter;
    Edition.textColor = [YXColor blackColor];
    Edition.font = ORDINARYFONT;
    [self.tableView addSubview:Edition];
    
    
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"河南优洗网络科技股份有限公司";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [YXColor grayColor];
    label.font = SMALLFONT;
    [self.tableView addSubview:label];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(navHight+SIDESSPACING);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView.mas_top).offset(-60);
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_HEIGHT*0.2, SCREEN_HEIGHT*0.2));
        
    }];
    
    [Edition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userImage.mas_bottom).offset(15);
        make.centerX.equalTo(self.tableView.mas_centerX);
    }];
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.centerX.equalTo(self.tableView.mas_centerX);
    }];
    
    
    
}


#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"aboutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *text = self.tableArray[indexPath.row];
    cell.textLabel.text = text;
    cell.textLabel.font = TITIEFONT;
    
    cell.detailTextLabel.font = ORDINARYFONT;
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = @"1.1";
        cell.detailTextLabel.textColor = [YXColor grayColor];
    }else if (indexPath.row == 2){
        cell.detailTextLabel.text = @"400-700-8860";
        cell.detailTextLabel.textColor = [YXColor colorWithHexString:@"#fc9a30"];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self newVersion];
    }
    else if (indexPath.row == 1){
        [self feedback];
    }
    else if (indexPath.row == 2){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self call:cell.detailTextLabel.text];
    }
}


//检查新版本
- (void)newVersion{
    BaseHandler *handler = [[BaseHandler alloc]init];
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"type",version,@"currentVersionName", nil];
    [handler requestData:dic requestUrl:@"update" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"] integerValue];
        if (code == 0) {
            NSInteger versionNameNumber = [self getFromString:obj[@"data"][@"versionName"]];
            NSInteger versionNumber = [self getFromString:version];
            if (versionNameNumber > versionNumber) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];//https://itunes.apple.com/cn/app/xiao-shou-zhuan-jia/id1088733275?mt=8
            }else{
                [YXShortcut showText:@"已是最新版本"];
            }
        }
    } failed:^(id obj) {
        
    }];
}
//版本号nsstring转int
- (NSInteger)getFromString:(NSString *)string
{
    NSArray *array=[string componentsSeparatedByString:@"."];
    NSString *newString;
    for (int i=0; i<array.count; i++) {
        NSString *arrStr=[array objectAtIndex:i];
        if (i==0) {
            newString=arrStr;
        }else{
            newString=[NSString stringWithFormat:@"%@%@",newString,arrStr];
        }
    }
    NSInteger versionNum=[newString integerValue];
    
    return versionNum;
}
//意见反馈
- (void)feedback{
    YXOpinionViewController *vc = [[YXOpinionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//联系我们
- (void)call:(NSString *)number{
    UIWebView * callWebview = [[UIWebView alloc]init];
    callWebview.delegate = self;
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]]]];
    [self.view addSubview:callWebview];
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
