//
//  MCSCLoadingProgressView.m
//  139PushMail
//
//  Created by weikai on 2019/4/15.
//  Copyright © 2019 139. All rights reserved.
//

#import "MCSCLoadingProgressView.h"
#import "PMSelectContactDefine.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, MCSCLoadingProgressStyle) {
    MCSCLoadingProgressStyle_Default,//底部蒙层为透明
    MCSCLoadingProgressStyle_Black,//黑框带进度
};
static NSString * const LoadingProgressViewRotateAnimationKey = @"LoadingProgressViewRotateAnimationKey";
static NSString * const LoadingProgressViewCloudAnimationKey = @"LoadingProgressViewCloudAnimationKey";
//#define gMCColorWithHex(hexValue, alphaValue) ([UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f green:((hexValue >> 8) & 0x000000FF)/255.0f blue:((hexValue) & 0x000000FF)/255.0 alpha:alphaValue])
@interface MCSCLoadingProgressView ()<CAAnimationDelegate>

@property(nonatomic, strong) UIView *contentView;
/// Loading部分
@property (nonatomic, strong) UIView *loadingView;


@property(nonatomic, strong) CAShapeLayer *bottomShapeLayer;
@property(nonatomic, strong) CAShapeLayer *ovalShapeLayer;
@property(nonatomic, strong) UIImageView *cloudImageView;

@property(nonatomic, assign) MCSCLoadingProgressStyle loadingProgressStyle;
/// 是否正在加载中
@property (nonatomic, assign, getter=isLoading) BOOL loading;

@end

@implementation MCSCLoadingProgressView



- (instancetype)initWithFrame:(CGRect)frame withStyle:(MCSCLoadingProgressStyle )style{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.loading = NO;
        if (style == MCSCLoadingProgressStyle_Black) {
                [self setupUIWithBlackLoading];
        } else {
                [self setupUIWithClearLoading];
        }
    }
    return self;
}


- (instancetype)initWithStyle:(MCSCLoadingProgressStyle )style{
    MCSCLoadingProgressView *progressView = [[MCSCLoadingProgressView alloc] initWithFrame:CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) withStyle:style];

    if (style == MCSCLoadingProgressStyle_Black) {
        progressView.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        progressView.contentView.layer.cornerRadius = 6.0;
//        progressView.cloudImageView.image = [UIImage imageNamed:@"loading1"];
//        progressView.bottomShapeLayer.strokeColor = gMCColorWithHex(0xa8abb2,1.0).CGColor;
//        progressView.ovalShapeLayer.strokeColor = [UIColor colorWithRed:152.0 / 255 green:193.0 /255 blue:85.0/255 alpha:1].CGColor;
        progressView.ovalShapeLayer.strokeColor = [self colorFromHexNumber:0x1484EF].CGColor;
        progressView.titleLabel.textColor = gMCColorWithHex(0xFFFFFF, 1.0);
    }
    return progressView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 居中内容
    _contentView.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
}

- (void)setupUIWithBlackLoading {
    // 内容容器
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 110, 75)];
    [self addSubview:contentView];
    self.contentView = contentView;
    // Loading部分
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 24.f, 24.f)];
    self.loadingView = loadingView;
    [self.contentView addSubview:loadingView];
    
    // 底部的灰色layer
    CAShapeLayer *bottomShapeLayer = [CAShapeLayer layer];
    bottomShapeLayer.frame = loadingView.bounds;
    bottomShapeLayer.strokeColor = [gMCColorWithHex(0xEEF3FF, 1.0) CGColor];
    bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;
    bottomShapeLayer.lineWidth = 4.f;
    [self.loadingView.layer addSublayer:bottomShapeLayer];
    self.bottomShapeLayer = bottomShapeLayer;
    
    // 蓝色的layer
    CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
    ovalShapeLayer.frame = loadingView.bounds;
