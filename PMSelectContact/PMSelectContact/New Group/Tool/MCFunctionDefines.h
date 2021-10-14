//
//  CLFunctionDefines.h
//  CloudSDKDemo
//
//  Created by Guo on 17/1/10.
//  Copyright © 2017年 CMCC. All rights reserved.
//

#ifndef MC_FunctionDefines_h
#define MC_FunctionDefines_h

//定义一些常用的函数宏

#define gMCColorWithHex(hexValue, alphaValue) ([UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f green:((hexValue >> 8) & 0x000000FF)/255.0f blue:((hexValue) & 0x000000FF)/255.0 alpha:alphaValue])

#define gMCThemeColor gMCColorWithHex(0x5e88ff, 1.0)

#define gMCSystemFontWithSize(size) [UIFont systemFontOfSize:size]

#define gMCSystemVersionUpiOS(version) ([[UIDevice currentDevice].systemVersion compare:version options:NSNumericSearch] != NSOrderedAscending)

/// 判断是否是iPhoneX刘海屏系列,一定要主线程调用，NOTE:布局方面建议使用自动布局
//static inline BOOL MCDetectIfiPhoneXSeries() {
//    BOOL isXSeries = NO;
//    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
//        return isXSeries;
//    }
//    if (@available(iOS 11.0, *)) {
//        // FIXME: keywindow是否已经满足所有业务
//        UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
//        if ([mainWindow safeAreaInsets].bottom > 0) {
//            isXSeries = YES;
//        }
//    }
//    return isXSeries;
//}

#pragma mark - Math
#define gMCGetBiggerOne(a, b) (a > b ? a : b)
#define gMCGetSmallerOne(a, b) (a > b ? b : a)

#define gMCSystemFontWithSize(size) [UIFont systemFontOfSize:size]

#define Weakify(obj) __weak typeof(obj) weak##obj = obj
#define Strongify(obj) __strong typeof(obj) strong##obj = obj

#ifdef DEBUG
#define MCLog(...) NSLog(__VA_ARGS__)
#define DEBUGEnvironment YES
#else
#define MCLog(...)
#define DEBUGEnvironment NO
#endif

//#ifndef dispatch_main_async_safe
//#define dispatch_main_async_safe(block)\
//if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
//block();\
//} else {\
//dispatch_async(dispatch_get_main_queue(), block);\
//}
//#endif

#endif
