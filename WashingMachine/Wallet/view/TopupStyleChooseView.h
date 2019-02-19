//
//  TopupStyleChooseView.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/4.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopupStyleChooseDelegate <NSObject>

- (void)cancleChoose;

- (void)sureChooseStyleRow:(NSInteger)row component:(NSInteger)component;

@end

@interface TopupStyleChooseView : UIView
@property(nonatomic,weak)id<TopupStyleChooseDelegate> delegate;

@property(nonatomic,strong)NSMutableArray *contentArray;

@end
