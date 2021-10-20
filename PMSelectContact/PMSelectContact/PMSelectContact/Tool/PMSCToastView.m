//
//  PMSCToastView.m
//  139PushMail
//
//  Created by weikai on 2019/3/19.
//  Copyright © 2019 139. All rights reserved.
//

#import "PMSCToastView.h"
#import "AppDelegate.h"
#import "PMSelectContactDefine.h"

static PMSCToastView *instance = nil;
@interface PMSCToastView ()

/// Toast label
@property (weak, nonatomic) UILabel *toastLabel;

@property (nonatomic, assign) BOOL isKeyboardShow;

@end

@implementation PMSCToastView

+ (instancetype)shareInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        CGFloat toastHeight = 30;
        CGFloat toastWidth = ceil([UIScreen mainScreen].bounds.size.width * 0.7);
        [self doSyncUIBlock:^{
            instance = [[[self class] alloc] initWithFrame:CGRectMake(0.f, 0.f, toastWidth, toastHeight)];
        }];
    });
    return instance;
}

- (void)showOnTopWithText:(NSString *)text hideDelay:(NSTimeInterval)delay {
    [self doSyncUIBlock:^{
        if (instance.superview) {
            [instance removeFromSuperview];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayAction) object:nil];
        }
        instance.toastLabel.text = text;
        CGSize labelSize = [instance.toastLabel sizeThatFits:instance.bounds.size];
        instance.toastLabel.numberOfLines = 1;
        [instance setWidth:labelSize.width + 30.f];
        [instance setHeight:30];
//        [instance setY:NEW_StatusBarHeight + 7];
        [instance setY:44 + 7];
        [instance setCenterX:SCREEN_WIDTH/2];
        instance.toastLabel.frame = instance.bounds;
        UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:instance];
        [keyWindow bringSubviewToFront:instance];
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            instance.alpha = 1.0;
        } completion:nil];
        //延迟移除
        [self performSelector:@selector(delayAction) withObject:nil afterDelay:delay];
    }];
}

- (void)showInView:(UIView *)aView withText:(NSString *)text hideDelay:(NSTimeInterval)delay {
    [self doSyncUIBlock:^{
        UIView *theView = aView;
        if (!aView) {
            theView = [UIApplication sharedApplication].keyWindow;
        }
        
        if (instance.superview) {
            [instance removeFromSuperview];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayAction) object:nil];
        }
        
        // 重设尺寸
        instance.toastLabel.text = text;
        CGSize labelSize = [instance.toastLabel sizeThatFits:instance.bounds.size];
        CGRect toastFrame = instance.frame;
        CGFloat preferredWidth = labelSize.width + 30.f;
        CGFloat maxWidth = theView.frame.size.width - 40.f;
        
        if (maxWidth < preferredWidth) {
            //支持多行显示
            CGSize textSize = [text boundingRectWithSize:CGSizeMake(maxWidth, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : instance.toastLabel.font} context:nil].size;
            toastFrame.size = CGSizeMake(maxWidth, textSize.height + 10);
            instance.toastLabel.numberOfLines = 0;
        }else{
            toastFrame.size.width = preferredWidth;
            toastFrame.size.height = 30;
            instance.toastLabel.numberOfLines = 1;
        }
        toastFrame.origin.x = (CGRectGetWidth(theView.frame) - CGRectGetWidth(toastFrame)) * 0.5;
//        toastFrame.origin.y = CGRectGetHeight(theView.frame) - CGRectGetHeight(toastFrame) - 50.f;
        toastFrame.origin.y = CGRectGetHeight(theView.frame) - CGRectGetHeight(toastFrame) - 100.f;
        
        // 有键盘时，改为中间弹
        if (self.isKeyboardShow) {
            toastFrame.origin.y = theView.frame.size.height/2;
        }
        
        instance.frame = toastFrame;
        instance.toastLabel.frame = instance.bounds;
        [theView addSubview:instance];
        [theView bringSubviewToFront:instance];
        instance.alpha = 0.0;
        
        // 显示toast
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            instance.alpha = 1.0;
        } completion:nil];
        //延迟移除
        [self performSelector:@selector(delayAction) withObject:nil afterDelay:delay];

    }];
}

