//
//  RACSignal+Combined.m
//  HSYMethodsToolsKit
//
//  Created by anmin on 2019/9/27.
//

#import "RACSignal+Combined.h"
#import "RACSignal+Convenients.h"
#import "NSError+Message.h"

@implementation RACSignal (Combined)

+ (RACSignal<RACTuple *> *)hsy_zipSignals:(NSArray<RACSignal *> *)signals
{
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        [[[RACSignal zip:signals] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
            [RACSignal hsy_performSendSignal:subscriber forObject:RACTuplePack(x, nil)];
        } error:^(NSError * _Nullable error) {
            [RACSignal hsy_performSendSignal:subscriber forObject:RACTuplePack(nil, (error ? error : [NSError hsy_defaultRACSignalErrorMessage]))];
        }];
    }];
}

@end
