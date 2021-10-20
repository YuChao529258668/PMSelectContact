//
//  PMMCAlertView.m
//  mCloud_iPhone
//
//  Created by 潘天乡 on 05/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import "PMMCAlertView.h"
#import <objc/runtime.h>

NSString *MCAlertViewDidShowNotification = @"MCAlertViewDidShowNotification";
NSString *MCAlertViewDidHideNotification = @"MCAlertViewDidHideNotification";

#define MCA_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MCA_ScreenHeight [UIScreen mainScreen].bounds.size.height

#define gMCColorWithHex(hexValue, alphaValue) ([UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f green:((hexValue >> 8) & 0x000000FF)/255.0f blue:((hexValue) & 0x000000FF)/255.0 alpha:alphaValue])


static const CGFloat contentViewWidth = 311.0;
static const CGFloat buttonHeight = 48.0; //按钮高度

@interface PMMCAlertView () <UITextViewDelegate>

/// Tap dimiss gesture
@property (nonatomic, strong) UITapGestureRecognizer *tapToDismissGesture;


@end

@implementation PMMCAlertView

+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                              contentView:(UIView *)customContent
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle {
    PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                   message:message
                                               contentView:customContent
                                           leftButtonTitle:leftButtonTitle
                                          rightButtonTitle:rightButtonTitle];
    return view;
}

+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle {
    PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                   message:message
                                           leftButtonTitle:leftButtonTitle
                                          rightButtonTitle:rightButtonTitle];
    return view;
}
+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle
                          isHaveClose:(BOOL)isHaveClose
{
    PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                   message:message
                                           leftButtonTitle:leftButtonTitle
                                          rightButtonTitle:rightButtonTitle
                                               isHaveClose:isHaveClose];
    return view;
}
+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle
                          isHaveClose:(BOOL)isHaveClose
                          isMaxHeight:(BOOL)isMaxHeight
{
    PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                   message:message
                                           leftButtonTitle:leftButtonTitle
                                          rightButtonTitle:rightButtonTitle
                                               isHaveClose:isHaveClose
                                               isMaxHeight:isMaxHeight];
    return view;
}
+ (instancetype)popAlertViewWithTitle:(NSString *)title
                                  message:(NSString *)message
                          leftButtonTitle:(NSString *)leftButtonTitle
                         rightButtonTitle:(NSString *)rightButtonTitle
                                isPopView:(BOOL)isPopView{
    PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                   message:message
                                           leftButtonTitle:leftButtonTitle
                                          rightButtonTitle:rightButtonTitle
                                                 isPopView:(BOOL)isPopView];
    return view;
}

