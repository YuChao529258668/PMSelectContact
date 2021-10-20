//
//  NSString+SCExtend.m
//  mCloudlib
//
//  Created by user on 13-10-12.
//  Copyright (c) 2013年 epro. All rights reserved.
//

#import "NSString+SCExtend.h"

@implementation NSString (SCExtend)
- (BOOL)sc_containsString:(NSString *)aString
{
    NSRange range = [self rangeOfString:aString options:NSCaseInsensitiveSearch];
    return range.location != NSNotFound;

//	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
//	return range.location != NSNotFound;
}

-(BOOL)containsString2:(NSString *)aString
{
    NSRange range = [self rangeOfString:aString];
	return range.location != NSNotFound;
}

- (NSString*)sc_telephoneWithReformat
{
//    if ([self sc_containsString:@"-"])
//    {
//        self = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    }
//    
//    if ([self sc_containsString:@" "])
//    {
//        self = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
//    }
//    
//    if ([self sc_containsString:@"("])
//    {
//        self = [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
//    }
//    
//    if ([self sc_containsString:@")"])
//    {
//        self = [self stringByReplacingOccurrencesOfString:@")" withString:@""];
//    }

    //以上代码会导致内存泄漏，改为如下
    NSString *result = [self copy];
    
    if ([result containsString2:@"-"])
    {
        result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    unichar uniSpac= 160; //IOS7.0通讯录 如果电话号码前面有区号+86等，会有UNICODE SPACE
    NSString  *Space = [[NSString alloc] initWithCharacters:&uniSpac length:1];
    
    if ([result containsString2:Space]){
        //
        result = [result stringByReplacingOccurrencesOfString:Space withString:@""];
    }
    
    if ([result containsString2:@" "])
    {
        result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

    if ([result containsString2:@"("])
    {
        result = [result stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }

    if ([result containsString2:@")"])
    {
        result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    return result;
}

//去掉+86或86，同时去掉空格做规范化处理获取11位电话号码
-(NSString*)sc_get11PhoneFormaterNumber
{
    //@系统号码去掉86
    NSString *telNo = [self sc_telephoneWithReformat];
    if ([telNo hasPrefix:@"86"])
    {
        telNo = [telNo substringWithRange:NSMakeRange(2, [telNo length]-2)];
    }else if ([telNo hasPrefix:@"+86"])
    {
        telNo = [telNo substringWithRange:NSMakeRange(3, [telNo length]-3)];
    }
    telNo = [telNo stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return telNo;
}

//判断手机号码是否合法
- (BOOL)sc_isValidPhoneNum
{
    NSString *regex = @"^((\\+86)|(86))?\\d{11}$";
    NSPredicate *phonePred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [phonePred evaluateWithObject:self];
}

//判断邮箱是否合法
-(BOOL)sc_isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}


//将汉语转化为拼音
- (NSString *)sc_transformToPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}


- (BOOL)sc_isEmpty {
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self stringByTrimmingCharactersInSet:set];
    if (!trimmed.length) {
        return YES;
    }
    return NO;
}


+ (BOOL)sc_isEmptyString:(NSString *)string {
    if (!string || string == NULL) {
        return YES;
    }
    
    return [string sc_isEmpty];
}


@end
