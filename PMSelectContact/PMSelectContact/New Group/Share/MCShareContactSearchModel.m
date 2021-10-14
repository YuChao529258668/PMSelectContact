//
//  MCShareContactSearchModel.m
//  mCloud_iPhone
//
//  Created by 向祖华 on 2018/1/20.
//  Copyright © 2018年 epro. All rights reserved.
//

#import "MCShareContactSearchModel.h"

@implementation MCShareContactSearchModel


#pragma mark - Private
+ (NSString *)mcDateStringOfToday
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)mcSectionHeaderDateString:(NSString *)dateString
{
    if (dateString.length == 8) {
        NSString *todayStr = [self mcDateStringOfToday];
        if ([dateString isEqualToString:todayStr]) {
            return NSLocalizedString(@"今天", nil);
        } else {
            NSString *year = [dateString substringToIndex:4];
            NSString *yearToday = [todayStr substringToIndex:4];
            NSString *month = [dateString substringWithRange:NSMakeRange(4, 2)];
            NSString *monthToday = [todayStr substringWithRange:NSMakeRange(4, 2)];
            NSString *day = [dateString substringWithRange:NSMakeRange(6, 2)];
            NSString *dayToday = [todayStr substringWithRange:NSMakeRange(6, 2)];
            
            if (![year isEqualToString:yearToday]) {
                return [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
            }
            
            if (![month isEqualToString:monthToday]) {
                return [NSString stringWithFormat:@"%@月%@日", month, day];
            }
            
            NSUInteger dayDistance = dayToday.integerValue - [day integerValue];
            if (dayDistance == 1) {
                //不跨月 显示昨天
                return NSLocalizedString(@"昨天", nil);
            }
            
            return [NSString stringWithFormat:@"%@月%@日", month, day];
        }
    }
    
    return @"";
}

@end