//    ovalShapeLayer.strokeColor = [UIColor colorWithRed:152.0 / 255 green:193.0 /255 blue:85.0/255 alpha:1].CGColor;
    ovalShapeLayer.strokeColor = [self colorFromHexNumber:0x1484EF].CGColor;
    ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ovalShapeLayer.lineWidth = 4.f;
    ovalShapeLayer.lineCap = kCALineCapRound;
    [self.loadingView.layer addSublayer:ovalShapeLayer];
    self.ovalShapeLayer = ovalShapeLayer;
    
    /* “贪吃蛇”动画
     // 起点动画
     CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
     strokeStartAnimation.fromValue = @(-1);
     strokeStartAnimation.toValue = @(1.0);
     
     // 终点动画
     CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
     strokeEndAnimation.fromValue = @(0.0);
     strokeEndAnimation.toValue = @(1.0);
     
     // 组合动画
     CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
     animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
     animationGroup.duration = KAnimationDurationTime;
     animationGroup.repeatCount = CGFLOAT_MAX;
     animationGroup.fillMode = kCAFillModeForwards;
     animationGroup.removedOnCompletion = NO;
     [ovalShapeLayer addAnimation:animationGroup forKey:nil];
     */
    
    NSTimeInterval animationDuration = 0.75;
    // 云端缩放动画
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@(1.0), @(0.8), @(0.6)];
    scaleAnimation.autoreverses = YES;
    // 透明的渐变
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(1.0), @(0.6), @(0.2)];
    opacityAnimation.autoreverses = YES;
    
    CAAnimationGroup *cloudAnimationGroup = [CAAnimationGroup animation];
    cloudAnimationGroup.animations = @[scaleAnimation, opacityAnimation];
    cloudAnimationGroup.duration = animationDuration;
    cloudAnimationGroup.repeatCount = CGFLOAT_MAX;
    cloudAnimationGroup.autoreverses = YES;
    cloudAnimationGroup.fillMode = kCAFillModeForwards;
    cloudAnimationGroup.removedOnCompletion = NO;
    // 小云朵
    UIImageView *cloudImageView = [[UIImageView alloc] initWithFrame:_loadingView.bounds];
    //    cloudImageView.image = [UIImage imageNamed:@"logo"];
    // WARNING : 改其他尺寸的切图若需要缩放则修改此处
    cloudImageView.contentMode = UIViewContentModeCenter;
    [_loadingView addSubview:cloudImageView];
    [cloudImageView.layer addAnimation:cloudAnimationGroup forKey:LoadingProgressViewCloudAnimationKey];
    self.cloudImageView = cloudImageView;
    
    // 加载标题
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.font = [UIFont systemFontOfSize:16.f];
    textLbl.textColor = gMCColorWithHex(0xA8ABB2, 1.0);
    [contentView addSubview:textLbl];
    self.titleLabel = textLbl;
    
    
}


- (void)setupUIWithClearLoading{
    // 内容容器
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 125.f, 125.f)];
    [self addSubview:contentView];
    self.contentView = contentView;
        // Loading部分
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 38.f, 38.f)];
    self.loadingView = loadingView;
    [self.contentView addSubview:loadingView];
    
    // 底部的灰色layer
    CAShapeLayer *bottomShapeLayer = [CAShapeLayer layer];
    bottomShapeLayer.frame = loadingView.bounds;
    bottomShapeLayer.strokeColor = [gMCColorWithHex(0xEEF3FF, 1.0) CGColor];
    bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;
    bottomShapeLayer.lineWidth = 4.f;
    [self.loadingView.layer addSublayer:bottomShapeLayer];
    self.bottomShapeLayer = bottomShapeLayer;
    
    // 蓝色的layer
    CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
    ovalShapeLayer.frame = loadingView.bounds;
//    ovalShapeLayer.strokeColor = [UIColor colorWithRed:152.0 / 255 green:193.0 /255 blue:85.0/255 alpha:1].CGColor;
    ovalShapeLayer.strokeColor = [self colorFromHexNumber:0x1484EF].CGColor;
    ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ovalShapeLayer.lineWidth = 4.f;
    ovalShapeLayer.lineCap = kCALineCapRound;
    [self.loadingView.layer addSublayer:ovalShapeLayer];
    self.ovalShapeLayer = ovalShapeLayer;
    
    /* “贪吃蛇”动画
     // 起点动画
     CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
     strokeStartAnimation.fromValue = @(-1);
     strokeStartAnimation.toValue = @(1.0);
     
     // 终点动画
     CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
     strokeEndAnimation.fromValue = @(0.0);
     strokeEndAnimation.toValue = @(1.0);
     
     // 组合动画
     CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
     animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
     animationGroup.duration = KAnimationDurationTime;
     animationGroup.repeatCount = CGFLOAT_MAX;
     animationGroup.fillMode = kCAFillModeForwards;
     animationGroup.removedOnCompletion = NO;
     [ovalShapeLayer addAnimation:animationGroup forKey:nil];
     */
    
    NSTimeInterval animationDuration = 0.75;
    // 云端缩放动画
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@(1.0), @(0.8), @(0.6)];
    scaleAnimation.autoreverses = YES;
    // 透明的渐变
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(1.0), @(0.6), @(0.2)];
    opacityAnimation.autoreverses = YES;
    
    CAAnimationGroup *cloudAnimationGroup = [CAAnimationGroup animation];
    cloudAnimationGroup.animations = @[scaleAnimation, opacityAnimation];
    cloudAnimationGroup.duration = animationDuration;
    cloudAnimationGroup.repeatCount = CGFLOAT_MAX;
    cloudAnimationGroup.autoreverses = YES;
    cloudAnimationGroup.fillMode = kCAFillModeForwards;
    cloudAnimationGroup.removedOnCompletion = NO;
    // 小云朵
    UIImageView *cloudImageView = [[UIImageView alloc] initWithFrame:_loadingView.bounds];
