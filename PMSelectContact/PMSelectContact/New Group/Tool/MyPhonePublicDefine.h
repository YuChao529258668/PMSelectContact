//
//  MyPhonePublicDefine.h
//  mCloud_iPhone
//
//  Created by MARVIS on 14-7-23.
//  Copyright (c) 2014年 epro. All rights reserved.
//

#import "UIColor+extend.h"
#import "PublicDefineMethods.h"

#ifndef mCloud_iPhone_MyPhonePublicDefine_h
#define mCloud_iPhone_MyPhonePublicDefine_h

/*
 对齐距离参数设置
 */

#define SELECT_A  (iPhone6 ? 15 : 10)

#define TOP_SPACE          iPhone6Plus ? 20 : SELECT_A
#define LAB_LEFT_SPACE      15
#define LAB_CENTER_SPACE    160
#define IMGVIEW_LEFT_SPACE  27.5
#define BTN_LEFT_SPACE      264

#define MARKER_LAB_DISTANCE 5

#define NUM_LAB_WIDTH       55
#define NUM_LAB_HEIGHT      25

#define UNITAB_LAB_DISTANCE (isScreenOverIphone6 ? 19 : 16)
#define UNITBK_LAB_DISTANCE  16
/*
   UI custom frame
 */
#define NOMALSWITCH_X_DISTANCE (isScreenOverIphone5 ? 0 : 8)

#define  NOMALSWITCH_FRAME  CGRectAutoMake(BTN_LEFT_SPACE - NOMALSWITCH_X_DISTANCE, TOP_SPACE - 4, 41,25)
#define  CUSTOMSWITCH_FRAME  CGRectAutoMake(BTN_LEFT_SPACE  , TOP_SPACE , 41,25)

/*
 animation time and font size
 */

#define ONETIME_DURATION 1.0

#define VIEWDISMISS_DURATION 0.5

#define FONTSIZE(size)  [UIFont systemFontOfSize:size]

#define NUMBER_LABEL_FONT   isScreenOverIphone5 ? FONTSIZE(23) : FONTSIZE(22) //同步变化数字lab字体大小
#define LAB_BIG_FONT        isScreenOverIphone5 ? FONTSIZE(17) : FONTSIZE(16) //相册或通讯录类别lab
#define LAB_MID_FONT        isScreenOverIphone5 ? FONTSIZE(15) : FONTSIZE(14) //自动同步/备份lab
#define MARKER_LAB_FONT     isScreenOverIphone5 ? FONTSIZE(13) : FONTSIZE(12) //单位，注释labfont。

#define ONLYWIFI_LAB_FONT   isScreenOverIphone5 ? FONTSIZE(11) : FONTSIZE(10) //单位，注释labfont。
/*
 custom Colors
 */

#define   MARKER_LAB_COLOR [UIColor getColor:@"999999"]

#define DYNAMIC_NUM_LAB_COLOR [UIColor getColor:@"5700B8"]

#define NUMLAB_NOMAL_COLOR [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:0.9]


typedef enum
{
    Lable_Type_Of_Cloud = 11,
    Lable_Type_Of_Local,
    
}Lable_Type;

#define LAB_TEXTNUM_ZERO @"0"

#define LAB_TEXTNUM_BELOWZERO @"-1"

//#######  addressbook define
#define AddressBook_NumOnIphone_UP_frame  CGRectAutoMake(LAB_CENTER_SPACE , isScreenOverIphone4? 136/2:50,120, isScreenOverIphone4?140/2:120/2)

#define AB_DOWN_FRAME_Y (iPhone4 ? 50 : (iPhone5 ? 70 : (iPhone6 ?  60: 55)))

#define AddressBook_NumOnCloudLab_DOWN_frame  CGRectAutoMake(LAB_CENTER_SPACE ,\
AB_DOWN_FRAME_Y + self.normalInfoViewUp.frame.size.height,\
120, isScreenOverIphone4?140/2:120/2)

//#define MessageBeginLab_frame  CGRectMake(LAB_CENTER_SPACE , 100,  150, 80)

//#define MergeFrame CGRectMake(LAB_CENTER_SPACE , isScreenOverIphone4?224/2:224/2-30,120, isScreenOverIphone4?140/2:120/2)


#define AB_NUMLAB_COLORFUL_COLOR [UIColor colorWithRed:67/255.0 green:0/255.0 blue:169/255.0 alpha:1.0]

#define  USERSYNABEVENT_TITLE @"synABEventTitle"
#define  USERSYNABEVENT_TIME  @"synABEventTime"

//#######  photoBackUp define

#define ANI_DURATION 0.5

#define MyPhone_NumOnIphone_UP_frame  CGRectAutoMake(LAB_CENTER_SPACE , isScreenOverIphone4? 136/2:50,90, isScreenOverIphone4?128/2:120/2)

#define MyPhone_NumOnCloudLab_DOWN_frame  CGRectAutoMake(LAB_CENTER_SPACE ,\
(isScreenOverIphone4? 154/2:50) + self.normalInfoViewUp.frame.size.height,\
90, isScreenOverIphone4?128/2:120/2)

#define MergeFrame CGRectAutoMake(LAB_CENTER_SPACE , isScreenOverIphone4?224/2:224/2-30,120, isScreenOverIphone4?140/2:120/2)

#define UPBUTTONFRAME  CGRectAutoMake(BTN_LEFT_SPACE, (isScreenOverIphone4 ? 72 : 51), 41, 41);

#define DOWNBUTTONFRAME  CGRectAutoMake(BTN_LEFT_SPACE ,(isScreenOverIphone4? 146 : 117), 41, 41)


#define  USERBACKUPEVENT_TITLE @"backUpEventTitle"
#define  USERBACKUPEVENT_TIME  @"backupEventTime"

//#######  MyphoneBackUpVC define

#define AlertSynTag                 110//本地数量变化大，是否继续同步
#define AlertSynCloudTag            120//云端数量变化大，是否继续同步
#define AlertDownTag                130//下载提示覆盖
#define AlertUploadTag              140//上传载提示覆盖
#define AlertSynSwitch              150//通讯录同步，暂时弃用
#define AlertLowPowerTag            160//低电量提示AlertTag,暂时弃用

#define AlertCloseABPush            170//关闭通讯录通知提示AlertTag

#define AlertCloseBackUpSwitch      180//关闭相册备份开关提示
#define AlertCloseABSynSwitch       190//关闭通讯录自动同步开关提示

#define AlertDeleteBackupedPhotoTag 200//删除本地已备份相册提示

#define AlertOpenBackUpSwitch      210//开启相册备份开关提示


//###### createAlbumVC define

#define kCABASE_BTN_TAG         383

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];

#define TITLE_COLOR  RGB(4,4,4)
#endif





