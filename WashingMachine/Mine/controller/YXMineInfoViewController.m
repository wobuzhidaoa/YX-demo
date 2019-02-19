//
//  YXSetViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/3.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXMineInfoViewController.h"
#import "YXSetTableViewCell.h"
#import "YXChangePsdViewController.h"
#import "YXChangePayPsdViewController.h"
#import "MLDPhotoManager.h"
#import "YXTextboxViewController.h"
#import "DatePickerView.h"
#import "YXAddressChooseViewController.h"
@interface YXMineInfoViewController ()<UITableViewDelegate,UITableViewDataSource,DatePickerViewDelegate>
{
    MLDPhotoManager *mldPhoto;//相机相册
    
    DatePickerView *datePicker;//日期选择
    NSString *selectDateStr;
    
    MBProgressHUD *_hud;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray *contentArray;

@end

@implementation YXMineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    
    [self initView];
}

- (void)initView{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    self.titleArray = @[@[@"头像",@"昵称",@"手机号",@"我的二维码"],@[@"地址",@"姓名",@"性别",@"出生年月"],@[@"学校",@"年级"],@[@"修改登录密码",@"修改支付密码"]];
    NSArray *arr1 = @[userInfo[@"userPic"],userInfo[@"nickname"],userInfo[@"phone"],@"icon_code"];
    NSArray *arr2 = @[userInfo[@"address"],userInfo[@"username"],userInfo[@"sex"],userInfo[@"birthday"]];
    NSArray *arr3 = @[userInfo[@"school"],[NSString stringWithFormat:@"%@",userInfo[@"grade"]]];
    NSArray *arr4 = @[@"",@""];
    self.contentArray = [[NSMutableArray alloc] initWithObjects:arr1,arr2,arr3,arr4, nil];
    
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [YXShortcut deleteTableViewBlankline:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(navHight);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YXSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXSetTableViewCell"];
}

#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return TABLEVIEWSECTIONHIGHT;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titleArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXSetTableViewCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NLog(@"%@___%@",self.titleArray[indexPath.section][indexPath.row],self.contentArray[indexPath.section][indexPath.row]);
    cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 3)) {
        cell.contentLabel.text = @"";
        if (indexPath.row == 0) {
            [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.contentArray[indexPath.section][indexPath.row]] placeholderImage:[UIImage imageNamed:@"user_head_portrait"]];
            cell.contentImageView.layer.masksToBounds = YES;
            cell.contentImageView.layer.cornerRadius = cell.contentImageView.width/8.0;
        }else{
            cell.contentImageView.image = [UIImage imageNamed:self.contentArray[indexPath.section][indexPath.row]];
        }
    }
    else{
        cell.contentLabel.text = self.contentArray[indexPath.section][indexPath.row];
        cell.contentImageView.image = [UIImage imageNamed:@""];
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        //头像
        [self setPhoto];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        //昵称
        YXTextboxViewController *vc = [[YXTextboxViewController alloc]init];
        vc.title = self.titleArray[indexPath.section][indexPath.row];
        vc.block = ^(NSString *str) {
            [self updateInfoWithKey:@"nickname" value:str withIndexPath:indexPath];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        //手机号
        
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        //二维码
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        //地址
        YXTextboxViewController *vc = [[YXTextboxViewController alloc]init];
        vc.title = self.titleArray[indexPath.section][indexPath.row];
        vc.block = ^(NSString *str) {
            [self updateInfoWithKey:@"address" value:str withIndexPath:indexPath];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        //姓名
        YXTextboxViewController *vc = [[YXTextboxViewController alloc]init];
        vc.title = self.titleArray[indexPath.section][indexPath.row];
        vc.block = ^(NSString *str) {
            [self updateInfoWithKey:@"username" value:str withIndexPath:indexPath];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        //性别
        [self setSex:indexPath];
    }
    else if (indexPath.section == 1 && indexPath.row == 3) {
        //出生年月
        [self setBirthday];
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        //学校
        YXAddressChooseViewController *vc = [[YXAddressChooseViewController alloc]init];
        vc.block = ^(NSDictionary *dic) {
           NSString *school = dic[@"schoolname"];
            [self updateInfoWithKey:@"school" value:school withIndexPath:indexPath];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 1) {
        //年级
        YXTextboxViewController *vc = [[YXTextboxViewController alloc]init];
        vc.title = self.titleArray[indexPath.section][indexPath.row];
        vc.block = ^(NSString *str) {
            [self updateInfoWithKey:@"grade" value:str withIndexPath:indexPath];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 3 && indexPath.row == 0) {
        //登录密码
        YXChangePsdViewController *vc = [[YXChangePsdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 3 && indexPath.row == 1){
        //支付密码
        YXChangePayPsdViewController *vc = [[YXChangePayPsdViewController alloc]init];
        vc.title = @"修改支付密码";
        vc.topStr = @"请输入原支付密码";
        vc.neegForget = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark 修改资料
- (void)updateInfoWithKey:(NSString *)key value:(NSString *)value withIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"userId"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",key,@"userInfokey",value,@"userInfovalue", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"updateUserInfo.do" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"]integerValue];
        if (code == 0) {
            //刷新列表
            NSArray *arr = self.contentArray[indexPath.section];
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
            [mutArr replaceObjectAtIndex:indexPath.row withObject:value];
            [self.contentArray replaceObjectAtIndex:indexPath.section withObject:mutArr];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            //更新本地数据
            NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
            [mutDic setValue:value forKey:key];
            [UserDefaultsUtils saveValue:mutDic forKey:@"userInfo"];
        }
    } failed:^(id obj) {
        
    }];
}
//修改头像
- (void)updateUserMinPhotoWithImage:(UIImage *)image{
    image = [self setImageSize:image];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLoading];
    });
    
    NSData *data = UIImagePNGRepresentation(image);
    UploadDownLoad *upload = [[UploadDownLoad alloc]init];
    NSDictionary *photoDic = [upload UpLoading:data];
    if (!photoDic) {
        [self dismissLoading];
        return;
    }
    else{
        [self dismissLoading];
        
        NSString *value = photoDic[@"data"][@"imgUrl"];
        //刷新列表
        NSArray *arr = self.contentArray[0];
        NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
        [mutArr replaceObjectAtIndex:0 withObject:value];
        [self.contentArray replaceObjectAtIndex:0 withObject:mutArr];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        //更新本地数据
        NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        [mutDic setValue:value forKey:@"userPic"];
        [UserDefaultsUtils saveValue:mutDic forKey:@"userInfo"];

    }
}
- (void)showLoading
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    _hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.margin = 8;
    _hud.label.text = @" 加载中... ";
    _hud.label.font = [UIFont systemFontOfSize:15];
    _hud.contentColor = [YXColor whiteColor];
    _hud.customView.bounds = CGRectMake(0, 0, 50, 50);
    _hud.bezelView.backgroundColor = [YXColor blackColor];
}

