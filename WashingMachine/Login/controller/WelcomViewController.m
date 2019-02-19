//
//  WelcomViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/3.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "WelcomViewController.h"
#import "LoginViewController.h"
#import "BaseTabBarViewController.h"

#define pageIndex 3

@interface WelcomViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageController;
@end

@implementation WelcomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*pageIndex, SCREEN_HEIGHT);
    [self.view addSubview:self.scrollView];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    if (SCREEN_HEIGHT == 568)
    {
        for (int index = 1; index < pageIndex+1; index ++) {
            NSString *imageName = [NSString stringWithFormat:@"welcome_page_5s_%d.png",index];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * (index -1), 0 , self.view.bounds.size.width, self.view.bounds.size.height)];
            imageView.image = [UIImage imageNamed:imageName];
            [self.scrollView addSubview:imageView];
        }
    }else if (SCREEN_HEIGHT == 667)
    {
        for (int index = 1; index < pageIndex+1; index ++) {
            NSString *imageName = [NSString stringWithFormat:@"welcome_page_6s_%d.png",index];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * (index -1), 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            imageView.image = [UIImage imageNamed:imageName];
            [self.scrollView addSubview:imageView];
        }
    }else if (SCREEN_HEIGHT == 736)
    {
        for (int index = 1; index < pageIndex+1; index ++) {
            NSString *imageName = [NSString stringWithFormat:@"welcome_page_6sp_%d.png",index];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * (index -1), 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            imageView.image = [UIImage imageNamed:imageName];
            [self.scrollView addSubview:imageView];
        }
    }
    else{
        for (int index = 1; index < pageIndex+1; index ++) {
            NSString *imageName = [NSString stringWithFormat:@"welcome_page_6sp_%d.png",index];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * (index -1), 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            imageView.image = [UIImage imageNamed:imageName];
            [self.scrollView addSubview:imageView];
        }
    }
    
    
    //添加按钮
    //间距
    CGFloat footSpacing = 20*SCREEN_HEIGHT/568;
    _pageController = [[UIPageControl alloc]initWithFrame:CGRectMake(50, SCREEN_HEIGHT-footSpacing-30, SCREEN_WIDTH-100, 30)];
    _pageController.numberOfPages = pageIndex;
    _pageController.pageIndicatorTintColor=[YXColor grayColor];
    _pageController.currentPageIndicatorTintColor=[YXColor blueFirColor];
    _pageController.tag = 10001;
    [_pageController addTarget:self action:@selector(onPageControl:) forControlEvents:UIControlEventValueChanged];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
    CGFloat height = 50;
    CGFloat width = 140;
    button.frame = CGRectMake(SCREEN_WIDTH*(pageIndex - 1)+(SCREEN_WIDTH-width)/2, _pageController.y-footSpacing-height ,width, height);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.height/2.0;
    [button setBackgroundColor:[YXColor blueFirColor]];
    [button addTarget:self action:@selector(intoMainView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:_pageController];
    [self.scrollView addSubview:button];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollView.contentOffset.x > 0) {
        self.scrollView.bounces = YES;
    }else{
        self.scrollView.bounces = NO;
    }
    CGFloat page = scrollView.contentOffset.x/scrollView.bounds.size.width;
    [_pageController setCurrentPage:page];
    if (page > 2.05) {
        [self toMainVC];
    }
}
//通过page来切换视图
- (void)onPageControl:(UIPageControl *)sender
{
    //    在这里拿到page改变的值
    NSInteger pageValue = sender.currentPage;
    
    //    在这里是设置了一个坐标值，用当前page的值乘以每个页面的宽度作为点击page页面切换的大小
    CGPoint offSetPoint = CGPointMake(pageValue * SCREEN_WIDTH, 0);
    
    //  将设置的坐标值传给scrollView，用于显示切换后的页面
    [self.scrollView setContentOffset:offSetPoint animated:YES];
    
}
//点击体验
- (void)intoMainView:(UIButton *)sender{
    [self toMainVC];
}
//切换控制器
- (void)toMainVC{
    NSDictionary *userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    if (userInfo) {//是否登录
        BaseTabBarViewController *vc = [[BaseTabBarViewController alloc]init];
        self.view.window.rootViewController = vc;
    }
    else{
        LoginViewController *vc = [[LoginViewController alloc]init];
        self.view.window.rootViewController = vc;
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
