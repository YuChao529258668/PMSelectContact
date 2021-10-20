//
//  PMSelectContactDefine.h
//  PMSelectContact
//
//  Created by 余超 on 2021/10/20.
//

#ifndef PMSelectContactDefine_h
#define PMSelectContactDefine_h

#define kCABASE_BTN_TAG         383

#define gMCColorWithHex(hexValue, alphaValue) ([UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f green:((hexValue >> 8) & 0x000000FF)/255.0f blue:((hexValue) & 0x000000FF)/255.0 alpha:alphaValue])
#define gMCColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define gMCColorRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define gMCThemeColor gMCColorWithHex(0x5e88ff, 1.0)

#define SCREEN_WIDTH   (WIDTH_SCREEN > HEIGHT_SCREEN ? HEIGHT_SCREEN : WIDTH_SCREEN)
#define SCREEN_HEIGHT  (WIDTH_SCREEN > HEIGHT_SCREEN ? WIDTH_SCREEN : HEIGHT_SCREEN)
#define WIDTH_SCREEN ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT_SCREEN ([UIScreen mainScreen].bounds.size.height)
#define UI_SCREEN_HEIGHT        [UIScreen mainScreen].bounds.size.height
#define UI_SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width

//#define NEW_StatusBarHeight                 (IsIphoneX?44:MAX(20,[UIApplication sharedApplication].statusBarFrame.size.height))

#endif /* PMSelectContactDefine_h */
