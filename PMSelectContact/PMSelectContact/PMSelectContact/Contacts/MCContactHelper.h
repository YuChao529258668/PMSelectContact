//
//  MCContactHelper.h
//  mCloud_iPhone
//
//  Created by 潘天乡 on 22/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMSelectContactDefine.h"

@class MCContactObject;
@class LocalAddressBookModel;

//联系人工具类
@interface MCContactHelper : NSObject

/**
 * 搜索匹配的联系人
 * @param searchText 要搜索的文本
 * @param resourceArr 总数据源
 */
+ (NSMutableArray<MCContactObject *> *)searchContactWithSearchText:(NSString *)searchText resourceArr:(NSMutableArray<NSMutableArray<LocalAddressBookModel *> *> *)resourceArr;

/**
 * 搜索名字匹配的联系人
 * @param searchText 要搜索的文本
 * @param resourceArr 总数据源
 * @return NSMutableArray<LocalAddressBookModel *>
 */
+ (NSMutableArray<LocalAddressBookModel *> *)searchContactWithName:(NSString *)searchText resourceArr:(NSMutableArray<NSMutableArray<LocalAddressBookModel *> *> *)resourceArr;

/**
 * 搜索号码匹配的联系人
 * @param searchText 要搜索的文本
 * @param resourceArr 总数据源
 * @return NSMutableArray<LocalAddressBookModel *>
 */
+ (NSMutableArray<LocalAddressBookModel *> *)searchContactWithPhone:(NSString *)searchText resourceArr:(NSMutableArray<NSMutableArray<LocalAddressBookModel *> *> *)resourceArr;

/**
 * 将匹配到的字符串显示高亮
 * @param original 原始字符串
 * @param matchString 需要匹配的子字符串
 * @param normalColor 没有被匹配到字符串的颜色
 * @param heightLightColor 被匹配到字符串的颜色
 * return 返回NSAttributedString的实例对象
 */
+ (NSAttributedString *)getHightLightStringWithOriginal:(NSString *)original
                                            matchString:(NSString *)matchString
                                            normalColor:(UIColor *)normalColor
                                       heightLightColor:(UIColor *)heightLightColor;

@end
