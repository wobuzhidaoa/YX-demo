//
//  BaseTabBarViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavViewController.h"
#import "HomeViewController.h"
#import "OptimalWashViewController.h"
#import "WalletViewController.h"
#import "MineViewController.h"
@interface BaseTabBarViewController ()

@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,strong)NSMutableArray *vcs;


@end

@implementation BaseTabBarViewController

- (NSMutableArray *)items{
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}
- (NSMutableArray *)vcs{
    if (!_vcs) {
        _vcs = [[NSMutableArray alloc] init];
    }
    return _vcs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeViewController *Hvc = [[HomeViewController alloc]init];
    [self setChilderViewController:Hvc withTitle:@"首页" withImage:@"tab_homepage" withSelectImage:@"tab_homepage_pre"];
    
    OptimalWashViewController *Ovc = [[OptimalWashViewController alloc]init];
    [self setChilderViewController:Ovc withTitle:@"优洗" withImage:@"tab_youxi" withSelectImage:@"tab_youxi_pre"];
    
    WalletViewController *Wvc = [[WalletViewController alloc]init];
    [self setChilderViewController:Wvc withTitle:@"钱包" withImage:@"tab_wallet" withSelectImage:@"tab_wallet_pre"];
    
    MineViewController *Mvc = [[MineViewController alloc]init];
    [self setChilderViewController:Mvc withTitle:@"我的" withImage:@"tab_user" withSelectImage:@"tab_user_pre"];
    
    //设置item的tag值
    for (NSInteger i = 0; i<self.items.count; i++) {
        UITabBarItem *item = self.items[i];
        item.tag = 1000+i;
    }
}


- (void)setChilderViewController:(UIViewController *)vc  withTitle:(NSString *)str withImage:(NSString *)imageStr withSelectImage:(NSString *)selectImageStr{
    vc.tabBarItem.title = str;
    vc.tabBarItem.image = [UIImage imageNamed:imageStr];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectImageStr];
    [self.items addObject:vc.tabBarItem];
    [self.vcs addObject:vc];
    
    BaseNavViewController *nav = [[BaseNavViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
    
}

#pragma make tabbar点击事件
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(nonnull UITabBarItem *)item{
    //选中数字
    NSInteger number = item.tag - 1000;
    NLog(@"%ld",(long)number);
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
