//
//  RecommendCodeViewController.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/2.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavViewController.h"
typedef void(^RecommendCodeBlock)(NSString *code);

@interface YXRecommendCodeViewController : BaseWithNavViewController

@property(nonatomic,strong)RecommendCodeBlock block;

@end
