//
//  LocalAddressBookModel.h
//  mCloudlib
//
//  Created by Eddy on 15-4-7.
//  Copyright (c) 2015年 soarsky.com. All rights reserved.
// 继承自 AddressBookModel 主要是为了扩展 AddressBookModel 的一些属性方法，方便联系人搜索界面与本地联系人界面的展示需要。

#import "AddressBookModel.h"
#import "SearchContactModel.h"

@interface LocalAddressBookModel : AddressBookModel

@property (nonatomic, assign) BOOL isSelected;

//存放搜索模型SearchContactModel 数组，email搜索将优先天健email模型，没有则添加phone模型且只添加其中一个。
@property (nonatomic, retain) NSMutableArray *searchContactModelArr;

@property (nonatomic, copy) NSString *pinYinName;
@property (nonatomic, copy) NSString *nameFirstLetter;
//每个中文拼音的首字母（例如：名字叫张三，则firstLetterString的结果未"ZS"）, 值为大写的字符串。
@property (nonatomic, copy) NSString *firstLetterString;

/**
 *  设置普通电话号码搜索模型数据
 */
- (void)setSearchPhoneModelArrData;

/**
 *  设置邮箱搜索模型数据
 */
- (void)setSearchEmailModelArrData;

@end
