//
//  MCSCLoadingProgressView.h
//  139PushMail
//
//  Created by weikai on 2019/4/15.
//  Copyright © 2019 139. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MCSCLoadingProgressView : UIView

@property(nonatomic, strong) UILabel *titleLabel; //进度显示的label


 
 
/*
 * 更新进度文字
 */
- (void)updateProgress:(double)progress;

/*
 * 直接转圈，没有底部黑色的边框
 */
+ (instancetype)showClearLoadingInView:(UIView *)theView;

/*
 * 带有黑色背景框的转圈
 */
+ (instancetype)showBlackLoadingInView:(UIView *)theView;


/*
 * 带有黑色背景框的转圈+进度
 */

+ (instancetype)showBlackLoadingInView:(UIView *)theView WithProgress:(double)progress;
/*
 * 隐藏
 */
+ (void)dismissLoadingInView:(UIView *)theView;

/*
 * 邮件详情页loading
 */
+ (void)showLoadingInMailDetailView:(UIView *)theView ;
/*
 * 隐藏
 */
+ (void)dismissMailDetailLoadingInView:(UIView *)view ;





@end

NS_ASSUME_NONNULL_END