//+ (instancetype)popInputAlertViewWithTitle:(NSString *)title inputText:(NSString *)inputText leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle {
//    PMMCAlertView *view = [[PMMCAlertView alloc] initWithInputTitle:title inputText:inputText leftButtonTitle:leftButtonTitle rightButtonTitle:rightButtonTitle];
//    return view;
//}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)leftButtonTitle
             rightButtonTitle:(NSString *)rightButtonTitle {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0.0, 0.0, MCA_ScreenWidth, MCA_ScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [[self fetchWindow] addSubview:self];
        
        // 添加消失手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tap];
        self.tapToDismissGesture = tap;
        self.enableTapToDimiss = NO;
        
        
        //有标题和没标题分两种布局
        CGFloat contentViewHeight = 0.0;
        UIColor *titleColor = nil;
        UIColor *messageColor = nil;
        UIFont *titleFont = nil;
        UIFont *messageFont = nil;
        // message的尺寸
        CGSize messageSize;
        if ([self isExistString:title]) {
            messageSize = [self getStringBoundsWithString:message font:13]; // 获取message的尺寸
            if (messageSize.height >= 3 * 13) { //如果超过两行，则contentView需要增加额外的高度
                NSInteger extendLine = (NSInteger)((messageSize.height - 2 * 13) / 13); //超出的额外行数
                contentViewHeight = 165.0 + extendLine * 13.f;
            }else {
                contentViewHeight = 165.0;
            }
            
            titleColor = gMCColorWithHex(0x000A18, 1.0);
            messageColor = gMCColorWithHex(0x000A18, 1.0);
            titleFont = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
            messageFont = [UIFont systemFontOfSize:13.0];
        }else {
            messageSize = [self getStringBoundsWithString:message font:16];
            contentViewHeight = messageSize.height + 25 + 25 + 48;
            messageColor = gMCColorWithHex(0x000A18, 1.0);
            messageFont = [UIFont systemFontOfSize:16.0];
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - contentViewWidth) / 2, (MCA_ScreenHeight - contentViewHeight) / 2, contentViewWidth, contentViewHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 16.0;
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;
        
        CGFloat messageLabelY = 25.0;
        if ([self isExistString:title]) {
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 16.0, CGRectGetWidth(contentView.frame) - 2 * 10.0, 44.0)];
            self.titleLabel = titleLabel;
            titleLabel.font = titleFont;
            titleLabel.textColor = titleColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            titleLabel.text = title;
            [contentView addSubview:titleLabel];
            
            messageLabelY = CGRectGetMaxY(titleLabel.frame) + 6.0;
        }
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, messageLabelY, CGRectGetWidth(contentView.frame) - 2 * 10.0, messageSize.height+5)];
        self.messageLabel = messageLabel;
        messageLabel.font = messageFont;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = messageColor;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = message;
        [contentView addSubview:messageLabel];
        
        UIView *buttonsView = [self createButtonViewWithLeftTitle:leftButtonTitle rightTitle:rightButtonTitle];
        self.bottomView = buttonsView;
        if (buttonsView) {
            [contentView addSubview:buttonsView];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MCAlertViewDidShowNotification object:nil];
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)leftButtonTitle
             rightButtonTitle:(NSString *)rightButtonTitle
                  isHaveClose:(BOOL)isHaveClose
                  isMaxHeight:(BOOL)isMaxHeight
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0.0, 0.0, MCA_ScreenWidth, MCA_ScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [[self fetchWindow] addSubview:self];
        
        // 添加消失手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tap];
        self.tapToDismissGesture = tap;
        self.enableTapToDimiss = NO;
        
        
        //有标题和没标题分两种布局
        CGFloat contentViewHeight = 0.0;
        UIColor *titleColor = nil;
        UIColor *messageColor = nil;
        UIFont *titleFont = nil;
        UIFont *messageFont = nil;
        // message的尺寸
        CGSize messageSize;
        if ([self isExistString:title]) {
            messageSize = [self getStringBoundsWithString:message font:13]; // 获取message的尺寸
            if (messageSize.height >= 3 * 13) { //如果超过两行，则contentView需要增加额外的高度
                NSInteger extendLine = (NSInteger)((messageSize.height - 2 * 13) / 13); //超出的额外行数
                contentViewHeight = 165.0 + extendLine * 13.f;
                if (isMaxHeight) {
                    contentViewHeight = 165.0;
                    messageSize = CGSizeMake(291, 165-66-50);
                }
            }else {
                contentViewHeight = 165.0;
            }
            
            titleColor = gMCColorWithHex(0x000A18, 1.0);
            messageColor = gMCColorWithHex(0x000A18, 1.0);
            titleFont = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
            messageFont = [UIFont systemFontOfSize:13.0];
        }else {
            messageSize = [self getStringBoundsWithString:message font:16];
            contentViewHeight = messageSize.height + 25 + 25 + 48;
            messageColor = gMCColorWithHex(0x000A18, 1.0);
            messageFont = [UIFont systemFontOfSize:16.0];
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - contentViewWidth) / 2, (MCA_ScreenHeight - contentViewHeight) / 2, contentViewWidth, contentViewHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 16.0;
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;
        
        if (isHaveClose) {
            UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - contentViewWidth) / 2+contentViewWidth-50, (MCA_ScreenHeight - contentViewHeight) / 2 , 50, 40)];
            [cancelBtn setImage:[UIImage imageNamed:@"close_alert_icon"] forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancelBtn];
        }
        
        CGFloat messageLabelY = 25.0;
        if ([self isExistString:title]) {
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 16.0, CGRectGetWidth(contentView.frame) - 2 * 10.0, 44.0)];
            self.titleLabel = titleLabel;
            titleLabel.font = titleFont;
            titleLabel.textColor = titleColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            titleLabel.text = title;
            [contentView addSubview:titleLabel];
            
            messageLabelY = CGRectGetMaxY(titleLabel.frame) + 6.0;
        }
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, messageLabelY, CGRectGetWidth(contentView.frame) - 2 * 10.0, messageSize.height+5)];
        self.messageLabel = messageLabel;
        messageLabel.font = messageFont;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = messageColor;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = message;
        [contentView addSubview:messageLabel];
        
        UIView *buttonsView = [self createButtonViewWithLeftTitle:leftButtonTitle rightTitle:rightButtonTitle];
        self.bottomView = buttonsView;
        if (buttonsView) {
            [contentView addSubview:buttonsView];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MCAlertViewDidShowNotification object:nil];
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)leftButtonTitle
             rightButtonTitle:(NSString *)rightButtonTitle
                  isHaveClose:(BOOL)isHaveClose{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0.0, 0.0, MCA_ScreenWidth, MCA_ScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [[self fetchWindow] addSubview:self];
        
        // 添加消失手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tap];
        self.tapToDismissGesture = tap;
        self.enableTapToDimiss = NO;
        
        
        //有标题和没标题分两种布局
        CGFloat contentViewHeight = 0.0;
        UIColor *titleColor = nil;
        UIColor *messageColor = nil;
        UIFont *titleFont = nil;
        UIFont *messageFont = nil;
        // message的尺寸
        CGSize messageSize;
        if ([self isExistString:title]) {
            messageSize = [self getStringBoundsWithString:message font:13]; // 获取message的尺寸
            if (messageSize.height >= 3 * 13) { //如果超过两行，则contentView需要增加额外的高度
                NSInteger extendLine = (NSInteger)((messageSize.height - 2 * 13) / 13); //超出的额外行数
                contentViewHeight = 165.0 + extendLine * 13.f;
            }else {
                contentViewHeight = 165.0;
            }
            
            titleColor = gMCColorWithHex(0x000A18, 1.0);
            messageColor = gMCColorWithHex(0x000A18, 1.0);
            titleFont = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
            messageFont = [UIFont systemFontOfSize:13.0];
        }else {
            messageSize = [self getStringBoundsWithString:message font:16];
            contentViewHeight = messageSize.height + 25 + 25 + 48;
            messageColor = gMCColorWithHex(0x000A18, 1.0);
            messageFont = [UIFont systemFontOfSize:16.0];
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - contentViewWidth) / 2, (MCA_ScreenHeight - contentViewHeight) / 2, contentViewWidth, contentViewHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 16.0;
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;
        
        if (isHaveClose) {
            UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - contentViewWidth) / 2+contentViewWidth-50, (MCA_ScreenHeight - contentViewHeight) / 2 , 50, 40)];
            [cancelBtn setImage:[UIImage imageNamed:@"close_alert_icon"] forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancelBtn];
        }
        
        CGFloat messageLabelY = 25.0;
        if ([self isExistString:title]) {
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 16.0, CGRectGetWidth(contentView.frame) - 2 * 10.0, 44.0)];
            self.titleLabel = titleLabel;
            titleLabel.font = titleFont;
            titleLabel.textColor = titleColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            titleLabel.text = title;
            [contentView addSubview:titleLabel];
            
            messageLabelY = CGRectGetMaxY(titleLabel.frame) + 6.0;
        }
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, messageLabelY, CGRectGetWidth(contentView.frame) - 2 * 10.0, messageSize.height+5)];
        self.messageLabel = messageLabel;
        messageLabel.font = messageFont;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = messageColor;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = message;
        [contentView addSubview:messageLabel];
        
        UIView *buttonsView = [self createButtonViewWithLeftTitle:leftButtonTitle rightTitle:rightButtonTitle];
        self.bottomView = buttonsView;
        if (buttonsView) {
            [contentView addSubview:buttonsView];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MCAlertViewDidShowNotification object:nil];
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)leftButtonTitle
             rightButtonTitle:(NSString *)rightButtonTitle
                    isPopView:(BOOL)isPopView{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0.0, 0.0, MCA_ScreenWidth, MCA_ScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [[self fetchWindow] addSubview:self];
        
        // 添加消失手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tap];
        self.tapToDismissGesture = tap;
        self.enableTapToDimiss = NO;
        
        
        //有标题和没标题分两种布局
        CGFloat contentViewHeight = 0.0;
        UIColor *titleColor = nil;
        UIColor *messageColor = nil;
        UIFont *titleFont = nil;
        UIFont *messageFont = nil;
        // message的尺寸
        CGSize messageSize;
        if ([self isExistString:title]) {
            messageSize = [self getStringBoundsWithString:message font:13]; // 获取message的尺寸
            if (messageSize.height >= 3 * 13) { //如果超过两行，则contentView需要增加额外的高度
                NSInteger extendLine = (NSInteger)((messageSize.height - 2 * 13) / 13); //超出的额外行数
                contentViewHeight = 165.0 + extendLine * 13.f;
            }else {
                contentViewHeight = 165.0;
            }
            
            titleColor = gMCColorWithHex(0x000A18, 1.0);
            messageColor = gMCColorWithHex(0x000A18, 1.0);
            titleFont = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
            messageFont = [UIFont systemFontOfSize:13.0];
        }else {
            messageSize = [self getStringBoundsWithString:message font:16];
            contentViewHeight = messageSize.height + 25 + 25 + 48;
            messageColor = gMCColorWithHex(0x000A18, 1.0);
            messageFont = [UIFont systemFontOfSize:16.0];
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - contentViewWidth) / 2, (MCA_ScreenHeight - contentViewHeight) / 2, contentViewWidth, contentViewHeight+5)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 16.0;
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;
        
        CGFloat messageLabelY = 25.0;
        if ([self isExistString:title]) {
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 16.0, CGRectGetWidth(contentView.frame) - 2 * 10.0, 44.0)];
            self.titleLabel = titleLabel;
            titleLabel.font = titleFont;
            titleLabel.textColor = titleColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            titleLabel.text = title;
            [contentView addSubview:titleLabel];
            
            messageLabelY = CGRectGetMaxY(titleLabel.frame) + 6.0;
        }
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, messageLabelY, CGRectGetWidth(contentView.frame) - 2 * 10.0, messageSize.height+5)];
        self.messageLabel = messageLabel;
        messageLabel.font = messageFont;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = messageColor;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = message;
        [contentView addSubview:messageLabel];
        
        UIView *buttonsView = [self createButtonViewWithLeftTitle:leftButtonTitle rightTitle:rightButtonTitle];
        self.bottomView = buttonsView;
        if (buttonsView) {
            [contentView addSubview:buttonsView];
        }
        if(isPopView){
            self.isPopView = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:MCAlertViewDidShowNotification object:nil];
        }
    }
    return self;
}



- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                  contentView:(UIView *)customContent
              leftButtonTitle:(NSString *)leftButtonTitle
             rightButtonTitle:(NSString *)rightButtonTitle {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0.0, 0.0, MCA_ScreenWidth, MCA_ScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [[self fetchWindow] addSubview:self];
        
        // 添加消失手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tap];
        self.tapToDismissGesture = tap;
        self.enableTapToDimiss = NO;
        
        //有标题和没标题分两种布局
        CGFloat contentViewHeight = 0.0;
        UIColor *titleColor = nil;
        UIColor *messageColor = nil;
        UIFont *titleFont = nil;
        UIFont *messageFont = nil;
        // message的尺寸
        CGSize messageSize;
        if ([self isExistString:title]) {
            messageSize = [self getStringBoundsWithString:message font:13]; // 获取message的尺寸
            if (messageSize.height >= 3 * 13) { //如果超过两行，则contentView需要增加额外的高度
                NSInteger extendLine = (NSInteger)((messageSize.height - 2 * 13) / 13); //超出的额外行数
                contentViewHeight = 165.0 + extendLine * 13.f;
            }else {
                contentViewHeight = 165.0;
            }
            
            titleColor = gMCColorWithHex(0x000A18, 1.0);
            messageColor = gMCColorWithHex(0x000A18, 1.0);
            titleFont = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
            messageFont = [UIFont systemFontOfSize:13.0];
        }else {
            messageSize = [self getStringBoundsWithString:message font:16];
            contentViewHeight = messageSize.height + 25 + 25 + 48;
            messageColor = gMCColorWithHex(0x000A18, 1.0);
            messageFont = [UIFont systemFontOfSize:16.0];
        }
        
        contentViewHeight += 40;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - contentViewWidth) / 2, (MCA_ScreenHeight - contentViewHeight) / 2, contentViewWidth, contentViewHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 16.0;
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;
        
        CGFloat messageLabelY = 25.0;
        if ([self isExistString:title]) {
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 16.0, CGRectGetWidth(contentView.frame) - 2 * 10.0, 44.0)];
            self.titleLabel = titleLabel;
            titleLabel.font = titleFont;
            titleLabel.textColor = titleColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            titleLabel.text = title;
            [contentView addSubview:titleLabel];
            
            messageLabelY = CGRectGetMaxY(titleLabel.frame) + 6.0;
        }
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, messageLabelY, CGRectGetWidth(contentView.frame) - 2 * 10.0, messageSize.height+5)];
        self.messageLabel = messageLabel;
        messageLabel.font = messageFont;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = messageColor;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = message;
        [contentView addSubview:messageLabel];
        
        UIView *buttonsView = [self createButtonViewWithLeftTitle:leftButtonTitle rightTitle:rightButtonTitle];
        self.bottomView = buttonsView;
        if (buttonsView) {
            [contentView addSubview:buttonsView];
        }
        
        // 自定义内容视图
        if(customContent) {
            CGFloat customViewHeight = 40.f;
            self.customContentView = customContent;
            customContent.frame = CGRectMake(0, CGRectGetMinY(buttonsView.frame) - customViewHeight-10, CGRectGetWidth(contentView.frame), customViewHeight);
            [contentView addSubview:customContent];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MCAlertViewDidShowNotification object:nil];
    }
    return self;
}

