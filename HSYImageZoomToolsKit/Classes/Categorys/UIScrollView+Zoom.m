//
//  UIScrollView+Zoom.m
//  HSYImageZoomToolsKit
//
//  Created by anmin on 2019/12/6.
//

#import "UIScrollView+Zoom.h"
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/NSObject+Property.h>
#import "UIImageView+ZoomScales.h"

static NSString *kHSYImageZoomToolsZoomStatusForKey = @"HSYImageZoomToolsZoomStatusForKey";

@implementation UIScrollView (Zoom)

#pragma mark - Property

- (void)setHsy_zoomInStatus:(NSNumber *)hsy_zoomInStatus
{
    [self hsy_setProperty:hsy_zoomInStatus forKey:kHSYImageZoomToolsZoomStatusForKey objcAssociationPolicy:kHSYMethodsToolsKitObjcAssociationPolicyNonatomicStrong];
}

- (NSNumber *)hsy_zoomInStatus
{
    return [self hsy_getPropertyForKey:kHSYImageZoomToolsZoomStatusForKey];
}

#pragma mark - Methods

- (void)hsy_setZoomOutRect:(CGPoint)center
{
    if (self.hsy_zoomInStatus.boolValue) {
        [self hsy_setZoomRect:center];
    }
}

- (void)hsy_setZoomRect:(CGPoint)center
{
    BOOL isZoomIn = self.hsy_zoomInStatus.boolValue;
    CGFloat newScale = (!isZoomIn ? self.class.maxZoomScales : self.class.defaultZoomScales);
    [self setZoomScale:newScale animated:YES];
    self.hsy_zoomInStatus = @(!self.hsy_zoomInStatus.boolValue);
    NSLog(@"self.hsy_zoomInStatus => %@", self.hsy_zoomInStatus);
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
    return 2.5f;
}

+ (CGFloat)defaultZoomScales
{
    return 1.0f;
}

@end
