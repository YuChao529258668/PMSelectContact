//
//  NSString+SCExtend.h
//  mCloudlib
//
//  Created by user on 13-10-12.
//  Copyright (c) 2013年 epro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCExtend)
- (BOOL)sc_containsString:(NSString *)aString;
- (NSString*)sc_telephoneWithReformat;

//将汉语转化为拼音
- (NSString *)sc_transformToPinyin;

//去掉+86或86，同时去掉空格做规范化处理获取11位电话号码
- (NSString*)sc_get11PhoneFormaterNumber;

//判断手机号码是否合法
- (BOOL)sc_isValidPhoneNum;

//判断邮箱是否合法
- (BOOL)sc_isValidateEmail;

/// 判断字符串是否为空
- (BOOL)sc_isEmpty;

/**
 *  判断字符串是否为空
 */
+ (BOOL)sc_isEmptyString:(NSString *)string;


@end
