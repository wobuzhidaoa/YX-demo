//
//  TopUpButton.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/4.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "TopUpButtonView.h"

@implementation TopUpButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [YXColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        
        self.numberLabel = [[UILabel alloc]init];
        self.numberLabel.textColor = [YXColor colorWithHexString:@"#2196f3"];
        self.numberLabel.font = [UIFont systemFontOfSize:18];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numberLabel];
        
        self.givingLabel = [[UILabel alloc]init];
        self.givingLabel.textColor = [YXColor colorWithHexString:@"#2196f3"];
        self.givingLabel.font = [UIFont systemFontOfSize:10];
        self.givingLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.givingLabel];
        
        self.selectImageView = [[UIImageView alloc]init];
        [self addSubview:self.selectImageView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //参考高度 60
    self.numberLabel.frame = self.bounds;
    self.givingLabel.frame = CGRectMake(0, self.height - 20, self.width, 20);
    self.selectImageView.frame = CGRectMake(self.width-15, 0, 15, 15);
}

- (void)tap:(UITapGestureRecognizer *)tap{
    TopUpButtonView *view = (TopUpButtonView *)[tap view];
    
    if ([self.delegate respondsToSelector:@selector(changeView:)]) {
        [self.delegate changeView:view];
    }
}

@end
