//
//  RecommendCodeViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/2.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXRecommendCodeViewController.h"
#import "CustomTextField.h"
@interface YXRecommendCodeViewController ()
@property (nonatomic,strong)CustomTextField *textField;
@end

@implementation YXRecommendCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐码";
    //导航右按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:nil highImage:nil target:self action:@selector(rightBarButton:) title:@"确定"];
    
    
    [self initView];
}
- (void)initView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + navHight, SCREEN_WIDTH, 40)];
    view.backgroundColor = [YXColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, view.height)];
    titLabel.textColor = [YXColor blackColor];
    titLabel.font = ORDINARYFONT;
    titLabel.text = @"推荐码";
    [view addSubview:titLabel];
    
    self.textField = [[CustomTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titLabel.frame)+10, 0, SCREEN_WIDTH-CGRectGetMaxX(titLabel.frame)-10, view.height)];
    self.textField.placeholder = @"请输入";
    self.textField.keyboardType = UIKeyboardTypePhonePad;
    [YXShortcut setTextFieldPlaceholder:self.textField];
    [view addSubview:self.textField];
}



#pragma mark 点击确定
- (void)rightBarButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    RecommendCodeBlock block = self.block;
    if (block) {
        block(self.textField.text);
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
