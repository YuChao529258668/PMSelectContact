//
//  SearchContactModel.h
//  mCloudlib
//
//  Created by Eddy on 15-4-7.
//  Copyright (c) 2015年 soarsky.com. All rights reserved.
//  搜索本地联系人界面展示model 主要为联系人搜索界面展示使用服务于searchManager

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SEARCHTYPE)
{
    SEARCHTYPE_NORMAL        = 1 ,      //1   1   1
    SEARCHTYPE_PHONE         = 1 << 1,//2   2   10      转换成 10进制  2
    SEARCHTYPE_EMAIL         = 1 << 2, //4   3   100     转换成 10进制  4
};

@interface SearchContactModel : NSObject

@property (nonatomic, assign) uint32_t addressRecordID; //联系人唯一ID
@property (nonatomic, copy) NSString * compositeName;//名字
@property (nonatomic, copy) NSString * phoneNum;//电话号码，仅一个
@property (nonatomic, copy) NSString * descriPtion;//描述信息,iphone,家庭 etc
@property (nonatomic, copy) NSString * email;
@property (nonatomic, assign) SEARCHTYPE searchType;
@property (nonatomic,assign) BOOL isSelect; //是否被选中

@property (nonatomic, copy) NSIndexPath *modelIdxPath;//当前Model所在的位置，方便刷新表使用

@end
