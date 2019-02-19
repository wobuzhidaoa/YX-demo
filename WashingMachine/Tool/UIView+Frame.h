//
//  UIView+Frame.h
//  Laiwang
//
//  Created by 香象 on 24/12/13.
//  Copyright (c) 2013 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
- (CGFloat)left;

- (void)setLeft:(CGFloat)x;

- (CGFloat)top;

- (void)setTop:(CGFloat)y;

- (CGFloat)right;

- (void)setRight:(CGFloat)right;

- (CGFloat)bottom;

- (void)setBottom:(CGFloat)bottom;

- (CGFloat)centerX;

- (void)setCenterX:(CGFloat)centerX;

- (CGFloat)centerY;

- (void)setCenterY:(CGFloat)centerY;

- (CGFloat)width;

- (void)setWidth:(CGFloat)width;

- (CGFloat)height;

- (void)setHeight:(CGFloat)height;

- (CGPoint)origin;

- (void)setOrigin:(CGPoint)origin;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (void)removeAllSubviews;

@end
