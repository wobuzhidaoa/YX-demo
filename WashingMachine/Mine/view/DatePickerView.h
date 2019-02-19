//
//  DatePickerView.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/23.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

- (void)datePickerViewSureWithDate:(NSString *)date;

@end

@interface DatePickerView : UIView
@property(nonatomic,copy)NSString *selectDate;
@property(nonatomic,weak)id<DatePickerViewDelegate> delegate;

- (void)show;
- (void)dismiss;

@end
