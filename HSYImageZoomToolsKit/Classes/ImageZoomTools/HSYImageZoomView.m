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
#import <HSYMethodsToolsKit/UIApplication+AppDelegates.h>
#import <HSYMethodsToolsKit/UIImageView+ZoomScale.h>
#import <Masonry/Masonry.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import "UIScrollView+Zoom.h"

@interface HSYImageZoomView () <UIScrollViewDelegate> {
    @private NSArray<NSValue *> *_imageCGRects;
    @private UILabel *_pagesLabel;
}

@property (nonatomic, strong) UIImageView *effectImageView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, copy, readonly) HSYImageZoomArgument *zoomArguments;
@property (nonatomic, strong, readonly) UIView *currentMoveImageSuperView;

@end

@implementation HSYImageZoomView

- (instancetype)initWithImages:(HSYImageZoomArgument *)zoomArguments
{
    UIWindow *window = UIApplication.hsy_keyWindows;
    if (self = [super initWithSize:window.size]) {
        //初始状态
        self.backgroundColor = UIColor.clearColor;
        self->_zoomArguments = zoomArguments;
        //初始ui
        self.effectImageView.alpha = 0.0f;
        self->_currentMoveImageSuperView = self.zoomArguments.superview;
        self.currentImageView = [[UIImageView alloc] initWithImage:self.zoomArguments.hsy_currentImageView.image highlightedImage:self.zoomArguments.hsy_currentImageView.image];
        self.currentImageView.frame = [self hsy_toMoveCGRect:self.zoomArguments.hsy_currentZoomChildArgument.hsy_zoomImageViewOrigin];
        [self addSubview:self.currentImageView];
        self.pagesLabel.text = [self.zoomArguments hsy_toCurrentPages:(self.zoomArguments.selectedIndex.integerValue + 1)];
        //添加至window层遮罩
        [window addSubview:self];
    }
    return self;
}

#pragma mark - Methods

- (NSInteger)hsy_currentIndex
{
    return self.zoomArguments.selectedIndex.integerValue;
}

- (NSInteger)hsy_currentPage
{
    NSInteger index = MAX(self.scrollView.hsy_currentPage, 0);
    index = MIN(index, (self.scrollView.subviews.count - 1));
    return index;
}

- (UIImageView *)hsy_scrollViewTopImage
{
    return (UIImageView *)self.scrollView.subviews[self.hsy_currentPage].subviews.firstObject;
}

