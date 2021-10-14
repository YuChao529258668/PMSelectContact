//
//  AddressBookLocalHelper.m
//  mCloudlib
//
//  Created by luo zhiling on 14-2-27.
//  Copyright (c) 2014年 epro. All rights reserved.
//

#import "AddressBookLocalHelper.h"
#import <AddressBook/AddressBook.h>
#import "AddressBookModel.h"
#import "NSString+Extend.h"
#import "LocalAddressBookModel.h"
#import "pinyin.h"
#import <UIKit/UIKit.h>

#define  kAddressBookLocalHelper @"AddressBookLocalHelper"

#define DicKey_PhoneNumForQuery (@"DicKey_PhoneNumForQuery")
#define DicKey_SourceDataArray (@"DicKey_SourceDataArray")

@implementation AddressBookLocalHelper

+(NSMutableArray *)getAllPeopleContactsInfo{
    
   return [self getAllPeopleContactsInfoWithSearchType:SEARCHTYPE_NORMAL];
}

+ (NSMutableArray *)getAllPeopleContactsInfoWithSearchType:(SEARCHTYPE)searchType{
    NSMutableArray *contactsArray = [[NSMutableArray alloc] init];
    //    NSMutableArray* personArray = nil;
    //获取通讯录的引用
    ABAddressBookRef addressBook = NULL;
    __block BOOL accessGranted = NO;
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 6.0)
    { // we're on iOS 6
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     accessGranted = granted;
                                                 });
    }
    else
    { // we're on iOS 5 or older
        addressBook = ABAddressBookCreate();
    }
    //获取通讯录所有联系人
    CFArrayRef personArrayCFRef = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSUInteger peopleCounter = 0;
    NSInteger peopleSize = personArrayCFRef==NULL? 0 : CFArrayGetCount(personArrayCFRef);
    for (peopleCounter = 0;
         peopleCounter < peopleSize; peopleCounter++)
    {
        ABRecordRef person = (ABRecordRef)CFArrayGetValueAtIndex(personArrayCFRef,peopleCounter);
        AddressBookModel *contact = nil;
        //初始化本地地址簿Model
        if (searchType == SEARCHTYPE_NORMAL) {
            contact = [[AddressBookModel alloc] init];
        } else {
            contact = [[LocalAddressBookModel alloc] init];
        }
        
        //获取ID
        ABRecordID recordID = ABRecordGetRecordID(person);
        contact.addressRecordID = recordID;
        
        //读取姓名,由firstName和lastName拼接
        [self getContactFullName:person addressBookModel:contact];
        //读取电话
        [self getContactDifferentPhoneNumber:person addressBookModel:contact];
        //读取邮箱
        [self getContactDifferentEmail:person addressBookModel:contact];
        
        //读取通信地址信息
        //在ios中国家，省份，城市，区，街道，号都是单独存储的
        //需要单独读取然后再组合（根据需要）
        [self getContactAddress:person addressBookModel:contact];
        if (searchType == SEARCHTYPE_NORMAL) {
            [contactsArray addObject:contact];
            
        } else {
            LocalAddressBookModel *localContact = (LocalAddressBookModel *)contact;
            //设置search专有属性 pinYinName，nameFirstLetter ，etc
            [self setContactCusProWithLocalABModel:localContact];
            //设置拼音首字母字符串
            [self setContactFirstLetterString:localContact];
            // 设置searchContactArray数据，子model。
            if (searchType == SEARCHTYPE_PHONE) {
                [localContact setSearchPhoneModelArrData];
            } else {
                [localContact setSearchEmailModelArrData];
            }
            
            if ([localContact.searchContactModelArr count] != 0) {
                [contactsArray addObject:contact];
            }
            else {
//                FXTRACE(FXT_DEBUG_LVL,kAddressBookLocalHelper,@"没有合法手机号码，联系人被丢弃");
            }
            
        }
    }
    personArrayCFRef==NULL?:CFRelease(personArrayCFRef);
    if (addressBook!=NULL) {
        CFRelease(addressBook);
    }
    return contactsArray;
}

+(NSMutableArray *)getAllSearchPeoplePhoneContactsInfo
{
    return [self getAllPeopleContactsInfoWithSearchType:SEARCHTYPE_PHONE];
}

+(NSMutableArray *)getAllSearchPeopleEmailContactsInfo{
    return [self getAllPeopleContactsInfoWithSearchType:SEARCHTYPE_EMAIL];
}

+ (void)setContactCusProWithLocalABModel: (LocalAddressBookModel *)contact{
    contact.pinYinName = [contact.addressFullName transformToPinyin];
    contact.nameFirstLetter = [[NSString stringWithFormat:@"%c",
                            pinyinFirstLetter([contact.addressFullName characterAtIndex:0])]
                           uppercaseString];
}

