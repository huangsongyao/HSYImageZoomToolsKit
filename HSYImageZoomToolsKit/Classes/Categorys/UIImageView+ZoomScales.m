//
//  UIImageView+ZoomScales.m
//  HSYImageZoomToolsKit
//
//  Created by anmin on 2019/12/3.
//

#import "UIImageView+ZoomScales.h"
#import <HSYMacroKit/HSYToolsMacro.h>

@implementation UIImageView (ZoomScales)

+ (CGSize)hsy_scaleCGSize:(CGSize)imageSize
{
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        return CGSizeZero;
    }
    CGSize scaleSize = CGSizeZero;
    if (imageSize.width >= imageSize.height) {
        //当图片的原始宽度大于图片的原始高度，说明放缩方式以屏幕的宽度为依据
        CGFloat height = (imageSize.height * IPHONE_WIDTH) / imageSize.width;
        scaleSize = CGSizeMake(IPHONE_WIDTH, height);
    } else {
        if ((imageSize.width/imageSize.height) >= (IPHONE_WIDTH/IPHONE_HEIGHT)) {
            //当图片的原始宽高比大于设备的屏幕宽高比时，说明放缩方式依然是以屏幕的宽度作为依据
            CGFloat height = (imageSize.height * IPHONE_WIDTH) / imageSize.width;
            scaleSize = CGSizeMake(IPHONE_WIDTH, height);
        } else {
            //否则说明是一张超级长图，则以设备的屏幕高度作为依据
            CGFloat width = (imageSize.width * IPHONE_HEIGHT) / imageSize.height;
            scaleSize = CGSizeMake(width, IPHONE_HEIGHT);
        }
    }
    return scaleSize;
}

- (CGSize)hsy_scaleCGSize
{
    return [UIImageView hsy_scaleCGSize:self.image.size];
}

- (void)hsy_scaleCentryCGRect
{
    CGSize size = [self hsy_scaleCGSize];
    CGPoint point = CGPointMake((IPHONE_WIDTH - size.width)/2, (IPHONE_HEIGHT - size.height)/2);
    if (self.image) {
        self.frame = (CGRect){point, size};
    }
}


@end
