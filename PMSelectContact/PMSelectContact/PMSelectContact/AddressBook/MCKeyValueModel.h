//
//  MCKeyValueModel.h
//  mCloud
//
//  Created by epro on 13-7-1.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCKeyValueModel : NSObject

@property (nonatomic,retain) NSString *keyValueStrKey;
@property (nonatomic,retain) NSString *keyValueStrValue;

/**
 缓存cell的高度，避免重复计算。注意先给keyValueStrValue赋值才会有返回值。
 */
@property (nonatomic, readonly) CGFloat cellHeight;

@end
