//
//  AddressBookLocalHelper.h
//  mCloudlib
//
//  Created by luo zhiling on 14-2-27.
//  Copyright (c) 2014年 epro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookLocalHelper : NSObject


+ (NSMutableArray *)getAllPeopleContactsInfo;

+(NSMutableArray *)getAllSearchPeoplePhoneContactsInfo;

+(NSMutableArray *)getAllSearchPeopleEmailContactsInfo;

//根据手机号获取对应联系人名字, 没找到将返回查询时的号码
+ (NSString *)getAddressBookFullNameByPhoneNumber:(NSString *)phoneNumber;


@end
