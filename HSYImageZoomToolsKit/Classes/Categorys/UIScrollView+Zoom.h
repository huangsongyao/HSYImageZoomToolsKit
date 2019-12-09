//
//  UIScrollView+Zoom.h
//  HSYImageZoomToolsKit
//
//  Created by anmin on 2019/12/6.
//

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Zoom)

//内部记录放缩状态
@property (nonatomic, strong) NSNumber *hsy_zoomInStatus;

/**
 双击手势所执行的放缩动作

 @param center 中心点位置
 */
- (void)hsy_setZoomRect:(CGPoint)center;

/**
 缩小为原来的尺寸

 @param center 中心点位置
 */
- (void)hsy_setZoomOutRect:(CGPoint)center;

/**
 设置默认的最大和最小放缩比例
 */
- (void)hsy_setZoomScaleSection;

@end

NS_ASSUME_NONNULL_END
