//
//  HSYImageZoomView.h
//  HSYImageZoomToolsKit
//
//  Created by anmin on 2019/12/3.
//

#import <UIKit/UIKit.h>
#import "HSYImageZoomArgument.h"  

NS_ASSUME_NONNULL_BEGIN

@interface HSYImageZoomView : UIView

//左上角的翻页当前页码
@property (nonatomic, strong, readonly) UILabel *pagesLabel;

/**
 初始化

 @param zoomArguments 一组图片集合的入参模型
 @return HSYImageZoomView
 */
- (instancetype)initWithImages:(HSYImageZoomArgument *)zoomArguments;

/**
 展示动画
 */
- (void)hsy_showTools;

/**
 移除动画
 */
- (void)hsy_removeTools;

@end

@interface HSYImageZoomView (Tools)

/**
 工具方法

 @param zoomArguments 一组图片UIImageView集合参数
 @return HSYImageZoomView
 */
+ (HSYImageZoomView *)hsy_imageZoom:(HSYImageZoomArgument *)zoomArguments;

@end

NS_ASSUME_NONNULL_END
