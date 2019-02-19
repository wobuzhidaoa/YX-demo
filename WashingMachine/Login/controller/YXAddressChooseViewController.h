//
//  RecommendCodeViewController.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/1.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "BaseWithNavViewController.h"

typedef void(^AddressChooseBlock)(NSDictionary *dic);

@interface YXAddressChooseViewController : BaseWithNavViewController

@property (nonatomic,strong)AddressChooseBlock block;

@end
