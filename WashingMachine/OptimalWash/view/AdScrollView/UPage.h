//
//  SMPageControl.h
//  SMPageControl
//
//  Created by Jerry Jones on 10/13/12.
//  Copyright (c) 2012 Spaceman Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PageControlAlignment) {
	PageControlAlignmentLeft = 1,
	PageControlAlignmentCenter,
	PageControlAlignmentRight
};

typedef NS_ENUM(NSUInteger, PageControlVerticalAlignment) {
	PageControlVerticalAlignmentTop = 1,
	PageControlVerticalAlignmentMiddle,
	PageControlVerticalAlignmentBottom
};

@interface UPage : UIControl

@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGFloat indicatorMargin							UI_APPEARANCE_SELECTOR; // deafult is 10
@property (nonatomic) CGFloat indicatorDiameter							UI_APPEARANCE_SELECTOR; // deafult is 6
@property (nonatomic) PageControlAlignment Alignment					UI_APPEARANCE_SELECTOR; // deafult is Center
@property (nonatomic) PageControlVerticalAlignment verticalAlignment	UI_APPEARANCE_SELECTOR;	// deafult is Middle
/**设置所有按钮在普通状态的图片*/
@property (nonatomic, strong) UIImage *pageIndicatorImage				UI_APPEARANCE_SELECTOR;
/**普通状态下颜色*/
@property (nonatomic, strong) UIColor *pageIndicatorTintColor			UI_APPEARANCE_SELECTOR; // ignored if pageIndicatorImage is set
/**设置所有按钮在高亮状态下图片*/
@property (nonatomic, strong) UIImage *currentPageIndicatorImage		UI_APPEARANCE_SELECTOR;
/**高亮状态下颜色*/
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor	UI_APPEARANCE_SELECTOR;
/**如果指示器只有一页,则隐藏(YES)，默认值:NO*/
@property (nonatomic ,assign) BOOL hidesForSinglePage;
@property (nonatomic ,assign) BOOL defersCurrentPageDisplay;	// if set, clicking to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO

- (void)updateCurrentPageDisplay;						// update page display to match the currentPage. ignored if defersCurrentPageDisplay is NO. setting the page value directly will update immediately

/**获得第pageindex个的CGRect*/
- (CGRect)rectForPageIndicator:(NSInteger)pageIndex;
/**获得第pageindex个的CGsize*/
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;
/**设置第pageindex个未选中状态的图片*/
- (void)setImage:(UIImage *)image forPage:(NSInteger)pageIndex;
/**设置第pageindex个高亮状态的图片*/
- (void)setCurrentImage:(UIImage *)image forPage:(NSInteger)pageIndex;
/**获得第pageIndex个点，的普通状态下图片*/
- (UIImage *)imageForPage:(NSInteger)pageIndex;
/**获得第pageIndex个点，的高亮状态下图片*/
- (UIImage *)currentImageForPage:(NSInteger)pageIndex;

- (void)updatePageNumberForScrollView:(UIScrollView *)scrollView;

@end 
