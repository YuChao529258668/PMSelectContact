//
//  PMSCToastView.h
//  139PushMail
//
//  Created by weikai on 2019/3/19.
//  Copyright © 2019 139. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PMSCToastViewPosition) {
    PMSCToastViewPosition_center,
    PMSCToastViewPosition_bottom
};

@interface PMSCToastView : UIView


//默认PMSCToastViewPosition_bottom
@property (nonatomic, assign) PMSCToastViewPosition position;

+ (instancetype)shareInstance;

//默认底部
- (void)showInView:(UIView *)theView withText:(NSString *)text hideDelay:(NSTimeInterval)delay;
/// theView 为 nil， 就显示在 window
+ (void)showInView:(UIView *)theView withText:(NSString *)text hideDelay:(NSTimeInterval)delay;
/// 显示在 window，1.5 秒后隐藏
+ (void)showText:(NSString *)text;
// 居中显示在顶部导航栏
- (void)showOnTopWithText:(NSString *)text hideDelay:(NSTimeInterval)delay;
+ (void)showOnTopWithText:(NSString *)text hideDelay:(NSTimeInterval)delay;

/// 特殊场景下，为了避免遮挡需要将toast展示在键盘上
+ (void)showOnKeyboardWithText:(NSString *)text;
/**
 底部显示text
 */
+ (void)showWithText:(NSString *)text;

+ (void)toastWithText:(NSString *)text;

@end
