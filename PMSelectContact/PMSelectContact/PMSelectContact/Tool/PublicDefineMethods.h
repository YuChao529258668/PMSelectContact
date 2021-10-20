//
//  PublicDefineMethods.h
//  ClassicalCloud
//
//  Created by shj on 13-7-29.
//  Copyright (c) 2013年 epro. All rights reserved.
//

//通用方法宏定义开始
//#########################CommonDefineStart#########################//
#pragma mark -
#pragma mark Common Methods Define

//#import "TDefine.h"
//对象安全释放宏定义
#define COMMON_OBJ_RELEASE(delegete)    @try\
{\
[delegete release];\
delegete = nil;\
}\
@catch(NSException *ex)\
{\
NSLog(@"Wild pointer error:%@",ex);\
}\
@finally\
{\
}

//1G
#define K1G (1024.0f*1024.0f*1024.0f*1.0f)
//4G
#define k4G (1024.0f*1024.0f*1024.0f*4.0f)
//8G
#define K8G (1024.0f*1024.0f*1024.0f*8.0f)

//iOS7
#define isiOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)

//iOS8
#define isiOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)

//iOS9
#define isiOS9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? YES : NO)

//iOS10
#define isiOS10 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) ? YES : NO)

//iOS11
#define isiOS11 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) ? YES : NO)


//v2.3版本定义的文件名格式
#define kFileNameFormatter @"yyyy-MM-dd HHmmssSSS"

//做iphone4屏幕适配
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//做iphone5屏幕适配
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//做iphone6屏幕适配
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//做iphone6+屏幕适配
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


// Y0 2015.6.4 iPad适配
#define iPhone4_Or_iPad (([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].length>0 || iPhone4)? YES : NO)

//是否是4寸以及4寸以上屏幕，适配iPhone6，iPhone6 plus
#define isScreenOverIphone4  (HEIGHT_SCREEN > 480 ? YES :NO)

//是否是4.7寸以及4.7寸以上屏幕，适配iPhone6，iPhone6 plus
#define isScreenOverIphone5  (HEIGHT_SCREEN > 568 ? YES :NO)

//4.7寸以上屏幕，适配iPhone6，iPhone6 plus
#define isScreenOverIphone6  (HEIGHT_SCREEN > 667 ? YES :NO)

//fuxiaoli 2014-2-17内存优化
#define FXL_SETTINGIMG3(imgName) (isScreenOverIphone6? ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@3x",imgName] ofType:@"png"]]):nil)

#define FXL_SETTINGIMG2(imgName) ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",imgName] ofType:@"png"]])

#define FXL_SETTINGIMG1(imgName) ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",imgName] ofType:@"png"]])

#define FXL_SETTINGIMG0(imgName) ([UIImage imageNamed:imgName])

#define FXL_SETTINGIMG(imgName) FXL_SETTINGIMG3(imgName)?FXL_SETTINGIMG3(imgName):(FXL_SETTINGIMG2(imgName)?FXL_SETTINGIMG2(imgName):(FXL_SETTINGIMG1(imgName) ? FXL_SETTINGIMG1(imgName) : FXL_SETTINGIMG0(imgName)))

#define IMGNAME(imgName) (isScreenOverIphone6 ? [NSString stringWithFormat:@"%@@3x",imgName] : [NSString stringWithFormat:@"%@@2x",imgName])

#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:IMGNAME(file) ofType:ext]]

/*
 宏方法 无缓存加载图片 适配IPhone6，6plus 大小 zhaozhifei
 */

#define BUNDLEPNGIMG(imgName) LOADIMAGE(imgName,@"png")
#define BUNDLEJPGIMG(imgName) LOADIMAGE(imgName,@"jpg")


//获取版本号
#define GET_VERSION_NUMBER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


//做文字居中，left，right版本的适配
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
#define kLabelAlignmentCenter NSTextAlignmentCenter
#define kLabelAlignmentLeft NSTextAlignmentLeft
#define kLabelAlignmentRight  NSTextAlignmentRight
#define kLabelTruncationTail  NSLineBreakByTruncatingTail
#define kLabelTruncationMiddle  NSLineBreakByTruncatingMiddle
#else
#define kLabelAlignmentCenter  UITextAlignmentCenter
#define kLabelAlignmentLeft UITextAlignmentLeft
#define kLabelAlignmentRight  UITextAlignmentRight
#define kLabelTruncationTail  UILineBreakModeTailTruncation
#define kLabelTruncationMiddle  UILineBreakModeMiddleTruncation

