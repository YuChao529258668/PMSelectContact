//
//  NSString+Extend.m
//  mCloudlib
//
//  Created by user on 13-10-12.
//  Copyright (c) 2013年 epro. All rights reserved.
//

#import "NSString+Extend.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extend)
- (BOOL)containsString:(NSString *)aString
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

- (NSString*)telephoneWithReformat
{
//    if ([self containsString:@"-"])
//    {
//        self = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    }
//    
//    if ([self containsString:@" "])
//    {
//        self = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
//    }
//    
//    if ([self containsString:@"("])
//    {
//        self = [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
//    }
//    
//    if ([self containsString:@")"])
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
-(NSString*)get11PhoneFormaterNumber
{
    //@系统号码去掉86
    NSString *telNo = [self telephoneWithReformat];
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
- (BOOL)isValidPhoneNum
{
    NSString *regex = @"^((\\+86)|(86))?\\d{11}$";
    NSPredicate *phonePred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [phonePred evaluateWithObject:self];
}

//判断邮箱是否合法
-(BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//截取固定长度字符，对于截取位置是组合字符比如emoji字符等，则特殊处理
-(NSString*)subStringWithLength:(NSInteger)maxLength{
    
   __block NSInteger index = [self length];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         if ((substringRange.location + substringRange.length) > maxLength) {
             index = substringRange.location;
             *stop = YES;
         }
         
     }];
    return [self substringToIndex:index];
}

//将汉语转化为拼音
- (NSString *)transformToPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}

//判断是否符合ipv6
-(BOOL)isValidateIPv6
{
    NSString *ipv6Regex = @"^([0-9a-fA-F]{1,4}:|:)+[0-9a-fA-F]{1,4}$";
    NSPredicate *ipv6Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ipv6Regex];
    return [ipv6Test evaluateWithObject:self];
}
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];//
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
        NSString *stringBase64 = [resultData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]; // base64格式的字符串
        return stringBase64;
        
    }
    free(buffer);
    return nil;
}

- (BOOL)isEmpty {  
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

-(NSString *)trim
{
    NSMutableString *mStr = [self mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef) mStr);
    NSString *result = [mStr copy];
    return result;
}

+ (BOOL)isEmptyString:(NSString *)string {
    if (!string || string == NULL) {
        return YES;
    }
    
    return [string isEmpty];
}


@end