#pragma mark - Lazy

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        @weakify(self);
        _tapGesture = [HSYGestureTools hsy_tapGesture:self touchTapGestureBlock:^(UIGestureRecognizer * _Nonnull gesture, UIView * _Nonnull touchView, CGPoint location) {
            @strongify(self);
            [self hsy_removeTools];
        }];
    }
    return _tapGesture;
}
- (UIImageView *)effectImageView
{
    if (!_effectImageView) {
        UIImage *backgroundImage = [UIImage hsy_imageWithFillColor:self.zoomArguments.blurEffectColor];
        _effectImageView = [[UIImageView alloc] initWithImage:backgroundImage highlightedImage:backgroundImage];
        _effectImageView.frame = self.bounds;
        [self addSubview:_effectImageView];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.zoomArguments.hsy_blurEffectStyle];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = _effectImageView.bounds;
        [_effectImageView addSubview:visualEffectView];
    }
    return _effectImageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.hidden = YES;
        _scrollView.bounces = NO;
        for (UIView *view in _scrollView.subviews) {
            [view removeFromSuperview];
        }
        CGFloat x = 0.0f;
        for (HSYImageZoomChildArgument *argument in self.zoomArguments.arguments) {
            UIImageView *imageView = argument.hsy_zoomImageView;
            UIImageView *thisImageView = [[UIImageView alloc] initWithImage:imageView.image highlightedImage:imageView.highlightedImage];
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.x = x;
            scrollView.size = self.scrollView.size;
            thisImageView.width = self.width;
            [thisImageView hsy_zoomScaleWidths:thisImageView.width scales:imageView.image.size];
            thisImageView.y = (self.height - thisImageView.height)/2.0f;
            scrollView.delegate = self;
            [scrollView hsy_setZoomScaleSection];
            [scrollView addSubview:thisImageView];
            @weakify(self);
            [self.tapGesture requireGestureRecognizerToFail:[HSYGestureTools hsy_doubleTapGesture:scrollView touchTapGestureBlock:^(UIGestureRecognizer * _Nonnull gesture, UIView * _Nonnull touchView, CGPoint location) {
                @strongify(self);
                [scrollView hsy_setZoomInRect:self.center];
            }]];
            [_scrollView addSubview:scrollView];
            x = scrollView.right;
        }
        [_scrollView setContentSize:CGSizeMake(x, 0.0f)];
        [_scrollView hsy_setXPage:self.hsy_currentIndex];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)pagesLabel
{
    if (!_pagesLabel) {
        _pagesLabel = [[UILabel alloc] init];
        _pagesLabel.textColor = UIColor.blackColor;
        _pagesLabel.font = [UIFont systemFontOfSize:17.0f];
        _pagesLabel.alpha = 0.0f;
        [self addSubview:_pagesLabel];
        [self bringSubviewToFront:_pagesLabel];
        CGFloat offset = 20.0f;
        @weakify(self);
        [_pagesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.mas_top).offset((HSY_IS_iPhoneX ? (UIApplication.hsy_statusBarHeight + offset) : offset));
            make.left.equalTo(self.mas_left).offset(offset);
            make.height.equalTo(@(self->_pagesLabel.font.lineHeight));
            make.width.equalTo(@(self.width/2.0f));
        }];
    }
    return _pagesLabel;
}

#pragma mark - Animation

+ (NSTimeInterval)hsy_durations
{
    return 3.35f;
}

- (void)hsy_showTools
{
    @weakify(self);
    [[RACScheduler mainThreadScheduler] schedule:^{
        [UIView animateWithDuration:HSYImageZoomView.hsy_durations animations:^{
            @strongify(self);
            self.effectImageView.alpha = 1.0f;
            self.pagesLabel.alpha = 1.0f;
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
            self.pagesLabel.alpha = 0.0f;
            CGRect rect = self.zoomArguments.arguments[self.hsy_currentPage].hsy_zoomImageViewOrigin;
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
    NSLog(@"toCGRect => %@", NSStringFromCGRect(toCGRect));
    return toCGRect;
}

- (CGRect)hsy_fromMoveCGRect:(CGRect)rect
{
    CGRect fromCGRect = [self convertRect:rect fromView:self.currentMoveImageSuperView];
    NSLog(@"fromCGRect => %@", NSStringFromCGRect(fromCGRect));
    return fromCGRect;
}

#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"Execute Destructor");
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.scrollView]) {
        self.pagesLabel.text = [self.zoomArguments hsy_toCurrentPages:(scrollView.hsy_currentPage + 1)];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.hsy_scrollViewTopImage;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (![scrollView isEqual:self.scrollView]) {
        [scrollView setZoomScale:scale animated:YES];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.scrollView]) {
        return;
    }
    if (scrollView.zoomScale > 1) {
        UIImageView *imageView = self.hsy_scrollViewTopImage;
        CGFloat offsetX = (scrollView.width > scrollView.hsy_contentSizeWidth) ? (scrollView.width - scrollView.hsy_contentSizeWidth) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.height > scrollView.hsy_contentSizeHeight) ?
        (scrollView.height - scrollView.hsy_contentSizeHeight) * 0.5 : 0.0;
        imageView.center = CGPointMake(scrollView.hsy_contentSizeWidth * 0.5 + offsetX, scrollView.hsy_contentSizeHeight * 0.5 + offsetY);
    }
}

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