#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
#define kNSLineBreakByCharWrapping  NSLineBreakByCharWrapping
#define kNSLineBreakByWordWrapping  NSLineBreakByWordWrapping
#define kUILineBreakModeClip NSLineBreakByClipping
#define kUILineBreakModeTailTruncation NSLineBreakByTruncatingTail
#else
#define kNSLineBreakByCharWrapping UILineBreakModeCharacterWrap
#define kNSLineBreakByWordWrapping UILineBreakModeWordWrap
#define kUILineBreakModeClip UILineBreakModeClip
#define kUILineBreakModeTailTruncation UILineBreakModeTailTruncation
#endif


//#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define WIDTH_SCREEN ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT_SCREEN ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_WIDTH   (WIDTH_SCREEN > HEIGHT_SCREEN ? HEIGHT_SCREEN : WIDTH_SCREEN)
#define SCREEN_HEIGHT  (WIDTH_SCREEN > HEIGHT_SCREEN ? WIDTH_SCREEN : HEIGHT_SCREEN)

#define SCREEN_WIDTH_IPAD 1024
#define SCREEN_HEIGHT_IPAD 748

#define IPAD_VC_WIDTH 320
#define IPAD_VC_HEIGHT ([UIScreen mainScreen].bounds.size.width)


//tabBar高度
#define kBarHeight ((iPhone6)?58.0f:((iPhone6Plus)?66.0f:51.0f))
#define KTitleViewHeight 38
#define PUBLICALBUM_SELECT_MIN  1   //和拍上传图片最少选择个数
#define PUBLICALBUM_SELECT_MAX  20  //和拍上传图片最多选择个数

//通用方法宏定义结束
//#########################CommonDefineEnd#########################//





//登录模块方法宏定义开始
//#########################LoginModuleStart#########################//
#pragma mark -
#pragma mark Login Module Methods Define

//fuxiaoli 宏定义灰色和紫色 2014-7-15
#define FGrayColor [UIColor getColor:@"CCCCCC"]
//#define FPurpleColor [UIColor colorWithRed:187.0/255 green:129.0/255 blue:251.0/255 alpha:1.0f]

#define autoSizeScaleX ((SCREEN_HEIGHT > 568) ? 1.1765 : 1.0)
#define autoSizeScaleY ((SCREEN_HEIGHT > 568) ? 1.1765 : 1.0)
//登录模块通知宏定义结束
//#########################LoginModuleEnd#########################//

// 20120210 iphone6 iPhone6plus 适配 宏  songxing   start

// X Y WIDTH HEIGHT 全部动态调整
CG_INLINE CGRect
CGRectAutoMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX;
    rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width * autoSizeScaleX;
    rect.size.height = height * autoSizeScaleY;
    return rect;
}

// Y WIDTH HEIGHT 动态调整
CG_INLINE CGRect
CGRectXWHAutoMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX;
    rect.origin.y = y;
    rect.size.width = width * autoSizeScaleX;
    rect.size.height = height * autoSizeScaleY;
    return rect;
}

// Y WIDTH HEIGHT 动态调整
CG_INLINE CGRect
CGRectYWHAutoMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x;
    rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width * autoSizeScaleX;
    rect.size.height = height * autoSizeScaleY;
    return rect;
}

// X Y HEIGHT 动态调整
CG_INLINE CGRect
CGRectXYHAutoMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX;
    rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width;
    rect.size.height = height * autoSizeScaleY;
    return rect;
}
// X Y WIDTH 动态调整
CG_INLINE CGRect
CGRectXYWAutoMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX;
    rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width * autoSizeScaleX;
    rect.size.height = height;
    return rect;
}

// WIDTH HEIGHT 动态调整
CG_INLINE CGRect
CGRectWHAutoMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x;
    rect.origin.y = y;
    rect.size.width = width * autoSizeScaleX;
    rect.size.height = height * autoSizeScaleY;
    return rect;
}

// X Y 动态调整
CG_INLINE CGRect
CGRectXYAutoMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x* autoSizeScaleX;
    rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width ;
    rect.size.height = height;
    return rect;
}

// 20120510 iphone6  适配 宏  songxing   start
CG_INLINE CGRect
CGRectChangePhoneMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;

    if(HEIGHT_SCREEN > 568){
        
        rect.size.width = width * autoSizeScaleX;
        rect.size.height = height * autoSizeScaleY;
        rect.origin.x = (WIDTH_SCREEN -width * autoSizeScaleX)/2  ;
        rect.origin.y = y * autoSizeScaleY ;

    }
    else
    {
        rect.size.width = width;
        rect.size.height = height;
        rect.origin.x = x  ;
        rect.origin.y = y ;

    }
    
    return rect;
}
// -------end
// -------end
/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedDescending)
// 新手引导
#define NewComerGuideClass     MCBeginnerGuideViewController

//屏蔽和拍模块宏
#define AndPhotoShield_Flag    (1)

// 自动提示宏
#define HINT_MACRO(OBJC, KEYPATH) @(((void)OBJC.KEYPATH, #KEYPATH))
