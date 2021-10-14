
//  SearchContactModel.m
//  mCloudlib
//
//  Created by Eddy on 15-4-7.
//  Copyright (c) 2015年 soarsky.com. All rights reserved.
//

#import "SearchContactModel.h"

@implementation SearchContactModel

- (void)dealloc{
    self.compositeName = nil;
    self.phoneNum = nil;
    self.descriPtion = nil;
    self.modelIdxPath = nil;
    self.email = nil;
    
}

- (NSString *)description{
    return [NSString stringWithFormat:@"compositeName:%@,searchType:%@,phoneNum:%@,email:%@,descriPtion:%@,modelIdxPath:%@,isSelect:%d",_compositeName,@(_searchType),_phoneNum,self.email,_descriPtion,_modelIdxPath,_isSelect];
}

@end
