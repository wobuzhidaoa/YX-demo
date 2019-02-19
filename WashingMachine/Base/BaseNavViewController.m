//
//  BaseNavViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()<UINavigationControllerDelegate>

@property (strong,nonatomic) id  popDelegate;

@end

@implementation BaseNavViewController

/**
 *  一些一次性的操作
 */
+ (void)initialize
{
    // 设置导航条的整个字体
    UINavigationBar *nav = [UINavigationBar appearance];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [YXColor whiteColor];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [nav setTitleTextAttributes:attr];
    
    // 设置导航条的item的文字
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 普通状态的文字
    NSMutableDictionary *attrNomal = [NSMutableDictionary dictionary];
    attrNomal[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    attrNomal[NSForegroundColorAttributeName] = [YXColor whiteColor];
    [item setTitleTextAttributes:attrNomal forState:UIControlStateNormal];
    
    //修改颜色偏差问题
    nav.barTintColor = [YXColor blueFirColor];
    nav.translucent = NO;
    [nav setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //支持侧滑
    self.delegate = self;
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    
    //获取导航栏分割线
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    _navLine = backgroundView.subviews.firstObject;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}



/**
 *  重写push方法的目的 : 拦截所有push进来的子控制器
 *
 *  @param viewController 刚刚push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.extendedLayoutIncludesOpaqueBars = YES;//解决导航设置透明度之后界面布局问题（view下移）
    
    if (self.childViewControllers.count > 0) { // 如果viewController不是最早push进来的子控制器
        // 隐藏底部的工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 所有设置搞定后, 再push控制器
    [super pushViewController:viewController animated:animated];
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}


#pragma mark --UINavigationControllerDelegate 代理方法

/**
 *  在这个方法中判断是否是根控制器
 */
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 每次push的时候都放到了栈顶。所以第0个元素肯定是栈底的更控制器
    if(viewController == self.viewControllers[0]){// 是根控制器
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }else
    {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
    
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(viewController == self.viewControllers[0]){// 是根控制器
        [self.tabBarController.tabBar setHidden:NO];
    }else
    {
        [self.tabBarController.tabBar setHidden:YES];
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
