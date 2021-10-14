//
//  BasicModel.h
//  ClassicalCloud
//
//  Created by shj on 13-7-29.
//  Copyright (c) 2013年 epro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicModel : NSObject

@property (nonatomic, assign) NSInteger iRetureCode;

// 模型初始化
- (id) initFromDictionary:(NSDictionary*)dic;

// 解析数据来自于字典，子类重写该方法
- (void) parseFromDictionary:(NSDictionary*)dic;

@end
