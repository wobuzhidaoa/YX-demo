//
//  CollAddressDetailMoreView.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/8.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "CollAddressDetailMoreView.h"

@implementation CollAddressDetailMoreView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YXColors(249, 250, 251, 1);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        
        self.iconImageView = [[UIImageView alloc]init];
        [self addSubview:self.iconImageView];
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = [YXColor grayColor];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeLabel];
        self.machineStyleLabel = [[UILabel alloc]init];
        self.machineStyleLabel.textColor = [YXColor blackColor];
        self.machineStyleLabel.font = ORDINARYFONT;
        [self addSubview:self.machineStyleLabel];
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.textColor = [YXColor grayColor];
        self.contentLabel.font = [UIFont systemFontOfSize:10];
        self.contentLabel.numberOfLines = 2;
        [self addSubview:self.contentLabel];
        self.moneyLabel = [[UILabel alloc]init];
        self.moneyLabel.textColor =[YXColor colorWithHexString:@"#ff3b30"];
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.moneyLabel];
        self.chooseStyleImageView = [[UIImageView alloc]init];
        [self addSubview:self.chooseStyleImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        //赋值
        self.iconImageView.image = [UIImage imageNamed:@"list_icon_standard"];
        self.timeLabel.text = @"35min";
        self.machineStyleLabel.text = @"标准";
        self.moneyLabel.text = @"￥3.00";
        self.contentLabel.text = @"大件衣物洗涤程序，可洗床单，被罩，窗帘等";
        self.chooseStyleImageView.image = [UIImage imageNamed:@"icon_plus"];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //参考高度72
    self.iconImageView.frame = CGRectMake(24, 12, 30, 30);
    self.timeLabel.frame = CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame)+8, 78, 12);
    self.machineStyleLabel.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame), self.iconImageView.y, 80, 20);
    self.contentLabel.frame = CGRectMake(self.machineStyleLabel.x, CGRectGetMaxY(self.machineStyleLabel.frame)+5, self.width - 24 - CGRectGetMaxX(self.timeLabel.frame) - 12, 30);
    self.moneyLabel.frame = CGRectMake(CGRectGetMaxX(self.machineStyleLabel.frame), self.machineStyleLabel.y, self.width - CGRectGetMaxX(self.machineStyleLabel.frame) - 24, self.machineStyleLabel.height);
    self.chooseStyleImageView.frame = CGRectMake(self.width - 24 - 12, self.height - 12 - 12, 12, 12);
}

- (void)tap:(UITapGestureRecognizer *)tap{
    CollAddressDetailMoreView *view = (CollAddressDetailMoreView *)[tap view];
    if ([self.delegate respondsToSelector:@selector(selectCollAddressDetailMoreView:)]) {
        [self.delegate selectCollAddressDetailMoreView:view];
    }
}
@end