//- (instancetype)initWithInputTitle:(NSString *)title
//                         inputText:(NSString *)inputText
//              leftButtonTitle:(NSString *)leftButtonTitle
//             rightButtonTitle:(NSString *)rightButtonTitle {
//    self = [super init];
//    if (self) {
//        self.frame = CGRectMake(0.0, 0.0, MCA_ScreenWidth, MCA_ScreenHeight);
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
//        [[self fetchWindow] addSubview:self];
//
//        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 270) / 2, MCA_ScreenHeight * 0.2069, 270, 227)];
//        contentView.backgroundColor = [UIColor whiteColor];
//        contentView.layer.cornerRadius = 16.0;
//        contentView.clipsToBounds = YES;
//        [self addSubview:contentView];
//        self.contentView = contentView;
//
//        CGFloat textViewY = 25.0;
//        if ([self isExistString:title]) {
//            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 16.0, CGRectGetWidth(contentView.frame) - 2 * 10.0, 44.0)];
//            self.titleLabel = titleLabel;
//            titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
//            titleLabel.textColor = gMCColorWithHex(0x000A18, 1.0);
//            titleLabel.textAlignment = NSTextAlignmentCenter;
//            titleLabel.numberOfLines = 0;
//            titleLabel.text = title;
//            [contentView addSubview:titleLabel];
//
//            textViewY = CGRectGetMaxY(titleLabel.frame) + 14.0;
//        }
//
//        MCPlaceholderTextView *inputTextView = [[MCPlaceholderTextView alloc] initWithFrame:CGRectMake(24, textViewY, 222, 92)];
//        self.inputTextView = inputTextView;
//        inputTextView.backgroundColor = gMCColorWithHex(0x000A18, 0.05);
//        if (inputText.length <= 0) {
//            inputTextView.placeholder = @"与好友分享您此时的心情";
//        } else {
//            inputTextView.placeholder = @"";
//        }
//        inputTextView.text = inputText;
//        inputTextView.placeColor = gMCColorWithHex(0x000A18, 0.25);
//        inputTextView.textColor = gMCColorWithHex(0x000A18, 1.0);
//        inputTextView.font = [UIFont systemFontOfSize:16];
//        inputTextView.delegate = self;
//        [inputTextView becomeFirstResponder];
//        [contentView addSubview:inputTextView];
//
//        UIView *buttonsView = [self createButtonViewWithLeftTitle:leftButtonTitle rightTitle:rightButtonTitle];
//        self.bottomView = buttonsView;
//        if (buttonsView) {
//            [contentView addSubview:buttonsView];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:MCAlertViewDidShowNotification object:nil];
//    }
//    return self;
//}


#pragma mark - UI
/**
 *  1.存在两个button, 两个buton的宽度均分contentView的宽度。
 *  2.只存在一个button, 则占整个contentView的宽度。
 *  3.按钮标题颜色默认为主题蓝
 */