//    cloudImageView.image = [UIImage imageNamed:@"logo"];
    // WARNING : 改其他尺寸的切图若需要缩放则修改此处
    cloudImageView.contentMode = UIViewContentModeCenter;
    [_loadingView addSubview:cloudImageView];
    [cloudImageView.layer addAnimation:cloudAnimationGroup forKey:LoadingProgressViewCloudAnimationKey];
    self.cloudImageView = cloudImageView;
   
    // 加载标题
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.font = [UIFont systemFontOfSize:16.f];
    textLbl.textColor = gMCColorWithHex(0xA8ABB2, 1.0);
    [contentView addSubview:textLbl];
    self.titleLabel = textLbl;
   
}

+ (UIView *)fetchWindow {
    return [[UIApplication sharedApplication] keyWindow];
}


#pragma mark - MCShowLoadingable

- (void)showLoadingInView:(UIView *)theView {
    if (nil == theView) return;
    
    self.loading = YES;
    //为适配视频横竖屏旋转改用其他方案
    self.frame = theView.bounds;
    [theView addSubview:self];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.hidden = NO;
    _titleLabel.hidden = YES;
    
    // Base parameters
    CGFloat loadingViewWidth = CGRectGetWidth(_loadingView.frame);
    // 布置视图
    _loadingView.center = CGPointMake(CGRectGetWidth(_contentView.frame) * 0.5, CGRectGetHeight(_contentView.frame) * 0.5);
    // 显示Loading
    self.bottomShapeLayer.path = [[UIBezierPath bezierPathWithOvalInRect:_loadingView.bounds] CGPath];
    self.ovalShapeLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(loadingViewWidth * 0.5, loadingViewWidth * 0.5) radius:(loadingViewWidth * 0.5) startAngle:0.f endAngle:M_PI_2 clockwise:YES] CGPath];
    [self ovalShapeLayerAnimation];
}

- (void)showLoadingWithMessage:(NSString *)message {
    if (message.length == 0) return;
    [self showCommontWithtitle:message view:[[self class] fetchWindow] isWindow:YES];
}

- (void)showLoadingWithMessage:(NSString *)message inView:(UIView *)theView {
    if (message.length == 0 || nil == theView) return;
    [self showCommontWithtitle:message view:theView isWindow:NO];
}

- (void)dismissLoading {
    self.loading = NO;
    [self removeFromSuperview];
   
}
+ (instancetype)showClearLoadingInView:(UIView *)theView
{
    MCSCLoadingProgressView *loadProgressView = [[MCSCLoadingProgressView alloc] initWithStyle:MCSCLoadingProgressStyle_Default];
    [loadProgressView showLoadingInView:theView];
    return loadProgressView;
}
+ (instancetype)showBlackLoadingInView:(UIView *)theView
{
    MCSCLoadingProgressView *loadProgressView = [[MCSCLoadingProgressView alloc] initWithStyle:MCSCLoadingProgressStyle_Black];
    [loadProgressView showLoadingInView:theView];
    return loadProgressView;
    
}

+ (instancetype)showBlackLoadingInView:(UIView *)theView WithProgress:(double)progress
{
    MCSCLoadingProgressView *loadProgressView = [[MCSCLoadingProgressView alloc] initWithStyle:MCSCLoadingProgressStyle_Black];
    [loadProgressView showLoadingInView:theView withMessage:[NSString stringWithFormat:@"%d%%", (int)(progress * 100)]];
    return loadProgressView;
}
- (void)showLoadingInView:(UIView *)theView withMessage:(NSString *)message {
    if (nil == theView) return;
    
    self.loading = YES;
    //为适配视频横竖屏旋转改用其他方案
    self.frame = theView.bounds;
    [theView addSubview:self];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.hidden = NO;
    _titleLabel.hidden = NO;
    _titleLabel.text = message;
    [_titleLabel sizeToFit];
    _titleLabel.textColor = gMCColorWithHex(0xFFFFFF, 1.0);
    // Base parameters
    CGFloat loadingViewWidth = CGRectGetWidth(_loadingView.frame);
    CGFloat contentViewWidth = CGRectGetWidth(_contentView.frame);
    
    
    
    
    CGFloat verticalMargin = (contentViewWidth - loadingViewWidth - CGRectGetHeight(_titleLabel.frame) - 8.f) * 0.5;
    // 设置Loading部分的位置
    CGRect loadingViewFrame = _loadingView.frame;
    loadingViewFrame.origin = CGPointMake((contentViewWidth - loadingViewWidth) * 0.5, verticalMargin-10);
    _loadingView.frame = loadingViewFrame;
    // 设置Label的位置
    CGRect titleLabelFrame = _titleLabel.frame;
    titleLabelFrame.size.width = contentViewWidth;
    titleLabelFrame.origin = CGPointMake(0.f, CGRectGetMaxY(_loadingView.frame)+5);
    _titleLabel.frame = titleLabelFrame;
    // 布置视图
    //    _loadingView.center = CGPointMake(CGRectGetWidth(_contentView.frame) * 0.5, CGRectGetHeight(_contentView.frame) * 0.5);
    // 显示Loading
    self.bottomShapeLayer.path = [[UIBezierPath bezierPathWithOvalInRect:_loadingView.bounds] CGPath];
    self.ovalShapeLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(loadingViewWidth * 0.5, loadingViewWidth * 0.5) radius:(loadingViewWidth * 0.5) startAngle:0.f endAngle:M_PI_2 clockwise:YES] CGPath];
    [self ovalShapeLayerAnimation];
}


