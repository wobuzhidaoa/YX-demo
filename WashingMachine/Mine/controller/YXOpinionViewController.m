//
//  YXOpinionViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/15.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXOpinionViewController.h"
#import "PlaceHolderTextView.h"
#import "MLDPhotoManager.h"
@interface YXOpinionViewController ()<UITextViewDelegate>
{
    MLDPhotoManager *mldPhoto;//调用媒体库
}
@property(nonatomic,strong)PlaceHolderTextView *textView;
@property(nonatomic,strong)UIButton *photoButton;
@end

@implementation YXOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:nil highImage:nil target:self action:@selector(rightBarButtonClick) title:@"提交"];
    
    [self initView];
}
- (void)rightBarButtonClick{
    
}


#pragma mark 界面
- (void)initView{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, navHight, SCREEN_WIDTH, 276)];
    whiteView.backgroundColor = [YXColor whiteColor];
    [self.view addSubview:whiteView];
    
    
    self.textView = [[PlaceHolderTextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 144)];
    self.textView.delegate = self;
    self.textView.placeholder = @"请留下您的建议";
    [whiteView addSubview:self.textView];
    
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoButton.frame = CGRectMake(SIDESSPACING, CGRectGetMaxY(self.textView.frame)+SIDESSPACING, 108, 108);
    [self.photoButton setImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
    [self.photoButton addTarget:self action:@selector(photoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.photoButton];
}

- (void)photoButtonClick{
    if (!mldPhoto) {
        mldPhoto = [[MLDPhotoManager alloc]init];
    }
    [mldPhoto showPhotoManager:self.view
             withMaxImageCount:9
                      withType:1
               withCameraImage:^(UIImage *cameraImage) {
                   NLog(@"cameraImage");
               }
                withAlbumArray:^(NSArray *albumArray) {
                    NLog(@"cameraImage %ld",(unsigned long)albumArray.count);
                }];
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
