//
//  YXSetViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/9.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXSetViewController.h"
#import "LoginViewController.h"
#import "YXAboutUsViewController.h"
@interface YXSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *tableArray;
@end

@implementation YXSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableArray = @[@"清空缓存",@"关于我们"];
    [self initView];
}

- (void)initView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navHight + SIDESSPACING, SCREEN_WIDTH, self.tableArray.count*44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [YXShortcut deleteTableViewBlankline:self.tableView];
    self.tableView.scrollEnabled = NO;
    
    
    UIButton * loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutButton.backgroundColor = [YXColor blueColor];
    [loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
    [loginOutButton addTarget:self action:@selector(LoginOutClick:) forControlEvents:UIControlEventTouchUpInside];
    loginOutButton.frame = CGRectMake(30, CGRectGetMaxY(self.tableView.frame) + 20, SCREEN_WIDTH - 60, 40);
    loginOutButton.layer.masksToBounds = YES;
    loginOutButton.layer.cornerRadius = loginOutButton.height/2.0;
    [self.view addSubview:loginOutButton];
}
- (void)LoginOutClick:(UIButton *)sender{
//    1	userId	用户Id	是	[string]		查看
//    2	username	用户名	是	[string]		查看
//    3	phone	手机号	是	[string]
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo[@"userId"],@"userId",userInfo[@"username"],@"username",userInfo[@"phone"],@"phone", nil];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:dic requestUrl:@"logout" present:self success:^(id obj) {
        NSInteger code = [obj[@"code"] integerValue];
        if (code == 0) {
            [UserDefaultsUtils removeWithKey:@"accessToken"];
            [UserDefaultsUtils removeWithKey:@"walletInfo"];
            [UserDefaultsUtils removeWithKey:@"userInfo"];
            LoginViewController *vc = [[LoginViewController alloc]init];
            self.view.window.rootViewController = vc;
        }
    } failed:^(id obj) {
        
    }];
}

#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"setCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *text = self.tableArray[indexPath.row];
    cell.textLabel.text = text;
    cell.textLabel.font = TITIEFONT;
    
    cell.detailTextLabel.text = (indexPath.row == 0) ? [self getCacheSize] : @"";
    cell.detailTextLabel.font = ORDINARYFONT;
    cell.detailTextLabel.textColor = [YXColor grayColor];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定清理缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self clearCache];
            [self.tableView reloadData];
        }]];
        [self presentViewController:alert animated:NO completion:nil];
    }
    else if (indexPath.row == 1){
        YXAboutUsViewController *vc = [[YXAboutUsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark 缓存处理
//计算缓存
- (NSString *)getCacheSize
{
    //定义变量存储总的缓存大小
    long long sumSize = [self readCacheSize];
    
    
    //本地下载图片和文件
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
//    NSString *extension = @"userimage";
//    NSString *extension1 = @"files";
//    NSString *extension2 = @"HyphenateSDK";
//    for (NSString *fileName in contents) {
//        if ([fileName isEqualToString:extension] || [fileName isEqualToString:extension1] || [fileName isEqualToString:extension2]) {
//            long long fileSize = ([fileName isEqualToString:extension2]) ? [[NSString stringWithFormat:@"%@/%@/appdata",documentsDirectory,fileName] fileSize] : [[NSString stringWithFormat:@"%@/%@",documentsDirectory,fileName] fileSize];
//            sumSize += fileSize;
//        }
//    }
    float size_m = sumSize/(1000.0*1000.0);
    return [NSString stringWithFormat:@"%.2fM",size_m];
}
-(float)readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [self folderSizeAtPath :cachePath];
}


//由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
// 遍历文件夹获得文件夹大小，返回多少 M
- (long long) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize;
    
}
// 计算 单个文件的大小
- (long long) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}
//清理缓存
-(void) clearCache
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    
    
    //下载的文件
//    NSString *extension = @"userimage";
//    NSString *extension1 = @"files";
//    NSString *extension2 = @"HyphenateSDK";
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
//    NSEnumerator *e = [contents objectEnumerator];
//    NSString *filename;
//    while ((filename = [e nextObject])) {
//        
//        if ([filename isEqualToString:extension]||[filename isEqualToString:extension1] || [filename isEqualToString:extension2]) {
//            if ([filename isEqualToString:extension2]) {
//                NSString *newPath = [NSString stringWithFormat:@"%@/%@/appdata",documentsDirectory,filename];
//                NSArray *fileList = [fileManager contentsOfDirectoryAtPath:newPath error:nil];
//                for(int i=0;i<[fileList count]; i++)
//                {
//                    NSString *filePath = [NSString stringWithFormat:@"%@/%@",newPath,fileList[i]];
//                    NSURL *filepaht1=[NSURL fileURLWithPath:filePath];
//                    
//                    [fileManager removeItemAtURL:filepaht1 error:nil];
//                }
//            }else{
//                [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
//            }
//        }
//    }
    
    //删除数据库数据
}

-(void)clearCacheSuccess
{
    [YXShortcut alertWithTitle:nil message:@"缓存清理成功" controller:self buttonNumber:NO];
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
