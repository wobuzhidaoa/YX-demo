//
//  RecommendCodeViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXAddressChooseViewController.h"
#import "AddressChooseTableViewCell.h"
@interface YXAddressChooseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger chooseRow;//选中的某行
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *tableArray;
@end

@implementation YXAddressChooseViewController

static NSString * const kCellIdentify = @"filecell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学校/企业/社区";
    
    //导航右按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:nil highImage:nil target:self action:@selector(rightBarButton:) title:@"确定"];
    
    
    chooseRow = -1;
    [self initTableView];
    
    [self request];
}
- (void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navHight, SCREEN_WIDTH, SCREEN_HEIGHT - navHight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [YXShortcut deleteTableViewBlankline:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AddressChooseTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentify];
}

#pragma mark request
- (void)request{
    BaseHandler *handler = [[BaseHandler alloc] init];
    [handler requestData:nil requestUrl:@"getSchoollist.do" present:self success:^(id obj) {
        self.tableArray = obj[@"data"][@"schoollist"];
        [self.tableView reloadData];
    } failed:^(id obj) {
        
    }];
}

#pragma mark tableView方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressChooseTableViewCell *cell = (AddressChooseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentify];
    
    NSDictionary *dic = _tableArray[indexPath.row];
    cell.contentLabel.text = dic[@"schoolname"];
    cell.chooseImageView.image = (indexPath.row == chooseRow) ? [UIImage imageNamed:@"icon_right"] : [UIImage imageNamed:@""];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    chooseRow = indexPath.row;
    [tableView reloadData];
}
#pragma mark 点击确定
- (void)rightBarButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (chooseRow >= 0) {
        AddressChooseBlock block = self.block;
        if (block) {
            block(_tableArray[chooseRow]);
        }
    }
    else{
        AddressChooseBlock block = self.block;
        if (block) {
            block(nil);
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