+ (void)setContactFirstLetterString:(LocalAddressBookModel *)contact {
    if (!contact.pinYinName || contact.pinYinName.length == 0) {
        contact.firstLetterString = nil;
    }
    
    NSString *result = @"";
    NSArray *pyArray = [contact.pinYinName componentsSeparatedByString:@" "];
    if(pyArray && pyArray.count > 0){
        for (NSString *strTemp in pyArray) {
            if (strTemp.length > 0) {
                result = [result stringByAppendingString:[strTemp substringWithRange:NSMakeRange(0, 1)]];
            }
        }
    }
    contact.firstLetterString = [result uppercaseString];
}


//读取联系人的通信地址信息
+ (void)getContactAddress:(ABRecordRef)person
         addressBookModel:(AddressBookModel *)contact{
    
    ABMultiValueRef addressTotal = ABRecordCopyValue(person,
                                                     kABPersonAddressProperty);
    if (addressTotal)
    {
        NSString *address = @"";
        NSInteger count = ABMultiValueGetCount(addressTotal);
        for(int j = 0; j < count; j++)
        {
            NSDictionary* personaddress =(NSDictionary*)CFBridgingRelease(
                                                                          ABMultiValueCopyValueAtIndex
                                                                          (addressTotal, j));
            
            NSString* country = [personaddress valueForKey:(NSString *)
                                 kABPersonAddressCountryKey];
            
            
            if(country != nil)
            {
                address = [NSString stringWithFormat:@"%@",country];
            }
            
            NSString* city = [personaddress valueForKey:
                              (NSString *)kABPersonAddressCityKey];
            if(city != nil)
            {
                address = [address stringByAppendingFormat:@"%@",city];
            }
            
            NSString* state = [personaddress valueForKey:
                               (NSString *)kABPersonAddressStateKey];
            if(state != nil)
            {
                address = [address stringByAppendingFormat:@"%@",state];
            }
            NSString* street = [personaddress valueForKey:
                                (NSString *)kABPersonAddressStreetKey];
            if(street != nil)
            {
                address = [address stringByAppendingFormat:@"%@",street];
            }
        }
        
        contact.addressBookAddress = address;
        
        (addressTotal == NULL) ? : CFRelease(addressTotal);
        
    }
}

//读取联系人不同的邮箱信息
+ (void)getContactDifferentEmail:(ABRecordRef)person
                addressBookModel:(AddressBookModel *)contact
{
    ABMultiValueRef mails = (ABMultiValueRef)
    
    ABRecordCopyValue(person, kABPersonEmailProperty);
    
    if (NULL == mails)
    {
        return;
    }
    
    for(int i = 0 ;i < ABMultiValueGetCount(mails); i++){
        
        CFStringRef cfStr = ABMultiValueCopyLabelAtIndex(mails, i);
        
        //获取email Label
        NSString* emailLabel = (NSString *)CFBridgingRelease(
                                                             ABAddressBookCopyLocalizedLabel(cfStr));
        
        NSString *email = (NSString *)CFBridgingRelease(
                                                        ABMultiValueCopyValueAtIndex(mails, i) );
        if (email == nil)
        {
            (cfStr == NULL) ? : CFRelease(cfStr);
            continue;
        }
        
        if([emailLabel isEqualToString:@"home"]) //住宅邮箱
        {
            contact.addressHomeEmail = email;
        }
        else if([emailLabel isEqualToString:@"work"]) //工作邮箱
        {
            contact.addressWorkEmail = email;
        }else //其他邮箱
        {
            [contact.addressOtherEmail addObject:email];
        }
        
        //必须判空释放
        (cfStr == NULL) ? : CFRelease(cfStr);
    }
    (mails == NULL) ? : CFRelease(mails);
}

