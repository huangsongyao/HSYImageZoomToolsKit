//
//  UIImageView+ZoomScales.h
//  HSYImageZoomToolsKit
//
//  Created by anmin on 2019/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (ZoomScales)

/**
 设置图片放缩后的frame
 */
- (void)hsy_scaleCentryCGRect;

@end

NS_ASSUME_NONNULL_END
