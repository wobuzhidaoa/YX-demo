//
//  DatePickerView.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/23.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "DatePickerView.h"

#define dpHeight 256

@interface DatePickerView()
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIButton *cancleButton;
@property(nonatomic,strong)UIButton *sureButton;
@property(nonatomic,strong)UIDatePicker *datePicker;
@end

@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [YXColor whiteColor];
        
        self.topView = [[UIView alloc]init];
        [self addSubview:self.topView];
        self.topView.backgroundColor = [YXColor blueThrColor];
        
        self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancleButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
        [self.cancleButton addTarget:self action:@selector(cancleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.cancleButton];
        
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
        [self.sureButton addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.sureButton];
        
        self.datePicker = [[UIDatePicker alloc]init];
        self.datePicker.backgroundColor = [YXColor whiteColor];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self addSubview:self.datePicker];
        [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        NSDate *date = self.selectDate ? [self dateWithString:self.selectDate] : [NSDate date];
        [self.datePicker setDate:date];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //参考高度 216+40
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    self.cancleButton.frame = CGRectMake(0, 0, 80, 40);
    self.sureButton.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 80, 40);
    self.datePicker.frame = CGRectMake(0, 40, SCREEN_WIDTH, 216);
}

- (void)show{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:self];
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, dpHeight);
    
    [UIView animateWithDuration:.5 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - dpHeight, SCREEN_WIDTH, dpHeight);
    }];
}
- (void)dismiss{
    [UIView animateWithDuration:.5 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, dpHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark 日期转换
- (NSString *)stringWithDate:(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df stringFromDate:date];
}
- (NSDate *)dateWithString:(NSString *)str{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df dateFromString:str];
}

#pragma mark 事件处理
- (void)cancleButton:(id)sender{
    [self dismiss];
}
- (void)sureButton:(id)sender{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(datePickerViewSureWithDate:)]) {
        [self.delegate datePickerViewSureWithDate:self.selectDate];
    }
}
- (void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    self.selectDate = [self stringWithDate:control.date];
}
@end
