//
//  BBScrollView.m
//  JMT
//
//  Created by bianruifeng on 15/10/20.
//  Copyright © 2015年 bianruifeng. All rights reserved.
//

#import "AdScrollView.h"

#import "NSTimer+Addition.h"
#import "UPage.h"
#import <Masonry.h>

@interface AdScrollView ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIView * contenView;
@property(nonatomic,strong)UIPageControl * page;

@property(nonatomic,assign)NSInteger * num;

@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;

/**
 *  @brief 幻灯片的定时器
 */
@property (nonatomic , strong) NSTimer *animationTimer;
/**
 *  幻灯片切换的时间间隔
 */
@property (nonatomic , assign) NSTimeInterval animationInterval;
/**
 *  存储显示参数newsModel
 */
@property (nonatomic , strong) NSMutableArray *parameters;
@property (nonatomic , strong) UPage *pageControl;
@property BOOL TO;
@end

@implementation AdScrollView

- (void)startAnimation
{
    if (self.Views.count>1) {
        [self.animationTimer resumeTimerAfterTimeInterval:2];
    }
    
}

- (void)stopAnimation
{
    [self.animationTimer pauseTimer];
}


- (id)initWithTarget:(id<AdScrollViewDelegate,AdScrollViewDataSource>)delegate interval:(NSTimeInterval)interval style:(NSMutableArray *)ViewArrays
{
    self = [super init];
    if (self)
    {
        
        self.delegate = delegate;
        self.dataSource = delegate;
        self.animationInterval=interval;
        
        //======================================================================
        [self createScrollView];
        [self createContenView];
        
        [self createPageControl];

        [self createAnimationTimer];
        
    }
    
    return self;
}
- (void)createAnimationTimer
{
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval
                                                         target:self
                                                       selector:@selector(animationTimerDidFired:)
                                                       userInfo:nil
                                                        repeats:YES];
    [self.animationTimer pauseTimer];
}
- (void)createPageControl
{
    self.pageControl = [[UPage alloc] init];
    [self addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@30);
    }];
    
    /**
     *  导航指示器
     */
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.currentPage = 0;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.Alignment=PageControlAlignmentCenter;
    self.pageControl.pageIndicatorTintColor=[YXColor colorWithHexString:@"#daf0fc"];
    self.pageControl.currentPageIndicatorTintColor=[YXColor colorWithHexString:@"#47b6f1"];
    self.pageControl.hidesForSinglePage=YES;//是否显示指示器。
    [self addSubview:self.scrollView];
    [self bringSubviewToFront:self.pageControl];
    self.currentPageIndex = 0;

}

-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;


    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)createContenView
{
    self.contenView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contenView];
    self.contenView.backgroundColor = [UIColor whiteColor];
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}


-(void)loadContentViews
{
    //一张图片处理
    self.scrollView.frame = self.frame;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width, self.scrollView.height)];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    for (UIView *subv in self.Views){
        subv.frame = self.scrollView.frame;
        [self.scrollView addSubview:subv];
    }
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    [self.contenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];

    UIView *lastView = nil;
    for (UIView *subv in self.contentViews)
    {
       
        [self.contenView addSubview:subv];
        
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView ? lastView.mas_right : self.contenView.mas_left);
            make.bottom.equalTo(@0);
            //            make.width.equalTo(self.contenView.mas_width);
            make.width.equalTo(self.scrollView.mas_width);
            make.height.equalTo(self.contenView.mas_height);
        }];
        
        lastView = subv;
    }
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];

    _scrollView.contentSize = CGSizeMake(_scrollView.width*self.contentViews.count, _scrollView.height);
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.Views.count && previousPageIndex < self.Views.count && _currentPageIndex < self.Views.count && rearPageIndex < self.Views.count)
    {
        [self.contentViews addObject:self.Views[previousPageIndex]];
        [self.contentViews addObject:self.Views[_currentPageIndex]];
        [self.contentViews addObject:self.Views[rearPageIndex]];
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1)
    {
        return self.totalPageCount - 1;
    }
    else if (currentPageIndex == self.totalPageCount)
    {
        return 0;
    }
    else
    {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:3];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    
        if (_totalPageCount == 1)
        {
            [self loadContentViews];
        }else{
            [self configContentViews];
        }
        
        
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];

        if (_totalPageCount == 1)
        {
            [self loadContentViews];
        }else{
            [self configContentViews];
        }
    }
    
    if (_TO==YES) {
        self.pageControl.currentPage = self.currentPageIndex%2;
    }else{
        self.pageControl.currentPage = self.currentPageIndex;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}
#pragma mark -
#pragma mark - 响应事件
/**
 *   scrollView 定时滑动
 */
- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (!self.delegate)
    {//如果没有代理方法，直接返回。

        return;
    }else
    {
        if ([self.delegate respondsToSelector:@selector(adScrollView:didSelectAtIndex:)])
        {
            [self.delegate adScrollView:self didSelectAtIndex:self.pageControl.currentPage];
        }
    }
}
-(NSMutableArray *)Views
{
    if (!_Views) {
        _Views=[NSMutableArray arrayWithCapacity:2];
    }
    return _Views;
}


