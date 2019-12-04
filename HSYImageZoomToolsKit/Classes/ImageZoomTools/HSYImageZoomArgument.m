//
//  HSYImageZoomArgument.m
//  HSYImageZoomToolsKit
//
//  Created by anmin on 2019/12/3.
//

#import "HSYImageZoomArgument.h"
#import <HSYMethodsToolsKit/UIImageView+UrlString.h>

@implementation HSYImageZoomChildArgument

- (UIImageView *)hsy_zoomImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    if (self.imageView.image) {
        imageView.image = self.imageView.image;
        imageView.highlightedImage = self.imageView.highlightedImage;
    } else {
        [imageView hsy_setImageWithUrlString:self.urlString placeholderImage:[UIImage imageNamed:self.placeholder]];
    }
    return imageView;
}

- (CGRect)hsy_zoomImageViewOrigin
{
    return self.imageView.frame;
}

@end

@interface HSYImageZoomArgument () {
    @private NSArray<HSYImageZoomChildArgument *> *_arguments;
}
@end
@implementation HSYImageZoomArgument

- (instancetype)initWithSuperview:(UIView *)superview selectedIndex:(NSNumber *)index
{
    if (self = [super init]) {
        self->_superview = superview;
        self->_selectedIndex = index;
    }
    return self;
}

- (NSArray<HSYImageZoomChildArgument *> *)arguments
{
    return _arguments; 
}

- (HSYImageZoomChildArgument *)hsy_currentZoomChildArgument
{
    HSYImageZoomChildArgument *currentChildArgument = self.arguments[self.selectedIndex.integerValue];
    return currentChildArgument;
}

- (UIImageView *)hsy_currentImageView
{
    return self.hsy_currentZoomChildArgument.hsy_zoomImageView;
} 

+ (HSYImageZoomArgument *)hsy_toZoomArguments:(NSDictionary<NSDictionary<NSString *, NSDictionary<NSNumber *, UIView *> *> *, NSArray<NSDictionary<NSString *, id> *> *> *)arguments
{
    NSMutableArray<HSYImageZoomChildArgument *> *zooms = [NSMutableArray arrayWithCapacity:arguments.count];
    NSString *placeholder = (NSString *)[arguments.allKeys.firstObject allKeys].firstObject;
    NSNumber *index = (NSNumber *)[[arguments.allKeys.firstObject allValues].firstObject allKeys].firstObject;
    UIView *superview = (UIView *)[[arguments.allKeys.firstObject allValues].firstObject allValues].firstObject;
    HSYImageZoomArgument *zoomArgument = [[HSYImageZoomArgument alloc] initWithSuperview:superview selectedIndex:index];
    for (NSDictionary *dictionary in arguments.allValues.firstObject) {
        HSYImageZoomChildArgument *zoom = [[HSYImageZoomChildArgument alloc] init];
        NSDictionary *paramter = @{@"imageView" : dictionary.allValues.firstObject,
                                   @"urlString" : dictionary.allKeys.firstObject,
                                   @"placeholder" : placeholder,};
        for (NSString *forKey in paramter.allKeys) {
            if ([zoom respondsToSelector:NSSelectorFromString(forKey)]) {
                [zoom setValue:paramter[forKey] forKey:forKey];
            }
        }
        [zooms addObject:zoom];
    }
    zoomArgument->_arguments = [NSArray arrayWithArray:zooms];
    return zoomArgument;
}

@end
