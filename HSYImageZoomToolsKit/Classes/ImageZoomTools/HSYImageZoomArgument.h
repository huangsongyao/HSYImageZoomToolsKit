//
//  HSYImageZoomArgument.h
//  HSYImageZoomToolsKit
//
//  Created by anmin on 2019/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSYImageZoomChildArgument : NSObject

//UIImageView对象或者空字符串
@property (nonatomic, strong, nullable) UIImageView *imageView;
//远端url地址
@property (nonatomic, copy, nonnull) NSString *urlString;
//默认占位图
@property (nonatomic, copy, nullable) NSString *placeholder;

//返回用于显示在scrollView的child view
- (UIImageView *)hsy_zoomImageView;
//imageView的原始origin
- (CGRect)hsy_zoomImageViewOrigin;

@end

@interface HSYImageZoomArgument : NSObject

//UIImageView所在的superview
@property (nonatomic, strong, readonly, nonnull) UIView *superview;
//初始选中的位置
@property (nonatomic, strong, readonly, nonnull) NSNumber *selectedIndex;
//显示的UIImageView的对应的内容，格式为url远端地址+UIImage对象+默认占位图名称
@property (nonatomic, copy, readonly, nonnull) NSArray<HSYImageZoomChildArgument *> *arguments;

//格式：@{@{@"默认占位图" : @{@(初始选中的项所在的index) : UIImageView的superview}} : @[@{@"UIImage对应的远端url地址A" : UIImageView对象AA或者@"空字符串"}, @{@"UIImage对应的远端url地址B" : UIImage对象BB或者@"空字符串"}, ... ]}
+ (HSYImageZoomArgument *)hsy_toZoomArguments:(NSDictionary<NSDictionary<NSString *, NSDictionary<NSNumber *, UIView *> *> *, NSArray<NSDictionary<NSString *, id> *> *> *)arguments;
//当前选中的图片
- (UIImageView *)hsy_currentImageView;
//当前的子参数模型对象
- (HSYImageZoomChildArgument *)hsy_currentZoomChildArgument;

@end

NS_ASSUME_NONNULL_END
