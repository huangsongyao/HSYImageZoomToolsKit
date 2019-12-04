//
//  HSYGestureTools.m
//  HSYToolsClassKit
//
//  Created by anmin on 2019/12/3.
//

#import "HSYGestureTools.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface UIGestureRecognizer (Private)

- (void)hsy_touchGestureBlock:(HSYGestureToolsTouchBlock)touch;

@end

@implementation UIGestureRecognizer (Private)

- (void)hsy_touchGestureBlock:(HSYGestureToolsTouchBlock)touch
{
    [[[[self rac_gestureSignal] deliverOn:[RACScheduler mainThreadScheduler]] takeUntil:self.view.rac_willDeallocSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if (touch) {
            UIView *view = x.view;
            CGPoint location = [x locationInView:view];
            touch(x, view, location);
        }
    }];
}

@end

@implementation HSYGestureTools

+ (UITapGestureRecognizer *)hsy_tapGesture:(UIView *)inView touchTapGestureBlock:(HSYGestureToolsTouchBlock)tap
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [inView addGestureRecognizer:tapGesture];
    [tapGesture hsy_touchGestureBlock:tap];
    return tapGesture;
}

+ (UITapGestureRecognizer *)hsy_doubleTapGesture:(UIView *)inView touchTapGestureBlock:(HSYGestureToolsTouchBlock)tap
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.numberOfTapsRequired = 2;
    [inView addGestureRecognizer:tapGesture];
    [tapGesture hsy_touchGestureBlock:tap];
    return tapGesture;
}

+ (UIPinchGestureRecognizer *)hsy_pinchGesture:(UIView *)inView touchPinchGestureBlock:(HSYGestureToolsTouchBlock)pinch
{
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] init];
    [inView addGestureRecognizer:pinchGesture];
    [pinchGesture hsy_touchGestureBlock:pinch];
    return pinchGesture;
}

@end
