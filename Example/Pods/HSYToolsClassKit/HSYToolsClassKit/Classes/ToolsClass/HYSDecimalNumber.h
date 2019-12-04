//
//  HYSDecimalNumber.h
//  FBSnapshotTestCase
//
//  Created by anmin on 2019/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYSDecimalNumber : NSDecimalNumber

+ (NSDecimalNumber *)hsy_decimalString:(NSString *)decimalString;

/**
 精度加法，即：decimalNumber + otherDecimalNumber

 @param decimalNumber 加数
 @param otherDecimalNumber 另一个加数
 @return 精度加法结果
 */
+ (NSDecimalNumber *)hsy_decimalNumberByAdding:(NSNumber *)decimalNumber otherDecimalNumber:(NSNumber *)otherDecimalNumber;
+ (NSDecimalNumber *)hsy_decimalStringByAdding:(NSString *)decimalString otherDecimalString:(NSString *)otherDecimalString;


/**
 精度减法，即：decimalNumber - otherDecimalNumber

 @param decimalNumber 减数
 @param otherDecimalNumber 被减数
 @return 精度减法结果
 */
+ (NSDecimalNumber *)hsy_decimalNumberBySubtracting:(NSNumber *)decimalNumber otherDecimalNumber:(NSNumber *)otherDecimalNumber;
+ (NSDecimalNumber *)hsy_decimalStringBySubtracting:(NSString *)decimalString otherDecimalString:(NSString *)otherDecimalString;

/**
 精度乘法，即：decimalNumber * otherDecimalNumber

 @param decimalNumber 乘数
 @param otherDecimalNumber 另一个乘数
 @return 精度乘法结果
 */
+ (NSDecimalNumber *)hsy_decimalNumberByMultiplying:(NSNumber *)decimalNumber otherDecimalNumber:(NSNumber *)otherDecimalNumber;
+ (NSDecimalNumber *)hsy_decimalStringByMultiplying:(NSString *)decimalString otherDecimalString:(NSString *)otherDecimalString;

/**
 精度除法，即：decimalNumber / otherDecimalNumber

 @param decimalNumber 除数
 @param otherDecimalNumber 被除数
 @return 精度除法结果
 */
+ (NSDecimalNumber *)hsy_decimalNumberByDividing:(NSNumber *)decimalNumber otherDecimalNumber:(NSNumber *)otherDecimalNumber;
+ (NSDecimalNumber *)hsy_decimalStringByDividing:(NSString *)decimalString otherDecimalString:(NSString *)otherDecimalString;

@end

@interface NSDecimalNumber (Than)

/**
 是否满足条件 --> self > decimalString, 满足返回YES，否则返回NO
 
 @param decimalString 数值
 @return self > decimalString, 满足返回YES，否则返回NO
 */
- (BOOL)hsy_greaterThan:(NSString *)decimalString;

/**
 是否满足条件 --> self < decimalString, 满足返回YES，否则返回NO
 
 @param decimalString 数值
 @return self < decimalString, 满足返回YES，否则返回NO
 */
- (BOOL)hsy_lessThan:(NSString *)decimalString;

/**
 是否满足条件 --> self == decimalString, 满足返回YES，否则返回NO
 
 @param decimalString 数值
 @return self == decimalString, 满足返回YES，否则返回NO
 */
- (BOOL)hsy_isEqualThan:(NSString *)decimalString;

/**
 是否满足条件 --> self <= decimalString, 满足返回YES，否则返回NO
 
 @param decimalString 数值
 @return self <= decimalString, 满足返回YES，否则返回NO
 */
- (BOOL)hsy_lessEqualThan:(NSString *)decimalString;

/**
 是否满足条件 --> self >= decimalString, 满足返回YES，否则返回NO
 
 @param decimalString 数值
 @return self >= decimalString, 满足返回YES，否则返回NO
 */
- (BOOL)hsy_greaterEqualThan:(NSString *)decimalString;

@end

NS_ASSUME_NONNULL_END
