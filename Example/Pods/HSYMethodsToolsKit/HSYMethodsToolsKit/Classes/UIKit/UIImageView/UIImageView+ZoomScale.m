//
//  UIImageView+ZoomScale.m
//  HSYMethodsToolsKit
//
//  Created by anmin on 2019/9/29.
//

#import "UIImageView+ZoomScale.h"
#import "UIView+Frame.h"

@implementation UIImageView (ZoomScale)

- (void)hsy_zoomScaleWidths:(CGFloat)widths scales:(CGSize)scales
{
    CGFloat heights = widths * scales.height / scales.width;
    self.height = ceil(heights);
}

- (void)hsy_zoomScaleHeights:(CGFloat)heights scales:(CGSize)scales
{
    CGFloat widths = heights * scales.width / scales.height;
    self.width = ceil(widths);
}


@end
