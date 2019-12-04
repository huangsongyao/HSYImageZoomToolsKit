//
//  HYSDecimalNumber.m
//  FBSnapshotTestCase
//
//  Created by anmin on 2019/9/25.
//

#import "HYSDecimalNumber.h"

@implementation HYSDecimalNumber

+ (NSDecimalNumber *)hsy_decimalString:(NSString *)decimalString
{
    NSString *realDecimalString = (decimalString.length ? decimalString : @"0.00");
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithString:realDecimalString];
    return decimalNumber;
}

#pragma mark - Add, Subtract, Multiply And Divide

+ (NSDecimalNumber *)hsy_decimalNumberByAdding:(NSNumber *)decimalNumber otherDecimalNumber:(NSNumber *)otherDecimalNumber
{
    return [self.class hsy_decimalStringByAdding:[NSString stringWithFormat:@"%@", decimalNumber]
                              otherDecimalString:[NSString stringWithFormat:@"%@", otherDecimalNumber]];
}

+ (NSDecimalNumber *)hsy_decimalStringByAdding:(NSString *)decimalString otherDecimalString:(NSString *)otherDecimalString
{
    NSDecimalNumber *decimalNumber = [HYSDecimalNumber hsy_decimalString:decimalString];
    NSDecimalNumber *otherDecimalNumber = [HYSDecimalNumber hsy_decimalString:otherDecimalString];
    NSDecimalNumber *addingResult = [decimalNumber decimalNumberByAdding:otherDecimalNumber];
    
    return [HYSDecimalNumber hsy_decimalString:[NSString stringWithFormat:@"%@", addingResult]];
}

+ (NSDecimalNumber *)hsy_decimalNumberBySubtracting:(NSNumber *)decimalNumber otherDecimalNumber:(NSNumber *)otherDecimalNumber
{
    return [self.class hsy_decimalStringBySubtracting:[NSString stringWithFormat:@"%@", decimalNumber]
                                   otherDecimalString:[NSString stringWithFormat:@"%@", otherDecimalNumber]];
}

+ (NSDecimalNumber *)hsy_decimalStringBySubtracting:(NSString *)decimalString otherDecimalString:(NSString *)otherDecimalString
{
    NSDecimalNumber *decimalNumber = [HYSDecimalNumber hsy_decimalString:decimalString];
    NSDecimalNumber *otherDecimalNumber = [HYSDecimalNumber hsy_decimalString:otherDecimalString];
    NSDecimalNumber *addingResult = [decimalNumber decimalNumberBySubtracting:otherDecimalNumber];
    
    return [HYSDecimalNumber hsy_decimalString:[NSString stringWithFormat:@"%@", addingResult]];
}

+ (NSDecimalNumber *)hsy_decimalNumberByMultiplying:(NSNumber *)decimalNumber otherDecimalNumber:(NSNumber *)otherDecimalNumber
{
    return [self.class hsy_decimalStringByMultiplying:[NSString stringWithFormat:@"%@", decimalNumber]
                                   otherDecimalString:[NSString stringWithFormat:@"%@", otherDecimalNumber]];
}

+ (NSDecimalNumber *)hsy_decimalStringByMultiplying:(NSString *)decimalString otherDecimalString:(NSString *)otherDecimalString
{
    NSDecimalNumber *decimalNumber = [HYSDecimalNumber hsy_decimalString:decimalString];
    NSDecimalNumber *otherDecimalNumber = [HYSDecimalNumber hsy_decimalString:otherDecimalString];
    NSDecimalNumber *addingResult = [decimalNumber decimalNumberByMultiplyingBy:otherDecimalNumber];
    
    return [HYSDecimalNumber hsy_decimalString:[NSString stringWithFormat:@"%@", addingResult]];
}

+ (NSDecimalNumber *)hsy_decimalNumberByDividing:(NSNumber *)decimalNumber otherDecimalNumber:(NSNumber *)otherDecimalNumber
{
    return [self.class hsy_decimalStringByDividing:[NSString stringWithFormat:@"%@", decimalNumber]
                                otherDecimalString:[NSString stringWithFormat:@"%@", otherDecimalNumber]];
}

+ (NSDecimalNumber *)hsy_decimalStringByDividing:(NSString *)decimalString otherDecimalString:(NSString *)otherDecimalString
{
    NSDecimalNumber *decimalNumber = [HYSDecimalNumber hsy_decimalString:decimalString];
    NSDecimalNumber *otherDecimalNumber = [HYSDecimalNumber hsy_decimalString:otherDecimalString];
    NSDecimalNumber *addingResult = [decimalNumber decimalNumberByDividingBy:otherDecimalNumber];
    
    return [HYSDecimalNumber hsy_decimalString:[NSString stringWithFormat:@"%@", addingResult]];
}

@end

@implementation NSDecimalNumber (Than)

#pragma mark - Compares

- (NSComparisonResult)hsy_compares:(NSString *)decimalString
{
    NSDecimalNumber *decimal = [HYSDecimalNumber hsy_decimalString:decimalString];
    NSComparisonResult result = [self compare:decimal];
    return result;
}

- (BOOL)hsy_greaterThan:(NSString *)decimalString
{
    NSComparisonResult result = [self hsy_compares:decimalString];
    return (result == NSOrderedDescending);
}

- (BOOL)hsy_lessThan:(NSString *)decimalString
{
    NSComparisonResult result = [self hsy_compares:decimalString];
    return (result == NSOrderedAscending);
}

- (BOOL)hsy_isEqualThan:(NSString *)decimalString
{
    NSComparisonResult result = [self hsy_compares:decimalString];
    return (result == NSOrderedSame);
}

- (BOOL)hsy_lessEqualThan:(NSString *)decimalString
{
    return ([self hsy_lessThan:decimalString] || [self hsy_isEqualThan:decimalString]);
}

- (BOOL)hsy_greaterEqualThan:(NSString *)decimalString
{
    return ([self hsy_greaterThan:decimalString] || [self hsy_isEqualThan:decimalString]);
}


@end