- (void)delayAction {
    [UIView animateWithDuration:0.25 animations:^{
        instance.alpha = 0.0;
    } completion:^(BOOL finished) {
        [instance removeFromSuperview];
        instance.alpha = 1.0;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Style
        self.layer.cornerRadius = 7.f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _position = PMSCToastViewPosition_bottom;
        // Toast text
        UILabel *toastLabel = [[UILabel alloc] initWithFrame:self.bounds];
        toastLabel.textAlignment = NSTextAlignmentCenter;
        toastLabel.textColor = [UIColor whiteColor];
        // 屏幕适配
//        CGFloat fontSize = [UIScreen mainScreen].bounds.size.width < 375.f ? 12.f : 15.f;
        CGFloat fontSize = 13;
        toastLabel.font = [UIFont systemFontOfSize:fontSize];
        toastLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.toastLabel = toastLabel;
        [self addSubview:toastLabel];
        
        // 监听键盘状态
        [self addObserverForKeyboard];
    }
    return self;
}

#pragma mark - Setter
- (void)setPosition:(PMSCToastViewPosition)position {
    _position = position;
    
    if (position == PMSCToastViewPosition_center) {
        CGRect newFrame = self.frame;
        newFrame.origin.y = (CGRectGetHeight(self.superview.frame) - CGRectGetHeight(self.frame)) / 2 - 50;
        self.frame = newFrame;
    } else {
        CGRect frame = self.frame;
        frame.origin.y = UI_SCREEN_HEIGHT - 100;
        self.frame = frame;
    }
}

+ (void)showWithText:(NSString *)text {
    [[self shareInstance] showInView:[UIApplication sharedApplication].keyWindow withText:text hideDelay:2.0];
}

+ (void)showInView:(UIView *)theView withText:(NSString *)text hideDelay:(NSTimeInterval)delay {
    [[PMSCToastView shareInstance] showInView:theView withText:text hideDelay:delay];
}

+ (void)showOnTopWithText:(NSString *)text hideDelay:(NSTimeInterval)delay {
    [[PMSCToastView shareInstance] showOnTopWithText:text hideDelay:delay];
}

+ (void)showText:(NSString *)text {
    [self showInView:nil withText:text hideDelay:1.5];
}

+ (void)showOnKeyboardWithText:(NSString *)text {
    UIWindow *view = nil;
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (id windowView in windows) {
        NSString *viewName = NSStringFromClass([windowView class]);
        if ([@"UIRemoteKeyboardWindow" isEqualToString:viewName]) {
            view = windowView;
            break;
        }
    }
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [PMSCToastView showInView:view withText:text hideDelay:1.5];
}


#pragma mark - 键盘状态

- (void)addObserverForKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)handleKeyboardWillShow:(NSNotification *)noti {
    self.isKeyboardShow = YES;
    
    NSDictionary *info = noti.userInfo;
    CGRect endFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = [self.superview convertRect:self.frame toView:nil];
    
    if (CGRectGetMaxY(frame) > endFrame.origin.y) {
        float duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:duration animations:^{
            self.y = self.superview.frame.size.height/2;
        }];
    }
}

- (void)handleKeyboardDidShow:(NSNotification *)noti {
    self.isKeyboardShow = YES;
}

- (void)handleKeyboardDidHide:(NSNotification *)noti {
    self.isKeyboardShow = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -

- (void)doSyncUIBlock:(void (^)(void))block {
    if ([NSThread currentThread].isMainThread) {
        if (block) {
            block();
        }
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

+ (void)doSyncUIBlock:(void (^)(void))block {
    if ([NSThread currentThread].isMainThread) {
        if (block) {
            block();
        }
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}


#pragma mark - ViewGeometry


// Retrieve and set the origin
- (CGPoint) origin
{
    return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
    return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (CGPoint) midpoint
{
    CGFloat x = CGRectGetMidX(self.bounds);
    CGFloat y = CGRectGetMidY(self.bounds);
    return CGPointMake(x, y);
}

// Query other frame locations
- (CGPoint) bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}


- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}


#pragma mark -

+ (void)toastWithText:(NSString *)text {
    [self showMessage:text];
}

+(void)showMessage:(NSString *)message
{
    [self doSyncUIBlock:^{
        [PMSCToastView showInView:[UIApplication sharedApplication].keyWindow withText:message hideDelay:1.5];
    }];
}


@end
