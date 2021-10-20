//
//  MCShareContactSearchModel.h
//  mCloud_iPhone
//
//  Created by 向祖华 on 2018/1/20.
//  Copyright © 2018年 epro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCShareContactSearchModel : NSObject
@property(nonatomic,strong)NSString * name;

@property(nonatomic,strong)NSString * telNumber;

+ (NSString *)mcSectionHeaderDateString:(NSString *)dateString;
@end
