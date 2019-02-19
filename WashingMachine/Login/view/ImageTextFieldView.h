//
//  ImageTextFaileView.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
@interface ImageTextFieldView : UIView

@property(nonatomic,strong)UIImageView *fImageView;
@property(nonatomic,strong)CustomTextField *fTextField;

- (instancetype)initWithFrame:(CGRect)frame WithImageStr:(NSString *)imageStr WithTextFieldPlaceHodler:(NSString *)placeHodler;

@end
