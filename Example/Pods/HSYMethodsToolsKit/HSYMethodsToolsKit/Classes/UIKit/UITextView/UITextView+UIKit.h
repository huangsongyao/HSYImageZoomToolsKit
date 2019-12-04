//
//  UITextView+UIKit.h
//  HSYMethodsToolsKit
//
//  Created by anmin on 2019/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (UIKit) <UITextViewDelegate>

//记录正则
@property (nonatomic, copy) NSString *hsy_regular;

/**
 快速创建，返回一个did changed text的block事件
 
 @param changedBlock did changed text的block事件
 @return UITextView
 */
+ (instancetype)hsy_textViewWithChanged:(void(^)(NSString *text))changedBlock;

/**
 快速创建，对UITextView对象本身添加UITextViewDelegate协议，并监听- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text委托，由self.hsy_regular来决定是否需要使用正则表达式来控制输入长度
 
 @param regular 正则表达式
 @return UITextView
 */
+ (instancetype)hsy_textViewWithRegular:(NSString *)regular;

@end

NS_ASSUME_NONNULL_END
