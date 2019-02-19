//
//  TopUpButton.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/4.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopUpButtonView;
@protocol TopUpButtonViewDelegete <NSObject>

- (void)changeView:(TopUpButtonView *)view;

@end

@interface TopUpButtonView : UIView
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UILabel *givingLabel;
@property(nonatomic,strong)UIImageView *selectImageView;

@property(nonatomic,weak)id<TopUpButtonViewDelegete> delegate;
@end