+ (void)dismissLoadingInView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            MCSCLoadingProgressView *progressView = (MCSCLoadingProgressView *)subview;
            [progressView removeFromSuperview];
           
            
        }
    }
    
}


#pragma mark - Private

- (void)showCommontWithtitle:(NSString *)title view:(UIView *)view isWindow:(BOOL)isWindow{
    self.loading = YES;
    self.frame = view.bounds;
    [view addSubview:self];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Base parameters
    CGFloat loadingViewWidth = CGRectGetWidth(_loadingView.frame);
    CGFloat contentViewWidth = CGRectGetWidth(_contentView.frame);
    // 显示Loading
    self.bottomShapeLayer.path = [[UIBezierPath bezierPathWithOvalInRect:_loadingView.bounds] CGPath];
    self.ovalShapeLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(loadingViewWidth * 0.5, loadingViewWidth * 0.5) radius:(loadingViewWidth * 0.5) startAngle:0.f endAngle:M_PI_2 clockwise:YES] CGPath];
    // 布局各部件
    _titleLabel.hidden = NO;
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    CGFloat verticalMargin = (contentViewWidth - loadingViewWidth - CGRectGetHeight(_titleLabel.frame) - 8.f) * 0.5;
    // 设置Loading部分的位置
    CGRect loadingViewFrame = _loadingView.frame;
    loadingViewFrame.origin = CGPointMake((contentViewWidth - loadingViewWidth) * 0.5, verticalMargin);
    _loadingView.frame = loadingViewFrame;
    // 设置Label的位置
    CGRect titleLabelFrame = _titleLabel.frame;
    titleLabelFrame.size.width = contentViewWidth;
    titleLabelFrame.origin = CGPointMake(0.f, CGRectGetMaxY(_loadingView.frame) + 8.f);
    _titleLabel.frame = titleLabelFrame;
    
    // 设置contentView的大小
    if (isWindow) {
        self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.contentView.layer.cornerRadius = 4.0;
        self.cloudImageView.image = [UIImage imageNamed:@"loading1"];
        self.bottomShapeLayer.strokeColor = gMCColorWithHex(0xa8abb2,1.0).CGColor;
        self.ovalShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.titleLabel.textColor = gMCColorWithHex(0xFFFFFF, 1.0);
    }
    [self ovalShapeLayerAnimation];
}

- (void)ovalShapeLayerAnimation{
    NSTimeInterval animationDuration = 0.75;
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = @(0.0);
    rotateAnimation.toValue = @(M_PI * 2);
    rotateAnimation.repeatCount = CGFLOAT_MAX;
    rotateAnimation.duration = animationDuration;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.delegate = self;
    [self.ovalShapeLayer addAnimation:rotateAnimation forKey:LoadingProgressViewRotateAnimationKey];
}

#pragma mark -

/// 更新进度文字
- (void)updateProgress:(double)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
        self.titleLabel.text = text;
    });
}


#pragma mark -

- (UIColor *)colorFromHexNumber:(unsigned int)hex
{
    return [self colorFromHexNumber:hex alpha:1];
}

- (UIColor *)colorFromHexNumber:(unsigned int)hex alpha:(float)alpha
{
    /**
     * mac内存存储为小端：FFFFFF00 <-高位在后
     */
    unsigned char r, g, b;
    r = (hex & 0xFF0000) >> 16;
    g = (hex & 0x00FF00) >> 8;
    b = (hex & 0x0000FF);
    return [self colorFromR:r G:g B:b alpha:alpha];
}

- (UIColor *)colorFromR:(unsigned char)r G:(unsigned char)g B:(unsigned char)b
{
    return [self colorFromR:r G:g B:b alpha:1];
}

- (UIColor *)colorFromR:(unsigned char)r G:(unsigned char)g B:(unsigned char)b alpha:(float)alpha
{
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end
