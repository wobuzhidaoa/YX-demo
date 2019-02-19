//
//  BBScrollView.h
//  JMT
//
//  Created by bianruifeng on 15/10/20.
//  Copyright © 2015年 bianruifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author bianruifeng, 16-07-13 17:07:58
 *
 *  @brief PageControl 显示位置
 */
typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};
/**
 *  @author bianruifeng, 16-07-13 17:07:58
 *
 *  @brief 新闻标题显示位置
 */
typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};



@class AdScrollView;
//UITableViewDataSource,UITableViewDelegate
@protocol AdScrollViewDataSource

@required
// 返回有多少个幻灯片
- (NSInteger)adScrollView:(AdScrollView *)adScrollView numberOfRowsInSection:(NSInteger)index;

// 返回每行cell长什么样子
- (UIView *)adScrollView:(AdScrollView *)adScrollView cellForRowAtIndexPath:(NSUInteger )index;

@end

@protocol AdScrollViewDelegate <NSObject>

/**
 *  点击了哪张图片
 */
@optional
- (void)adClick:(NSInteger)count;
- (void)adScrollView:(AdScrollView *)adScrollView didSelectAtIndex:(NSInteger)index;

@end





/**
 *  @author bianruifeng, 16-07-13 17:07:58
 *
 *  @brief 广告轮播
 */
@interface AdScrollView : UIView
{
    
}
/**
 *  幻灯片图片的数组
 */
@property (nonatomic , copy) NSMutableArray *Views;

@property (assign,nonatomic,readwrite) UIPageControlShowStyle  PageControlShowStyle;
@property (assign,nonatomic,readwrite) AdTitleShowStyle  adTitleStyle;

@property (nonatomic, weak) id <AdScrollViewDelegate> delegate;
@property (nonatomic, weak) id <AdScrollViewDataSource> dataSource;

- (id)initWithTarget:(id<AdScrollViewDelegate,AdScrollViewDataSource>)delegate interval:(NSTimeInterval)interval style:(NSMutableArray *)ViewArrays;

/**
 *  设置是否开启自动滚动
 *
 */
-(void)setAutoScroll:(BOOL)isScroll;

- (void)startAnimation;
- (void)stopAnimation;

// 刷新tableView
- (void)reloadData;
@end






