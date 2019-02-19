//
//  MYKeyChainTool.h
//  kuaixiao
//
//  Created by 孙瑞中 on 2017/4/17.
//  Copyright © 2017年 lxh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYKeyChainTool : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
@end
