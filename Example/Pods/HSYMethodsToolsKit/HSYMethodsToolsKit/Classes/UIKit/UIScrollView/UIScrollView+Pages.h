//
//  UIScrollView+Pages.h
//  HSYMethodsToolsKit
//
//  Created by anmin on 2019/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Pages)

typedef NS_ENUM(NSUInteger, kHSYCocoaKitScrollDirection) {
    
    kHSYCocoaKitScrollDirectionToUp             = 47,   //向上滑动
    kHSYCocoaKitScrollDirectionToDown,                  //向下滑动
    kHSYCocoaKitScrollDirectionToLeft,                  //向左滑动
    kHSYCocoaKitScrollDirectionToRight,                 //向右滑动
};

- (NSInteger)hsy_pages;                                         //获取scrollView的总页面数
- (NSInteger)hsy_currentPage;                                   //获取scrollView的当前的页码
- (CGFloat)hsy_scrollPercent;                                   //获取scrollView的百分比

- (CGFloat)hsy_pagesY;                                          //获取scrollView的页面的y点坐标
- (CGFloat)hsy_pagesX;                                          //获取scrollView的页面的x点坐标

- (CGFloat)hsy_currentPageY;                                    //获取scrollView的当前页面的y点坐标
- (CGFloat)hsy_currentPageX;                                    //获取scrollView的当前页面的x点坐标

- (CGFloat)hsy_contentSizeWidth;                                //获取scrollView的滚动宽度
- (CGFloat)hsy_contentSizeHeight;                               //获取scrollView的滚动高度

- (NSArray<UIView *> *)hsy_subViews:(Class)classes;             //返回addSubview在UIScrollView对象上归属于同类的对象的集合

/**
 上下方向翻页，无动画
 
 @param page 设置翻页的页码
 */
- (void)hsy_setYPage:(NSInteger)page;;

/**
 左右方向翻页，无动画
 
 @param page 设置翻页的页码
 */
- (void)hsy_setXPage:(NSInteger)page;

/**
 上下方向翻页
 
 @param page 设置翻页的页码
 @param animated 是否执行动画
 */
- (void)hsy_setYPage:(NSInteger)page animated:(BOOL)animated;

/**
 左右方向翻页
 
 @param page 设置翻页的页码
 @param animated 是否执行动画
 */
- (void)hsy_setXPage:(NSInteger)page animated:(BOOL)animated;

/**
 滚动方向，水平方向
 
 @return 返回水平方向的左或者右-----x轴
 */
- (kHSYCocoaKitScrollDirection)hsy_scrollHorizontalDirection;

/**
 滚动方向，垂直方向
 
 @return 返回垂直方向的上或者下-----y轴
 */
- (kHSYCocoaKitScrollDirection)hsy_scrollVerticalDirection;


@end

NS_ASSUME_NONNULL_END
