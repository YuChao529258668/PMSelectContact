//
//  NSString+Extend.h
//  mCloudlib
//
//  Created by user on 13-10-12.
//  Copyright (c) 2013年 epro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)
- (BOOL)containsString:(NSString *)aString;
- (NSString*)telephoneWithReformat;
//截取固定长度字符，对于截取位置是组合字符，则特殊处理
-(NSString*)subStringWithLength:(NSInteger)maxLength;

//将汉语转化为拼音
- (NSString *)transformToPinyin;

//去掉+86或86，同时去掉空格做规范化处理获取11位电话号码
-(NSString*)get11PhoneFormaterNumber;

//判断手机号码是否合法
- (BOOL)isValidPhoneNum;

//判断邮箱是否合法
-(BOOL)isValidateEmail;

//判断是否符合ipv6
-(BOOL)isValidateIPv6;

+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;

/// 判断字符串是否为空
- (BOOL)isEmpty;
/**去除首尾空格*/
-(NSString *)trim;

/**
 *  判断字符串是否为空
 */
+ (BOOL)isEmptyString:(NSString *)string;


@end
