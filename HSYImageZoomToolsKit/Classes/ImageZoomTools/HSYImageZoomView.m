//
//  HSYImageZoomView.m
//  HSYImageZoomToolsKit
//
//  Created by anmin on 2019/12/3.
//

#import "HSYImageZoomView.h"
#import <HSYMethodsToolsKit/UIImage+Canvas.h>
#import <HSYMethodsToolsKit/UIApplication+AppDelegates.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYToolsClassKit/HSYGestureTools.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "UIImageView+ZoomScales.h"
#import <HSYMethodsToolsKit/UIScrollView+Pages.h>
#import <HSYMethodsToolsKit/UIImageView+ZoomScale.h>

@interface HSYImageZoomView () <UIScrollViewDelegate> {
    @private NSArray<NSValue *> *_imageCGRects;
}

@property (nonatomic, strong) UIImageView *effectImageView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy, readonly) HSYImageZoomArgument *zoomArguments;
@property (nonatomic, strong, readonly) UIView *currentMoveImageSuperView;

@end

@implementation HSYImageZoomView

- (instancetype)initWithImages:(HSYImageZoomArgument *)zoomArguments
{
    UIWindow *window = UIApplication.hsy_keyWindows;
    if (self = [super initWithSize:window.size]) {
        self.backgroundColor = UIColor.clearColor;
        
        self->_zoomArguments = zoomArguments;
        self->_currentMoveImageSuperView = zoomArguments.superview;
        self.currentImageView = [[UIImageView alloc] initWithImage:zoomArguments.hsy_currentImageView.image highlightedImage:zoomArguments.hsy_currentImageView.image];
        self.currentImageView.frame = [self hsy_toMoveCGRect:zoomArguments.hsy_currentZoomChildArgument.hsy_zoomImageViewOrigin];
        [self addSubview:self.currentImageView];
        
        @weakify(self);
        [HSYGestureTools hsy_tapGesture:self touchTapGestureBlock:^(UIGestureRecognizer * _Nonnull gesture, UIView * _Nonnull touchView, CGPoint location) {
            @strongify(self);
            [self hsy_removeTools];
        }];
        [HSYGestureTools hsy_doubleTapGesture:self touchTapGestureBlock:^(UIGestureRecognizer * _Nonnull gesture, UIView * _Nonnull touchView, CGPoint location) {
            
        }];
        [window addSubview:self];
    }
    return self;
}

#pragma mark - Lazy

- (NSInteger)hsy_currentIndex
{
    return self.zoomArguments.selectedIndex.integerValue;
}

- (UIImageView *)hsy_scrollViewTopImage
{
    return (UIImageView *)self.scrollView.subviews[self.scrollView.hsy_currentPage];
}

- (UIImageView *)effectImageView
{
    if (!_effectImageView) {
        UIImage *backgroundImage = [UIImage hsy_imageWithFillColor:UIColor.clearColor];
        _effectImageView = [[UIImageView alloc] initWithImage:backgroundImage highlightedImage:backgroundImage];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = _effectImageView.bounds;
        _effectImageView.alpha = 0.0f;
        _effectImageView.frame = self.bounds;
        [_effectImageView addSubview:visualEffectView];
        [self addSubview:_effectImageView];
    }
    return _effectImageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        CGFloat x = 0.0f;
        for (HSYImageZoomChildArgument *argument in self.zoomArguments.arguments) {
            UIImageView *imageView = argument.hsy_zoomImageView;
            UIImageView *thisImageView = [[UIImageView alloc] initWithImage:imageView.image highlightedImage:imageView.highlightedImage];
            thisImageView.x = x;
            thisImageView.width = _scrollView.width;
            [thisImageView hsy_zoomScaleWidths:thisImageView.width scales:imageView.image.size];
            thisImageView.y = (self.height - thisImageView.height)/2.0f;
            [_scrollView addSubview:thisImageView];
            x = thisImageView.right;
        }
        [_scrollView setContentSize:CGSizeMake(x, 0.0f)];
        [_scrollView hsy_setXPage:self.hsy_currentIndex];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark - Animation

+ (NSTimeInterval)hsy_durations
{
    return 0.35f;
}

- (void)hsy_showTools
{
    @weakify(self);
    [[RACScheduler mainThreadScheduler] schedule:^{
        [UIView animateWithDuration:HSYImageZoomView.hsy_durations animations:^{
            @strongify(self);
            self.effectImageView.alpha = 1.0f;
            [self.currentImageView hsy_scaleCentryCGRect];
        } completion:^(BOOL finished) {
            @strongify(self);
            self.scrollView.hidden = NO;
            self.currentImageView.hidden = YES;
        }];
    }];
}

- (void)hsy_removeTools
{
    [self updateCurrentImageStatus];
    @weakify(self);
    [[RACScheduler mainThreadScheduler] schedule:^{
        [UIView animateWithDuration:HSYImageZoomView.hsy_durations animations:^{
            @strongify(self);
            self.effectImageView.alpha = 0.0f;
            CGRect rect = self.zoomArguments.arguments[self.scrollView.hsy_currentPage].hsy_zoomImageViewOrigin;
            self.currentImageView.frame = [self hsy_fromMoveCGRect:rect];
        } completion:^(BOOL finished) {
            @strongify(self);
            self.currentImageView.hidden = YES;
            self.currentImageView = nil;
            [self removeFromSuperview];
        }];
    }];
}

- (void)updateCurrentImageStatus
{
    UIImageView *topImageView = self.hsy_scrollViewTopImage;
    self.currentImageView.image = topImageView.image;
    self.currentImageView.highlightedImage = topImageView.highlightedImage;
    self.currentImageView.hidden = NO;
    self.scrollView.hidden = YES;
}

#pragma mark - Rect Map

- (CGRect)hsy_toMoveCGRect:(CGRect)rect
{
    UIWindow *window = UIApplication.hsy_keyWindows;
    CGRect toCGRect = [self.currentMoveImageSuperView convertRect:rect toView:window];
    return toCGRect;
}

- (CGRect)hsy_fromMoveCGRect:(CGRect)rect
{
    CGRect fromCGRect = [self convertRect:rect fromView:self.currentMoveImageSuperView];
    NSLog(@"fromCGRect => %@", NSStringFromCGRect(fromCGRect));
    return fromCGRect;
}

#pragma mark - UIScrollViewDelegate


@end

@implementation HSYImageZoomView (Tools)

+ (HSYImageZoomView *)hsy_imageZoom:(HSYImageZoomArgument *)zoomArguments
{
    if (!zoomArguments.arguments.count || zoomArguments.selectedIndex.integerValue > zoomArguments.arguments.count || !zoomArguments.superview) {
        return nil;
    }
    HSYImageZoomView *imageZoomView = [[HSYImageZoomView alloc] initWithImages:zoomArguments];
    [imageZoomView hsy_showTools];
    return imageZoomView;
}

@end