- (UIView *)createButtonViewWithLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle {
    if (![self isExistString:leftTitle] && ![self isExistString:rightTitle]) {
        return nil;
    }
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(_contentView.frame) - buttonHeight, CGRectGetWidth(_contentView.frame), buttonHeight)];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_contentView.frame), 0.5)];
    topLine.backgroundColor = gMCColorWithHex(0x000A18, 0.05);
    [buttonsView addSubview:topLine];
    
    if ([self isExistString:leftTitle] && [self isExistString:rightTitle]) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(buttonsView.frame) / 2, buttonHeight);
        [leftButton setTitleColor:gMCColorWithHex(0x000A18, 0.5) forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:leftButton];
        self.leftButton = leftButton;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(CGRectGetMaxX(leftButton.frame), 0.0, CGRectGetWidth(buttonsView.frame) / 2, buttonHeight);
        [rightButton setTitleColor:gMCColorWithHex(0x0065F2, 1.0) forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        [rightButton setTitle:rightTitle forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:rightButton];
        self.rightButton = rightButton;
        
        UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(buttonsView.frame) / 2, 0.0, 0.5, buttonHeight)];
        middleLine.backgroundColor = gMCColorWithHex(0x000A18, 0.05);
        [buttonsView addSubview:middleLine];
    }else {
        NSString *buttonTitle = [self isExistString:leftTitle] ? leftTitle : rightTitle;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(buttonsView.frame), buttonHeight);
        [leftButton setTitleColor:gMCColorWithHex(0x0065F2, 1.0) forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        [leftButton setTitle:buttonTitle forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(singleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:leftButton];
        self.leftButton = leftButton;
    }
    
    return buttonsView;
}
- (void)cancelBtnAction
{
    NSLog(@"cancelBtnAction");
    [self dismiss];
}
- (void)dismiss {
    [[NSNotificationCenter defaultCenter] postNotificationName:MCAlertViewDidHideNotification object:nil];
    self.isPopView = NO;
    [self removeFromSuperview];
}

-(void)popAlertView{
    self.isPopView = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:MCAlertViewDidShowNotification object:nil];
}

#pragma mark - Public

- (void)setEnableTapToDimiss:(BOOL)enableTapToDimiss {
    _enableTapToDimiss = enableTapToDimiss;
    _tapToDismissGesture.enabled = enableTapToDimiss;
}

#pragma mark - Event Handler
- (void)leftButtonAction:(id)sender {
    [self invokeDelegateWithIndex:0];
    if (self.leftButtonClickBlock) {
        self.leftButtonClickBlock();
    }
    if (!self.isDecompression) {//非云解压可以点击按钮后消失弹窗
        [self dismiss];
    }
}

- (void)rightButtonAction:(id)sender {
    [self invokeDelegateWithIndex:1];
    if (self.rightButtonClickBlock) {
        self.rightButtonClickBlock();
    }
    [self dismiss];
}

- (void)singleButtonAction:(id)sender {
    [self invokeDelegateWithIndex:0];
    if (self.rightButtonClickBlock) {
        self.rightButtonClickBlock();
    }
    [self dismiss];
}

- (void)invokeDelegateWithIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:didClickAtIndex:)]) {
        [_delegate alertView:self didClickAtIndex:index];
    }
}

- (void)setLeftButtonTitleColor:(UIColor *)leftButtonTitleColor {
    _leftButtonTitleColor = leftButtonTitleColor;
    
    if (self.leftButton) {
        [self.leftButton setTitleColor:leftButtonTitleColor forState:UIControlStateNormal];
    }
}

- (void)setLeftButtonTitleFont:(UIFont *)leftButtonTitleFont
{
    _leftButtonTitleFont = leftButtonTitleFont;
    if (self.leftButton) {
        self.leftButton.titleLabel.font = leftButtonTitleFont;
    }
}

- (void)setRightButtonTitleColor:(UIColor *)rightButtonTitleColor {
    _rightButtonTitleColor = rightButtonTitleColor;
    
    if (self.rightButton) {
        [self.rightButton setTitleColor:rightButtonTitleColor forState:UIControlStateNormal];
    }
}

- (void)setRightButtonTitleFont:(UIFont *)rightButtonTitleFont
{
    _rightButtonTitleFont = rightButtonTitleFont;
    if (self.rightButton) {
        self.rightButton.titleLabel.font = rightButtonTitleFont;
    }
}

- (void)handleGesture:(UITapGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:tap.view];
    if (CGRectContainsPoint(_contentView.frame, location)) return;
    [self dismiss];
}

#pragma mark - Private
- (UIView *)fetchWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

- (BOOL)isExistString:(NSString *)string {
    return string && string.length > 0;
}

- (void)setTitlefontSize:(CGFloat)titlefontSize{
    _titlefontSize = titlefontSize;
    if (self.titleLabel) {
        self.titleLabel.font = [UIFont systemFontOfSize:titlefontSize];
    }
}

- (void)setMessageFontSize:(CGFloat)messageFontSize{
    _messageFontSize = messageFontSize;
    if (self.messageLabel) {
        self.messageLabel.font = [UIFont systemFontOfSize:messageFontSize];
        
        CGRect newFrame = self.messageLabel.frame;
        newFrame.size.height = self.messageLabel.font.lineHeight * 2;
        self.messageLabel.frame = newFrame;
    }
}

- (void)setMessageHeight:(CGFloat)messageHeight{
    _messageHeight = messageHeight;
    if (self.messageLabel) {
        self.messageLabel.numberOfLines = 0;
        CGRect frame = self.messageLabel.frame;
        frame.size.height = messageHeight;
        self.messageLabel.frame =  frame;
        frame = self.bottomView.frame;
        frame.origin.y = (CGRectGetMaxY(self.messageLabel.frame) +20);
        self.bottomView.frame = frame;
        frame = self.contentView.frame;
        frame.size.height = CGRectGetMaxY(self.bottomView.frame);
        self.contentView.frame = frame;
    }
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    if (self.titleLabel) {
        self.titleLabel.textColor = titleColor;
    }
}

- (void)setMessageColor:(UIColor *)messageColor{
    _messageColor = messageColor;
    if (self.messageLabel) {
        self.messageLabel.textColor = messageColor;
    }
}

- (void)setMessage:(NSString *)message {
    _messageLabel.text = message;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    if (_messageLabel) {
        _messageLabel.textAlignment = textAlignment;
    }
}

