//
//  PlaceHolderTextView.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/15.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
