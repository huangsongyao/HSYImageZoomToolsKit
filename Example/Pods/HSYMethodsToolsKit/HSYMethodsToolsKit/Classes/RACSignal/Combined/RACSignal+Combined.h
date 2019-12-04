//
//  RACSignal+Combined.h
//  HSYMethodsToolsKit
//
//  Created by anmin on 2019/9/27.
//

#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (Combined)

/**
 返回合并zip信号的结果信号，signal为一个RACTuple元组，first表示zip信号成功时的result，类型是RACTuple元组，second表示zip信号失败时的message，类型是NSError

 @param signals 信号集
 @return zip信号
 */
+ (RACSignal<RACTuple *> *)hsy_zipSignals:(NSArray<RACSignal *> *)signals;

@end

NS_ASSUME_NONNULL_END