- (void)dismissLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud hideAnimated:YES afterDelay:.5];
        [_hud removeFromSuperview];
    });
}
#pragma mark 头像
- (void)setPhoto{
    if (!mldPhoto) {
        mldPhoto = [[MLDPhotoManager alloc]init];
    }
    [mldPhoto showPhotoManager:self.view
             withMaxImageCount:1
                      withType:1
               withCameraImage:^(UIImage *cameraImage) {
                   if (cameraImage) {
                       [self updateUserMinPhotoWithImage:cameraImage];
                   }
    }
                withAlbumArray:^(NSArray *albumArray) {
                    if (albumArray.count == 0) {
                        return;
                    }
                    UIImage *image = albumArray[0];
                    [self updateUserMinPhotoWithImage:image];
    }];
}
- (UIImage *)setImageSize:(UIImage *)image{
    //设置image的尺寸
    CGSize imagesize = image.size;
    imagesize.height =200;
    imagesize.width =200;
    //对图片大小进行压缩--
    return [self imageWithImage:image scaledToSize:imagesize];
}
//对图片尺寸进行压缩--
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark 性别
- (void)setSex:(NSIndexPath *)indexPath{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"男"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [self updateInfoWithKey:@"sex" value:@"男" withIndexPath:indexPath];
                                }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"女"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action)
                      {
                          [self updateInfoWithKey:@"sex" value:@"女" withIndexPath:indexPath];
                      }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action)
                      {
                          NLog(@"取消");
                      }]];
    [self presentViewController:sheet animated:YES completion:nil];
}

#pragma mark 生日
- (void)setBirthday{
    if (!datePicker) {
        datePicker = [[DatePickerView alloc]initWithFrame:CGRectMake(0, navHight, SCREEN_WIDTH, 216+40)];
        datePicker.delegate = self;
        [self.view addSubview:datePicker];
    }
    
    [datePicker show];
}

//datepickerview 代理
- (void)datePickerViewSureWithDate:(NSString *)date{
    selectDateStr = date;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
    [self updateInfoWithKey:@"birthday" value:selectDateStr withIndexPath:indexPath];
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
