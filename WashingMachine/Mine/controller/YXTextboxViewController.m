//
//  YXTextboxViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/23.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXTextboxViewController.h"
#import "PlaceHolderTextView.h"
@interface YXTextboxViewController ()<UITextViewDelegate>
{
    NSString *lastTextContent;
}
@property(nonatomic,strong)PlaceHolderTextView *textView;
@end

@implementation YXTextboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:nil highImage:nil target:self action:@selector(rightBtnAcion:) title:@"确定"];
    
    [self initTextView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.textView becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [self.textView resignFirstResponder];
}
- (void)rightBtnAcion:(id)sender{
    YXTextboxViewBlock block = self.block;
    if (block && self.textView.text != nil) {
        block(self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTextView{
    CGFloat textFiledH = self.isMoreRow ? 120 : 30;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, navHight + 1, SCREEN_WIDTH, textFiledH + 20)];
    backView.backgroundColor = YXColors(189, 189, 195,1);
    [self.view addSubview:backView];
    self.textView = [[PlaceHolderTextView alloc]initWithFrame:CGRectMake(10, navHight + 11, SCREEN_WIDTH - 20, textFiledH)];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = self.textView.height/8.0;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.placeholder = @"输入内容";
    self.textView.delegate = self;
    self.textView.font = ORDINARYFONT;
    [self.view addSubview:self.textView];
    self.textView.keyboardType = self.keyType;
}


#pragma mark textview监听
- (void)textViewDidChange:(NSNotification *)note{
    //获取文本框内容的字节数
    NSInteger length = self.textView.text.length;
    //设置不能超过32个字节，因为不能有半个汉字，所以以字符串长度为单位。
    NSInteger number = [self numberWithType:self.type];
    if (length > number)
    {
        //超出字节数，还是原来的内容
        self.textView.text = lastTextContent;
    }
    else
    {
        lastTextContent = self.textView.text;
    }
}
- (NSInteger)numberWithType:(NSInteger)type{
    NSInteger number = 0;
    if (type == 0) {
        number = 20;
    }else{
        number = 20;
    }
    return number;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.keyType == UIKeyboardTypePhonePad || self.keyType == UIKeyboardTypeNumberPad) {
        if ([text isEqualToString:@"\n"]||[text isEqualToString:@""]) {
            //按下return
            return YES;
        }
        
        NSString * toBeStrings = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSUInteger nDotLoc = [textView.text rangeOfString:@"."].location;
        if (NSNotFound != nDotLoc && range.location > nDotLoc +2) {//小数点后面两位
            return NO;
        }
        NSArray *arr = [textView.text componentsSeparatedByString:@"."];
        if (arr.count > 2) {
            return NO;
        }
        if (toBeStrings.length>12) {
            textView.text = [toBeStrings substringWithRange:NSMakeRange(0, 12)];
            return NO;
        }
        else{
            return YES;
        }
        return YES;
    }
    
    return YES;
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
