//
//  NSTimer+Addition.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-24.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)
//暂停定时器
-(void)pauseTimer
{
    if (![self isValid])
    {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}

//恢复定时器
-(void)resumeTimer
{
    if (![self isValid])
    {
        return ;
    }
    [self setFireDate:[NSDate distantPast]];
    //同[self setFireDate:[NSDate date]];
}
//恢复定时器后，掉用这个方法到首次执行定时器的时间间隔
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{    
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
