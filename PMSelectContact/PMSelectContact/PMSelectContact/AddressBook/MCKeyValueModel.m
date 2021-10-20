//
//  MCKeyValueModel.m
//  mCloud
//
//  Created by epro on 13-7-1.
//
//

#import "MCKeyValueModel.h"

@interface MCKeyValueModel ()

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation MCKeyValueModel

@synthesize keyValueStrKey;
@synthesize keyValueStrValue;

- (CGFloat)cellHeight {
    //如果keyValueStrValue无值直接返回0
    if (!self.keyValueStrValue || self.keyValueStrValue.length == 0) {
        return 0.f;
    }
    
    //如果_cellHeight有值，说明已经计算过了，则直接返回_cellHeight
    if (_cellHeight > 0.f) {
        return _cellHeight;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f]};
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat stringHeight = [self.keyValueStrValue boundingRectWithSize:CGSizeMake(screenWidth - 48.f, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:attributes
                                context:nil].size.height;
    _cellHeight = 10.f + 17.f + 7.f + stringHeight + 10.f; //相加的每一项都是按照UI高保真标注添加
    return _cellHeight;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Key: %@, Value: %@",keyValueStrKey,keyValueStrValue];
}

- (void)dealloc
{
    self.keyValueStrKey = nil;
    self.keyValueStrValue = nil;
    
}

@end