//图片已经预先改成ad0,ad1这种格式
-(void)loadImageNum:(NSInteger)count
{

    [self.contenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];


    
    
    UIImageView *lastView = nil;
    for ( int i = 1 ; i < 3 ; i ++)
    {
        UIImageView * subv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ad%d",i]]];
        subv.backgroundColor=[UIColor colorWithHue:( arc4random() % 256 / 256.0 )
                                        saturation:( arc4random() % 128 / 256.0 ) + 0.5
                                        brightness:( arc4random() % 128 / 256.0 ) + 0.5
                                             alpha:1];
        [self.contenView addSubview:subv];

        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView ? lastView.mas_right : @0);
            make.bottom.equalTo(@0);
            make.width.equalTo(self.scrollView.mas_width);
            make.height.equalTo(self.contenView.mas_width);
        }];
        
        lastView = subv;
    }
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
    
//     [self.contenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)createPage:(NSInteger)count
{
    self.page = [[UIPageControl alloc] init];
    self.page.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.page.currentPage = 0;
    self.page.numberOfPages = count;
    self.page.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:self.page];
    [self.page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width/2 , 30));
    }];
    
}



-(void)setAutoScroll:(BOOL)isScroll
{
    int num = isScroll?1:0;
    switch (num)
    {
            case YES:
        {
            [self.animationTimer resumeTimer];
        }
            break;
            
        default:
        {
            [self.animationTimer pauseTimer];
        }
            break;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)tap:(UITapGestureRecognizer * )tap
{
    [self.delegate adClick:self.page.currentPage];
}
/**
 *  @author bianruifeng, 16-07-13 17:07:08
 *
 *  @brief 刷新广告页
 */
-(void)reloadData
{
    [self.animationTimer pauseTimer];
    self.currentPageIndex = 0;
    self.pageControl.currentPage = 0;
    
    [self.Views removeAllObjects];
    [self.contenView removeAllSubviews];
    
    NSInteger rows = 0;
    if ([self.delegate respondsToSelector:@selector(adScrollView:numberOfRowsInSection:)]) {
        
        rows = [self.dataSource adScrollView:self numberOfRowsInSection:0];
        
    }else
    {
         NSAssert(NO, @"ERROR:实现代理方法 (adScrollView:numberOfRowsInSection:) %s", __PRETTY_FUNCTION__);
    }
    UIView * cell;
    if ([self.delegate respondsToSelector:@selector(adScrollView:cellForRowAtIndexPath:)]) {
        cell = [self.dataSource adScrollView:self cellForRowAtIndexPath:0];
    }
    
    _TO = NO;
    if (rows==1) {
        //一张图片不需要定时器轮播图片
        [self.animationTimer invalidate];
        self.animationTimer = nil;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        tapGesture.numberOfTouchesRequired = 1; //手指数
        tapGesture.numberOfTapsRequired = 1; //tap次数
        [cell addGestureRecognizer:tapGesture];
        [self.Views addObject:cell];
    }
    
    
    
    else if (rows==2) {
        _TO=YES;
        self.pageControl.numberOfPages = 2;
        
        
        for (int i = 0; i < 4; ++i)
        {
            if ([self.delegate respondsToSelector:@selector(adScrollView:cellForRowAtIndexPath:)]) {
                cell = [self.dataSource adScrollView:self cellForRowAtIndexPath:i%2];
            }
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
            tapGesture.numberOfTouchesRequired = 1; //手指数
            tapGesture.numberOfTapsRequired = 1; //tap次数
            [cell addGestureRecognizer:tapGesture];
            [self.Views addObject:cell];
            
        }
    }
    else{
        self.pageControl.numberOfPages = [self.Views count];
        
        for (int i = 0; i < rows; ++i)
        {
            
            if ([self.delegate respondsToSelector:@selector(adScrollView:cellForRowAtIndexPath:)]) {
                cell = [self.dataSource adScrollView:self cellForRowAtIndexPath:i];
                
            }
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
            tapGesture.numberOfTouchesRequired = 1; //手指数
            tapGesture.numberOfTapsRequired = 1; //tap次数
            [cell addGestureRecognizer:tapGesture];
            [self.Views addObject:cell];
        
        }
        
    }
    self.pageControl.numberOfPages = _TO?2:[self.Views count];
    
    
    _totalPageCount = [self.Views count];
    
    if (_totalPageCount == 1)
    {
        [self loadContentViews];
    }else
    {
        if (self.animationInterval > 0.0)
        {
            [self configContentViews];
            [self.animationTimer resumeTimerAfterTimeInterval:self.animationInterval];
        }
    }
    
}
//- (void) scrollViewDidScroll:(UIScrollView *)sender {
//    // 得到每页宽度
//    CGFloat pageWidth = sender.frame.size.width;
//    // 根据当前的x坐标和页宽度计算出当前页数
//    int currentPage = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    self.page.currentPage = currentPage;
//}


@end

