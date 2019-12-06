//
//  UIScrollView+Zoom.m
//  HSYImageZoomToolsKit
//
//  Created by anmin on 2019/12/6.
//

#import "UIScrollView+Zoom.h"
#import <HSYMethodsToolsKit/UIView+Frame.h>

@implementation UIScrollView (Zoom)

- (CGRect)hsy_zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    CGFloat widths = self.width / scale;
    CGFloat heights = self.height / scale;
    CGFloat x = center.x - (widths / 2.0);
    CGFloat y = center.y - (heights / 2.0);
    CGRect zoomRect = CGRectMake(x, y, widths, heights);
    return zoomRect;
}

- (void)hsy_setZoomInRect:(CGPoint)center
{
    CGFloat newScale = self.zoomScale * self.class.maxZoomScales;
    [self setZoomScale:newScale animated:YES];
//    CGRect zoomCGRect = [self hsy_zoomRectForScale:newScale withCenter:center];
//    [self zoomToRect:zoomCGRect animated:YES];
}

- (void)hsy_setZoomScaleSection
{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self setMinimumZoomScale:self.class.minZoomScales];
    [self setMaximumZoomScale:self.class.maxZoomScales];
}

+ (CGFloat)minZoomScales
{
    return 0.5f;
}

+ (CGFloat)maxZoomScales
{
    return 1.5f;
}

@end
