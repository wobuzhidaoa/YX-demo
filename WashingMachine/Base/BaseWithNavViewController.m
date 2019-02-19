//
//  BaseWithNavViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/2.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "BaseWithNavViewController.h"

@interface BaseWithNavViewController ()

@end

@implementation BaseWithNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //导航左箭头
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"nav_leftArrow" highImage:nil target:self action:@selector(leftItemBarButton)];
}
- (void)leftItemBarButton{
    [self.navigationController popViewControllerAnimated:YES];
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
