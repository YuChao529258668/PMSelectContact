//
//  MCAlertView.h
//  mCloud_iPhone
//
//  Created by 潘天乡 on 05/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MCPlaceholderTextView.h"

extern NSString *MCAlertViewDidShowNotification;
extern NSString *MCAlertViewDidHideNotification;



typedef void (^ MCAlertView_Block_Void)(void);

@protocol MCAlertViewDelegate;

@interface MCAlertView : UIView

@property (nonatomic, weak) id<MCAlertViewDelegate> delegate;

@property (nullable, nonatomic, copy) MCAlertView_Block_Void leftButtonClickBlock;

@property (nullable, nonatomic, copy) MCAlertView_Block_Void rightButtonClickBlock;

//按钮颜色，默认为主题蓝（0x0060E6）
@property (nonatomic, strong) UIColor *leftButtonTitleColor;
@property (nonatomic, strong) UIFont *leftButtonTitleFont;
@property (nonatomic, strong) UIColor *rightButtonTitleColor;
@property (nonatomic, strong) UIFont *rightButtonTitleFont;
//以下属性都有默认值，特殊情况才需要设置
@property (nonatomic, assign) CGFloat  titlefontSize;
@property (nonatomic, assign) CGFloat  messageFontSize;
@property (nonatomic, assign) CGFloat  messageHeight;
@property (nonatomic, strong) UIColor  *titleColor;
@property (nonatomic, strong) UIColor  *messageColor;
@property (nonatomic, strong) NSString *message;
@property (nonatomic,assign) NSTextAlignment  textAlignment;//默认message居中
/// 点击关闭的手势，该手势触发后不会调用“取消”按钮的方法
@property (nonatomic, readonly) UITapGestureRecognizer *tapToDismissGesture;
/// 启动点击空白消失
@property (nonatomic, assign, getter=isEnableTapToDimiss) BOOL enableTapToDimiss;
///是否已经弹窗
@property (nonatomic, assign) BOOL isPopView;
/// 是否云解压弹出的刷新提示窗
@property (nonatomic, assign) BOOL isDecompression;


@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic,strong)  UILabel *titleLabel;
@property (nonatomic,strong)  UILabel *messageLabel;
@property (nonatomic,strong)  UIView *customContentView;
@property (nonatomic,strong)  UIView *bottomView;
@property (nonatomic, strong) UITextView *inputTextView;



/**
 * 如果只有一个按钮，则可以设置给leftButtonTitle或rightButtonTitle
 */
+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle;

+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle
                          isHaveClose:(BOOL)isHaveClose;

+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle
                          isHaveClose:(BOOL)isHaveClose
                          isMaxHeight:(BOOL)isMaxHeight;

/// 创建内容弹窗但不主动弹出 。让用户去调用才弹出
/// @param title 标题
/// @param message 文字内容
/// @param leftButtonTitle 底部左侧按钮
/// @param rightButtonTitle 底部右侧按钮
/// @param isPopView 是否手动调用

+ (instancetype)popAlertViewWithTitle:(NSString *)title
                                  message:(NSString *)message
                          leftButtonTitle:(NSString *)leftButtonTitle
                         rightButtonTitle:(NSString *)rightButtonTitle
                                isPopView:(BOOL)isPopView;

/// 创建内容弹窗
/// @param title 标题
/// @param message 文字内容
/// @param customContent 自定义视图内容
/// @param leftButtonTitle 底部左侧按钮
/// @param rightButtonTitle 底部右侧按钮
+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                          contentView:(UIView *)customContent
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle;

+ (instancetype)popInputAlertViewWithTitle:(NSString *)title
                                 inputText:(NSString *)inputText
                           leftButtonTitle:(NSString *)leftButtonTitle
                          rightButtonTitle:(NSString *)rightButtonTitle;

/// 弹窗
-(void)popAlertView;
///收起弹窗
- (void)dismiss;

@end

@protocol MCAlertViewDelegate <NSObject>
@optional
/**
 * index从左往右代表按钮的位置：0,1
 */
- (void)alertView:(MCAlertView *)view didClickAtIndex:(NSInteger)index;

- (void)textViewOverMaxInputLength;

@end

@interface MCAlertView (MCloudAddition)

+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                        detailMessage:(NSString *)detailMessage
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle;

+ (instancetype)popAlertViewWithAppletDict:(NSDictionary *)dict sameAccout:(BOOL)sameAccout;
/**
 判断是否有弹窗的identifier包含在提供的集合里面
 */
+ (BOOL)isThereAlertWithIdentifiers:(NSSet *)identifiers;

/// 在Message之下的详情信息label
@property (nonatomic, strong) UILabel *detailMessageLabel;
/// 唯一标识,用于更准确地区分alert view
@property (nonatomic, copy) NSString *identifier;

@end

@interface MCAlertView (OutLink)

@property (nonatomic, copy) NSString *outLinkID; //外链ID
@property (nonatomic, copy) NSString *extractionCode; //外链提取码

+ (instancetype)popAlertViewWithIcon:(UIImage *)icon
                               title:(NSString *)title
                             message:(NSString *)message
                         buttonTitle:(NSString *)buttonTitle;

+ (instancetype)popAlertViewWithIcon:(UIImage *)icon
                               title:(NSString *)title
                     leftButtonTitle:(NSString *)leftButtonTitle
                    rightButtonTitle:(NSString *)rightButtonTitle
                            delegate:(id<MCAlertViewDelegate>)delegate;

@end

@interface MCAlertView (MarketPassword)

@property (nonatomic, copy) NSString *marketPassword; //营销口令

+ (instancetype)popMarketAlertViewWithIcon:(UIImage *)icon
                                     title:(NSString *)title
                                   message:(NSString *)message
                               buttonTitle:(NSString *)buttonTitle;

+ (instancetype)popMarketAlertViewWithIcon:(UIImage *)icon
                                     title:(NSString *)title
                           leftButtonTitle:(NSString *)leftButtonTitle
                          rightButtonTitle:(NSString *)rightButtonTitle
                                  delegate:(id<MCAlertViewDelegate>)delegate;

@end
