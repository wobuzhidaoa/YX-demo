//
//  CollAddressDetailMoreView.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/8.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollAddressDetailMoreView;
@protocol CollAddressDetailMoreDelegate <NSObject>

- (void)selectCollAddressDetailMoreView:(CollAddressDetailMoreView *)view;

@end

@interface CollAddressDetailMoreView : UIView
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *machineStyleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UIImageView *chooseStyleImageView;

@property(nonatomic,weak)id<CollAddressDetailMoreDelegate> delegate;
@end
