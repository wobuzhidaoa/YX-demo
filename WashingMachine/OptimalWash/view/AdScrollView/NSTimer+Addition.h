//
//  NSTimer+Addition.h
//  PagedScrollView
//
//  Created by 陈政 on 14-1-24.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)
/**
 *  @brief 暂停定时器
 */
- (void)pauseTimer;
/**
 *  @brief 恢复定时器
 */
- (void)resumeTimer;
/**
 *  @brief //恢复定时器
 *
 *  @param interval 恢复定时器后，过interval秒后，首次执行定时器。
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
