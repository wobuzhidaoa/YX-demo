//
//  ImageTextFaileView.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "ImageTextFieldView.h"

@implementation ImageTextFieldView

- (instancetype)initWithFrame:(CGRect)frame WithImageStr:(NSString *)imageStr WithTextFieldPlaceHodler:(NSString *)placeHodler{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [YXColor whiteColor];
        
        _fImageView = [[UIImageView alloc]init];
        _fImageView.image = [UIImage imageNamed:imageStr];
        [self addSubview:_fImageView];
        
        _fTextField = [[CustomTextField alloc]init];
        _fTextField.placeholder = placeHodler;
        [YXShortcut setTextFieldPlaceholder:_fTextField];
        [self addSubview:_fTextField];
        _fTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    //设置圆角 高度参考50
    
    //间距
    CGFloat spacing = 15;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.height/2.0;
    
    [self.fImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(spacing);
        make.top.equalTo(self.mas_top).offset(spacing);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    [self.fTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-spacing);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
}

@end
