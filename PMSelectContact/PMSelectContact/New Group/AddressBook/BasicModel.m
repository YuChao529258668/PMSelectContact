//
//  BasicModel.m
//  ClassicalCloud
//
//  Created by shj on 13-7-29.
//  Copyright (c) 2013年 epro. All rights reserved.
//

#import "BasicModel.h"

@interface BasicModel()
@end

@implementation BasicModel

@synthesize iRetureCode;

- (id)initFromDictionary:(NSDictionary *)dic
{
	self = [super init];
	
	// 将字典的数据转化为模型的数据
	[self parseFromDictionary:dic];
	
	return self;
}

- (void)parseFromDictionary:(NSDictionary *)dic
{
	
}

#pragma mark -
#pragma mark System Methods
- (void)dealloc
{
    
}

@end