//读取联系人不同的电话信息
+ (void)getContactDifferentPhoneNumber:(ABRecordRef)person
                      addressBookModel:(AddressBookModel *)contact
{
    ABMultiValueRef phones = (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    for(int i = 0 ;i < ABMultiValueGetCount(phones); i++)
    {
        NSString *phone = (NSString *)CFBridgingRelease(
                                                        ABMultiValueCopyValueAtIndex(phones, i));
        NSString *aLabel = (NSString *)CFBridgingRelease(
                                                         ABMultiValueCopyLabelAtIndex(phones, i));
        
        if([aLabel isEqualToString:@"_$!<Mobile>!$_"]){//移动电话
            //号码合法之后才能赋值
            NSString *newPhone = [phone telephoneWithReformat];
            if ([newPhone isValidPhoneNum]) {
                contact.addressMobileTel = newPhone;
                if (![contact.addressMobileTelArr containsObject:newPhone]) {
                    [contact.addressMobileTelArr addObject:newPhone];
                }
            }
        }else if([aLabel isEqualToString:@"iPhone"]){//Iphone电话
            NSString *newPhone = [phone telephoneWithReformat];
            if ([newPhone isValidPhoneNum]) {
                contact.addressIphoneTel = newPhone;
                if (![contact.addressIphoneTelArr containsObject:newPhone]) {
                    [contact.addressIphoneTelArr addObject:newPhone];
                }
            }
        }else if([aLabel isEqualToString:@"_$!<Home>!$_"]){//住宅电话
            NSString *newPhone = [phone telephoneWithReformat];
            if ([newPhone isValidPhoneNum]) {
                contact.addressHomeTel = newPhone;
                if (![contact.addressHomeTelArr containsObject:newPhone]) {
                    [contact.addressHomeTelArr addObject:newPhone];
                }
            }
        }else if([aLabel isEqualToString:@"_$!<Work>!$_"]){//工作电话
            NSString *newPhone = [phone telephoneWithReformat];
            if ([newPhone isValidPhoneNum]) {
                contact.addressWorkTel = newPhone;
                if (![contact.addressWorkTelArr containsObject:newPhone]) {
                    [contact.addressWorkTelArr addObject:newPhone];
                }
            }
        }else if([aLabel isEqualToString:@"_$!<Main>!$_"]){//主要电话
            NSString *newPhone = [phone telephoneWithReformat];
            if ([newPhone isValidPhoneNum]) {
                contact.addressMainTel = newPhone;
                if (![contact.addressMainTelArr containsObject:newPhone]) {
                    [contact.addressMainTelArr addObject:newPhone];
                }
            }
        }else if([aLabel isEqualToString:@"_$!<HomeFAX>!$_"]){//住宅传真
            contact.addressHomeFax = [phone telephoneWithReformat];
        }else if([aLabel isEqualToString:@"_$!<WorkFAX>!$_"]){//工作传真
            contact.addressWorkFax = [phone telephoneWithReformat];
        }else if([aLabel isEqualToString:@"_$!<OtherFAX>!$_"]){//工作传真
            contact.addressOtherFax = [phone telephoneWithReformat];
        }else if([aLabel isEqualToString:@"_$!<Pager>!$_"]){//传呼
            contact.addressPager = [phone telephoneWithReformat];
            /*
             用户自定义的电话号码，将不会存在系统为其创建的aLabel 为nil
             所以可能存在有电话号码没有对应标题的情况在此情况下都按照其他号码来存储。
             aLabel可能为_$!<Other>!$_，手机，Apple Care，Apple Store，nil etc
             *///其他号码
        }else if (phone){
            NSString *nomalizePhoneStr = [phone telephoneWithReformat];
            if (nomalizePhoneStr){
                [contact.addressOtherTel addObject:[phone telephoneWithReformat]];
            }
        }
    }
    if (phones!=NULL) {
        CFRelease(phones);
    }
    //    (phones == NULL) ? : CFRelease(phones);
}

/*
 读取联系人全名，由于没有使用middleName组装因此会导致部分联系人的姓名为空，
 在此处更换为使用ABRecordCopyCompositeName()获取联系人全名。
 */
+(void)getContactFullName:(ABRecordRef)person
         addressBookModel:(AddressBookModel *)contact
{
    NSString *compositeName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
    contact.addressFullName = compositeName;
    
}


#pragma mark -

+ (NSString *)getAddressBookFullNameByPhoneNumber:(NSString *)phoneNumber{
    
    NSMutableArray *contactsArray = nil;
    contactsArray = [self getAllPeopleContactsInfo];

//    if (self.addressArrAllContactsInfo)
//    {
//        contactsArray = [NSMutableArray arrayWithArray:self.addressArrAllContactsInfo];
//    }
//    else
//    {
//        contactsArray = [self getAllPeopleContactsInfo];
//        self.addressArrAllContactsInfo = contactsArray;
//    }
    
    if (!phoneNumber || !contactsArray)
    {
        return nil;
    }
    
    return [self
            getAddressBookFullNameByPhoneNumberAndSourceData:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,
                                                              DicKey_PhoneNumForQuery,
                                                              contactsArray,
                                                              DicKey_SourceDataArray,
                                                              nil]];
}

+ (NSString *)getAddressBookFullNameByPhoneNumberAndSourceData:(NSDictionary *)dicData
{
    NSDictionary *tmpDic = dicData;
    
    NSArray *contactsArray = [tmpDic objectForKey:DicKey_SourceDataArray];
    NSString *phoneNumber = [tmpDic objectForKey:DicKey_PhoneNumForQuery];
    NSString *peopleFullName = nil;
    // 添加格式化电话号码方法，避免找不到数据。
    phoneNumber = [phoneNumber get11PhoneFormaterNumber];
//    NSLog(@"phoneNumber----%@",phoneNumber);
    for (AddressBookModel *contact in contactsArray)
    {
        if ([contact hasPhoneNumber:phoneNumber])
        {
            peopleFullName=[NSString stringWithString:contact.addressFullName?contact.addressFullName:phoneNumber];
            return peopleFullName;
        }
    }
    peopleFullName = phoneNumber;
    return peopleFullName;
}

@end