// 获取字符串的高宽
- (CGSize)getStringBoundsWithString:(NSString *)string font:(NSInteger)font{
    NSDictionary *attr=@{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    return [string boundingRectWithSize:CGSizeMake(291,200) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attr context:nil].size;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if(selectedRange && pos) {return;}
    if((unsigned long)textView.text.length > 30) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewOverMaxInputLength)]) {
            [self.delegate textViewOverMaxInputLength];
        }
        // 对超出的部分进行剪切
        textView.text= [textView.text substringToIndex:30];
    }
}

@end

@implementation PMMCAlertView (MCloudAddition)

+ (instancetype)popAlertViewWithTitle:(NSString *)title message:(NSString *)message detailMessage:(NSString *)detailMessage leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle {
    PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                   message:message
                                           leftButtonTitle:leftButtonTitle
                                          rightButtonTitle:rightButtonTitle];
    // 添加一个Detail Message label
    UILabel *detailMessageLabel = nil;
    if (detailMessage.length > 0) {
        detailMessageLabel = [[UILabel alloc] init];
        detailMessageLabel.font = [UIFont boldSystemFontOfSize:14.f];
        detailMessageLabel.textColor = [UIColor colorWithRed:1.0 green:114/255.0 blue:91/255.0 alpha:1.0];
        detailMessageLabel.text = detailMessage;
        detailMessageLabel.textAlignment = NSTextAlignmentCenter;
        [view setDetailMessageLabel:detailMessageLabel];
        [view.contentView addSubview:detailMessageLabel];
    }
    // 重新布局...
    // 1.Content view
    CGRect contentViewFrame = view.contentView.frame;
    // 2.Title
    view.titleLabel.frame = CGRectMake(0, 24.f, CGRectGetWidth(view.contentView.frame), view.titleLabel.font.lineHeight);
    // 3.Message label
    view.messageLabel.frame = CGRectMake(20.0, CGRectGetMaxY(view.titleLabel.frame) + 12.f, CGRectGetWidth(view.contentView.frame) - 2 * 20.0, view.messageLabel.font.lineHeight);
    // 4.Detail message label
    view.detailMessageLabel.frame = CGRectMake(0.f, CGRectGetMaxY(view.messageLabel.frame) + 25.f, CGRectGetWidth(view.contentView.frame), view.detailMessageLabel.font.lineHeight);
    // 5.Bottom view
    CGRect bottomViewFrame = view.bottomView.frame;
    bottomViewFrame.origin.y = CGRectGetMaxY(detailMessageLabel ? view.detailMessageLabel.frame : view.messageLabel.frame) + 25.f;
    view.bottomView.frame = bottomViewFrame;
    // Update content view
    contentViewFrame.size.height = CGRectGetMaxY(bottomViewFrame);
    contentViewFrame.origin.y = (CGRectGetHeight(view.frame) - CGRectGetHeight(contentViewFrame)) * 0.5;
    view.contentView.frame = contentViewFrame;
    return view;
}

+ (instancetype)popAlertViewWithAppletDict:(NSDictionary *)dict sameAccout:(BOOL)sameAccout {
    if (sameAccout) {
        NSString *title = @"查看我的文件（来自小程序）";
        NSString *message = [NSString stringWithFormat:@"路径：%@",[dict objectForKey:@"fullpath"]];
        PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                       message:message
                                               leftButtonTitle:nil
                                              rightButtonTitle:nil];
        //更改contentView的Frame
        CGRect contentViewFrame = view.contentView.frame;
        contentViewFrame.size.height = 215.f;
        contentViewFrame.origin.y = (MCA_ScreenHeight - contentViewFrame.size.height) / 2;
        view.contentView.frame = contentViewFrame;
        
        //icon
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(view.contentView.frame) - 50.f) / 2, 24.f, 50.f, 50.f)];
        iconImageView.image = [UIImage imageNamed:@"xcxfiles_toast_img"];
        iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [view.contentView addSubview:iconImageView];
        
        //title
        CGFloat titleY = message.length > 0 ? CGRectGetMaxY(iconImageView.frame) + 16.f : CGRectGetMaxY(iconImageView.frame) + 33.f;
        view.titleLabel.text = title;
        view.titleLabel.textColor = [UIColor colorWithRed:0.0 green:16.0 / 255.0 blue:38.0 / 255.0 alpha:1.f];
        if (@available(iOS 8.2, *)) {
            view.titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
        } else {
            view.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        }
        [view.titleLabel sizeToFit];
        view.titleLabel.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - CGRectGetWidth(view.titleLabel.frame)) / 2, titleY, CGRectGetWidth(view.titleLabel.frame), 22.f);
        
        //message
        if (message.length > 0) {
            view.messageLabel.text = message;
            view.messageLabel.textColor = [UIColor colorWithRed:0.0 green:16.0 / 255.0 blue:38.0 / 255.0 alpha:0.5];
            view.messageLabel.font = [UIFont systemFontOfSize:12.f];
            [view.messageLabel sizeToFit];
            view.messageLabel.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - CGRectGetWidth(view.messageLabel.frame)) / 2, CGRectGetMaxY(view.titleLabel.frame) + 8.f, CGRectGetWidth(view.messageLabel.frame), 17.f);
        }else {
            [view.messageLabel removeFromSuperview];
        }
        
        //buttonTitle
        UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomButton.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - 120.f) / 2, CGRectGetHeight(view.contentView.frame) - 24.f - 30.f, 120.f, 30.f);
        bottomButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        bottomButton.layer.cornerRadius = 15.f;
        bottomButton.backgroundColor = [UIColor colorWithRed:0.0 green:96.0 / 255.0 blue:230.0 / 255.0 alpha:1.0];
        bottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [bottomButton setTitle:@"查看文件" forState:UIControlStateNormal];
        [bottomButton addTarget:view action:@selector(bottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [view.contentView addSubview:bottomButton];
        
        return view;
    }else {
        PMMCAlertView *view = [PMMCAlertView popAlertViewWithTitle:@"温馨提示" message:@"当前账号与小程序端账号不一致，无法查看来自小程序的文件" leftButtonTitle:@"取消" rightButtonTitle:@"切换账号"];
         return view;
    }
}

