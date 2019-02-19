//
//  TopupStyleChooseView.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/4.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "TopupStyleChooseView.h"

@interface TopupStyleChooseView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,strong)UIButton *cancleButton;
@property(nonatomic,strong)UIButton *sureButton;
@property(nonatomic,strong)UIView *line;

@property(nonatomic,assign)NSInteger row;
@property(nonatomic,assign)NSInteger component;

@end

@implementation TopupStyleChooseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [YXColor whiteColor];
        
        self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancleButton addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancleButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.cancleButton];
        
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureButton setTitleColor:[YXColor blueColor] forState:UIControlStateNormal];
        [self addSubview:self.sureButton];
        
        self.line = [[UIView alloc]init];
        self.line.backgroundColor = [YXColor lineColor];
        [self addSubview:self.line];
        
        self.pickView = [[UIPickerView alloc]init];
        self.pickView.delegate = self;
        [self addSubview:self.pickView];
        self.pickView.showsSelectionIndicator = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //参考高度140
    
    self.cancleButton.frame = CGRectMake(0, 0, 80, 40);
    self.sureButton.frame = CGRectMake(SCREEN_WIDTH-80, 0, 80, 40);
    self.line.frame = CGRectMake(0, 40, SCREEN_WIDTH, 0.5);
    self.pickView.frame = CGRectMake(0, CGRectGetMaxY(self.cancleButton.frame), SCREEN_WIDTH, 100);
}

//取消
- (void)cancleButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(cancleChoose)]) {
        [self.delegate cancleChoose];
    }
}
//确认
- (void)sureButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(sureChooseStyleRow:component:)]) {
        [self.delegate sureChooseStyleRow:self.row component:self.component];
    }
}

#pragma mark pickview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.contentArray.count;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.row = row;
    self.component = component;
}


@end
