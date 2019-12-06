//
//  UIScrollView+Zoom.h
//  HSYImageZoomToolsKit
//
//  Created by anmin on 2019/12/6.
//

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Zoom)

/**
 设置放缩的中心点位置

 @param center 放缩位置
 */
- (void)hsy_setZoomInRect:(CGPoint)center;

/**
 设置默认的最大和最小放缩比例
 */
- (void)hsy_setZoomScaleSection;

@end

NS_ASSUME_NONNULL_END
