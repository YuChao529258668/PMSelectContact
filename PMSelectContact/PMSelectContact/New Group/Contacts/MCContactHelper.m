//
//  MCContactHelper.m
//  mCloud_iPhone
//
//  Created by 潘天乡 on 22/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import "MCContactHelper.h"
#import "MCContactObject.h"
#import "LocalAddressBookModel.h"

@implementation MCContactHelper

//搜索匹配
+ (NSMutableArray<MCContactObject *> *)searchContactWithSearchText:(NSString *)searchText resourceArr:(NSMutableArray<NSMutableArray<LocalAddressBookModel *> *> *)resourceArr {
    NSMutableArray<MCContactObject *> *matchArray = [[NSMutableArray alloc] init];
    
    NSString *regex = @"^\[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",  regex];
    BOOL isAllNumbers = [predicate evaluateWithObject:searchText];
    for (NSMutableArray *array in resourceArr) {
        for(LocalAddressBookModel *model in array){
            NSArray *arr = model.searchContactModelArr;
            for (SearchContactModel *curSearchModel in arr) {
                if (isAllNumbers) {
                    //一.如果是纯数字则匹配手机号和名字
                    if ([curSearchModel.phoneNum containsString:searchText] ||
                        [curSearchModel.compositeName containsString:searchText]) {
                        MCContactObject *contact = [[MCContactObject alloc] init];
                        contact.addressRecordID = model.addressRecordID;
                        contact.name = [[self class] getHightLightStringWithOriginal:curSearchModel.compositeName matchString:searchText normalColor:gMCColorWithHex(0x999999, 1.0) heightLightColor:gMCColorWithHex(0xff725b, 1.0)];
                        contact.phoneNum = [[self class] getHightLightStringWithOriginal:curSearchModel.phoneNum matchString:searchText normalColor:[UIColor blackColor] heightLightColor:gMCColorWithHex(0xff725b, 1.0)];
                        //名字可能为空
                        if (contact.name.length == 0) {
                            contact.name = contact.phoneNum;
                        }
                        [matchArray addObject:contact];
                    }
                }else {
                    //二.如果不是纯数字则只匹配名字
                    BOOL isMatch = NO;
                    if ([[curSearchModel.compositeName uppercaseString]
                         containsString:[searchText uppercaseString]]) {
                        //1.名字匹配
                        isMatch = YES;
                    }else if ([model.firstLetterString containsString:[searchText uppercaseString]]) {
                        //2.拼音首字母匹配
                        isMatch = YES;
                    }else {
                        NSString *pinyin = [model.pinYinName stringByReplacingOccurrencesOfString:@" " withString:@""];
                        if ([[pinyin uppercaseString] containsString:[searchText uppercaseString]]){
                            //3.拼音匹配
                            isMatch = YES;
                        }
                    }
                    if (isMatch) {
                        MCContactObject *contact = [[MCContactObject alloc] init];
                        contact.addressRecordID = model.addressRecordID;
                        contact.name = [[self class] getHightLightStringWithOriginal:curSearchModel.compositeName matchString:searchText normalColor:gMCColorWithHex(0x999999, 1.0) heightLightColor:gMCColorWithHex(0xff725b, 1.0)];
                        contact.phoneNum = [[NSAttributedString alloc] initWithString:curSearchModel.phoneNum attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                        if (contact.name.length == 0) {
                            contact.name = contact.phoneNum;
                        }
                        [matchArray addObject:contact];
                    }
                }
            }
        }
    }
    
    return matchArray;
}


+ (NSMutableArray<LocalAddressBookModel *> *)searchContactWithName:(NSString *)searchText resourceArr:(NSMutableArray<NSMutableArray<LocalAddressBookModel *> *> *)resourceArr {
    
    NSMutableArray<LocalAddressBookModel *> *matchArray = [NSMutableArray array];
    
    for (NSMutableArray *array in resourceArr) {
        for(LocalAddressBookModel *model in array) {
    
            if ([model.addressFullName containsString:searchText] || [model.pinYinName containsString:searchText] || [model.firstLetterString containsString:searchText] || [model.nameFirstLetter containsString:searchText] || [[model.pinYinName stringByReplacingOccurrencesOfString:@" " withString:@""] containsString:searchText]) {
                [matchArray addObject:model];
            }
        }
    }
    
    return matchArray;
}

+ (NSMutableArray<LocalAddressBookModel *> *)searchContactWithPhone:(NSString *)searchText resourceArr:(NSMutableArray<NSMutableArray<LocalAddressBookModel *> *> *)resourceArr {
    
    NSMutableArray<LocalAddressBookModel *> *matchArray = [NSMutableArray array];
    
    for (NSMutableArray *array in resourceArr) {
        for(LocalAddressBookModel *model in array) {
            for (SearchContactModel *searchModel in model.searchContactModelArr) {
                if ([searchModel.phoneNum isEqualToString:searchText]) {
                    [matchArray addObject:model];
                }
            }
        }
    }
    
    return matchArray;
}

//将匹配到的字符串显示高亮
+ (NSAttributedString *)getHightLightStringWithOriginal:(NSString *)original
                                            matchString:(NSString *)matchString
                                            normalColor:(UIColor *)normalColor
                                       heightLightColor:(UIColor *)heightLightColor {
    if (!original && original.length == 0) {
        return [[NSMutableAttributedString alloc] init];
    }
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:original];
    [result addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(0, original.length)];
    
    NSInteger locationOffset = 0;
    NSRange range = [original rangeOfString:matchString];
    while (range.location != NSNotFound && range.length != 0) {
        range.location = range.location + locationOffset;
        locationOffset = range.location + range.length;
        [result addAttribute:NSForegroundColorAttributeName value:heightLightColor range:range];
        
        NSInteger hasRemove = result.string.length - original.length;
        if (original.length > locationOffset - hasRemove) {
            //每次只返回匹配到的第一个range, 所以需要将前面匹配过的移除掉
            original = [original substringFromIndex:locationOffset - hasRemove];
            range = [original rangeOfString:matchString];
        }else {
            break;
        }
    }
    
    return result;
}

@end