+ (BOOL)isThereAlertWithIdentifiers:(NSSet *)identifiers {
    //  检查当前窗口是否已存在弹窗
    BOOL existed = NO;
    // 假设keyWindow不变（若项目存在其他window需修改）
    NSArray *views = [UIApplication sharedApplication].keyWindow.subviews;
    for (UIView *element in views) {
        if ([element isKindOfClass:[PMMCAlertView class]]) {
            PMMCAlertView *existentAlertView = (PMMCAlertView *)element;
            if ([identifiers containsObject:existentAlertView.identifier]) {
                existed = YES;
                break;
            }
        }
    }
    return existed;
}

- (UILabel *)detailMessageLabel {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDetailMessageLabel:(UILabel *)detailMessageLabel {
    objc_setAssociatedObject(self, @selector(detailMessageLabel), detailMessageLabel, OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)identifier {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @selector(identifier), identifier, OBJC_ASSOCIATION_COPY);
}

- (void)bottomButtonAction {
    [self invokeDelegateWithIndex:0];
    [self dismiss];
}

@end

@implementation PMMCAlertView (OutLink)

+ (instancetype)popAlertViewWithIcon:(UIImage *)icon
                               title:(NSString *)title
                             message:(NSString *)message
                         buttonTitle:(NSString *)buttonTitle {
    PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                   message:message
                                           leftButtonTitle:nil
                                          rightButtonTitle:nil];
    //更改contentView的Frame
    CGRect contentViewFrame = view.contentView.frame;
    contentViewFrame.size.height = 215.f;
    contentViewFrame.origin.y = (MCA_ScreenHeight - contentViewFrame.size.height) / 2;
    view.contentView.frame = contentViewFrame;
    
    //icon
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(view.contentView.frame) - 50.f) / 2, 24.f, 50.f, 50.f)];
    iconImageView.image = icon;
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [view.contentView addSubview:iconImageView];
    
    //title
    CGFloat titleY = message.length > 0 ? CGRectGetMaxY(iconImageView.frame) + 16.f : CGRectGetMaxY(iconImageView.frame) + 33.f;
    view.titleLabel.text = title;
    view.titleLabel.textColor = [UIColor colorWithRed:0.0 green:16.0 / 255.0 blue:38.0 / 255.0 alpha:1.f];
    if (@available(iOS 8.2, *)) {
        view.titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
    } else {
        view.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    }
    [view.titleLabel sizeToFit];
    view.titleLabel.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - CGRectGetWidth(view.titleLabel.frame)) / 2, titleY, CGRectGetWidth(view.titleLabel.frame), 22.f);
    
    //message
    if (message.length > 0) {
        view.messageLabel.text = message;
        view.messageLabel.textColor = [UIColor colorWithRed:0.0 green:16.0 / 255.0 blue:38.0 / 255.0 alpha:0.5];
        view.messageLabel.font = [UIFont systemFontOfSize:12.f];
        [view.messageLabel sizeToFit];
        view.messageLabel.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - CGRectGetWidth(view.messageLabel.frame)) / 2, CGRectGetMaxY(view.titleLabel.frame) + 8.f, CGRectGetWidth(view.messageLabel.frame), 17.f);
    }else {
        [view.messageLabel removeFromSuperview];
    }
    
    //buttonTitle
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - 120.f) / 2, CGRectGetHeight(view.contentView.frame) - 24.f - 30.f, 120.f, 30.f);
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    bottomButton.layer.cornerRadius = 15.f;
    bottomButton.backgroundColor = [UIColor colorWithRed:0.0 green:96.0 / 255.0 blue:230.0 / 255.0 alpha:1.0];
    bottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [bottomButton setTitle:buttonTitle forState:UIControlStateNormal];
    [bottomButton addTarget:view action:@selector(bottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [view.contentView addSubview:bottomButton];
    
    return view;
}

+ (instancetype)popAlertViewWithIcon:(UIImage *)icon
                               title:(NSString *)title
                     leftButtonTitle:(NSString *)leftButtonTitle
                    rightButtonTitle:(NSString *)rightButtonTitle
                            delegate:(id<MCAlertViewDelegate>)delegate {
    PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                   message:@""
                                           leftButtonTitle:leftButtonTitle
                                          rightButtonTitle:rightButtonTitle];
    
    view.delegate = delegate;
    //icon
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(view.contentView.frame) - 50.f) / 2, 24.f, 50.f, 50.f)];
    iconImageView.image = icon;
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [view.contentView addSubview:iconImageView];
    
    //title
    CGFloat titleY = CGRectGetMaxY(iconImageView.frame) + 8.f;
    view.titleLabel.text = title;
    view.titleLabel.textColor = [UIColor colorWithRed:0.0 green:16.0 / 255.0 blue:38.0 / 255.0 alpha:1.f];
   
    view.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    view.titleLabel.textColor = [UIColor colorWithRed:0.0 green:16.0 / 255.0 blue:38.0 / 255.0 alpha:0.5];
    view.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [view.titleLabel sizeToFit];
    view.titleLabel.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - CGRectGetWidth(view.titleLabel.frame)) / 2, titleY, CGRectGetWidth(view.titleLabel.frame), 22.f);
    
    [view.rightButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16]];
    return view;
}

