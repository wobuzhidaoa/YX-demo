//
//  PayTextField.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/9.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "NoCopyTextField.h"

@implementation NoCopyTextField

/**
 * /禁止可被粘贴复制
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

@end