- (void)bottomButtonAction {
    [self invokeDelegateWithIndex:0];
    [self dismiss];
}

- (NSString *)outLinkID {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOutLinkID:(NSString *)outLinkID {
    objc_setAssociatedObject(self, @selector(outLinkID), outLinkID, OBJC_ASSOCIATION_COPY);
}

- (NSString *)extractionCode {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setExtractionCode:(NSString *)extractionCode {
    objc_setAssociatedObject(self, @selector(extractionCode), extractionCode, OBJC_ASSOCIATION_COPY);
}

@end
@implementation PMMCAlertView (MarketPassword)

+ (instancetype)popMarketAlertViewWithIcon:(UIImage *)icon
                                     title:(NSString *)title
                                   message:(NSString *)message
                               buttonTitle:(NSString *)buttonTitle {
    PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                   message:message
                                           leftButtonTitle:nil
                                          rightButtonTitle:nil];
    //更改contentView的Frame
    CGRect contentViewFrame = view.contentView.frame;
    contentViewFrame.size.height = 215.f;
    contentViewFrame.origin.y = (MCA_ScreenHeight - contentViewFrame.size.height) / 2;
    view.contentView.frame = contentViewFrame;
    
    //icon
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(view.contentView.frame) - 50.f) / 2, 24.f, 50.f, 50.f)];
    iconImageView.image = icon;
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [view.contentView addSubview:iconImageView];
    
    //title
    CGFloat titleY = CGRectGetMaxY(iconImageView.frame) + 16.f;
    view.titleLabel.text = title;
    view.titleLabel.textColor = [UIColor colorWithRed:0.0 green:16.0 / 255.0 blue:38.0 / 255.0 alpha:1.f];
    if (@available(iOS 8.2, *)) {
        view.titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
    } else {
        view.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    }
    [view.titleLabel sizeToFit];
    view.titleLabel.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - CGRectGetWidth(view.titleLabel.frame)) / 2, titleY, CGRectGetWidth(view.titleLabel.frame), 55);
    view.titleLabel.numberOfLines = 2;
    view.titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    //message
    if (message.length > 0) {
        view.messageLabel.text = message;
        view.messageLabel.textColor = [UIColor colorWithRed:0.0 green:16.0 / 255.0 blue:38.0 / 255.0 alpha:0.5];
        view.messageLabel.font = [UIFont systemFontOfSize:12.f];
        [view.messageLabel sizeToFit];
        view.messageLabel.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - CGRectGetWidth(view.messageLabel.frame)) / 2, CGRectGetMaxY(view.titleLabel.frame) + 8.f, CGRectGetWidth(view.messageLabel.frame), 17.f);
    }else {
        [view.messageLabel removeFromSuperview];
    }
    
    //buttonTitle
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - 120.f) / 2, CGRectGetHeight(view.contentView.frame) - 24.f - 30.f, 120.f, 30.f);
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    bottomButton.layer.cornerRadius = 15.f;
    bottomButton.backgroundColor = [UIColor colorWithRed:0.0 green:96.0 / 255.0 blue:230.0 / 255.0 alpha:1.0];
    bottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [bottomButton setTitle:buttonTitle forState:UIControlStateNormal];
    [bottomButton addTarget:view action:@selector(bottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [view.contentView addSubview:bottomButton];
    
    return view;
}

+ (instancetype)popMarketAlertViewWithIcon:(UIImage *)icon
                                     title:(NSString *)title
                           leftButtonTitle:(NSString *)leftButtonTitle
                          rightButtonTitle:(NSString *)rightButtonTitle
                                  delegate:(id<MCAlertViewDelegate>)delegate {
    PMMCAlertView *view = [[PMMCAlertView alloc] initWithTitle:title
                                                   message:@""
                                           leftButtonTitle:leftButtonTitle
                                          rightButtonTitle:rightButtonTitle];
    
    view.delegate = delegate;
    //icon
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(view.contentView.frame) - 50.f) / 2, 24.f, 50.f, 50.f)];
    iconImageView.image = icon;
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [view.contentView addSubview:iconImageView];
    
    //title
    CGFloat titleY = CGRectGetMaxY(iconImageView.frame) + 8.f;
    view.titleLabel.text = title;
    view.titleLabel.textColor = [UIColor colorWithRed:0.0 green:16.0 / 255.0 blue:38.0 / 255.0 alpha:1.f];
   
    view.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    view.titleLabel.textColor = [UIColor colorWithRed:0.0 green:16.0 / 255.0 blue:38.0 / 255.0 alpha:0.5];
    view.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [view.titleLabel sizeToFit];
    view.titleLabel.frame = CGRectMake((CGRectGetWidth(view.contentView.frame) - CGRectGetWidth(view.titleLabel.frame)) / 2, titleY, CGRectGetWidth(view.titleLabel.frame), 22.f);
    
    [view.rightButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16]];
    return view;
}

- (void)bottomButtonAction {
    [self invokeDelegateWithIndex:0];
    [self dismiss];
}

- (NSString *)marketPassword {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMarketPassword:(NSString *)marketPassword {
    objc_setAssociatedObject(self, @selector(marketPassword), marketPassword, OBJC_ASSOCIATION_COPY);
}
@end
