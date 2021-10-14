//
//  LocalAddressBookModel.m
//  mCloudlib
//
//  Created by Eddy on 15-4-7.
//  Copyright (c) 2015年 soarsky.com. All rights reserved.
//

#import "LocalAddressBookModel.h"
#import "NSString+Extend.h"
//#import "LoginManager.h"

#define kLocalAddressBookModel @"LocalAddressBookModel"

@implementation LocalAddressBookModel

//
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setSearchPhoneModelArrData{
    [self setSearchModelArrDataForPhone:YES];
}

- (void)setSearchModelArrDataForPhone:(BOOL)yesOrNo{
    if (!self.searchContactModelArr) {
        self.searchContactModelArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
//    if (self.addressMobileTel)
//    {
//        BOOL isVaild =  [self setSearchContactArrDataWithPhone:self.addressMobileTel
//                                                   description:@"移动"
//                                                 isForPhoneNum:yesOrNo];
//        if (isVaild && !yesOrNo) {
//            return;
//        }
//    }
    
    if (self.addressMobileTelArr.count > 0) {
        for (NSString *mobileTel in self.addressMobileTelArr) {
            [self setSearchContactArrDataWithPhone:mobileTel
                                       description:@"移动"
                                     isForPhoneNum:yesOrNo];
        }
    }
    
//    if (self.addressHomeTel)
//    {
//        BOOL isVaild =  [self setSearchContactArrDataWithPhone:self.addressHomeTel
//                                                   description:@"住宅"
//                                                 isForPhoneNum:yesOrNo];
//        if (isVaild && !yesOrNo) {
//            return;
//        }
//    }
    
    if (self.addressHomeTelArr.count > 0) {
        for (NSString *homeTel in self.addressHomeTelArr) {
            [self setSearchContactArrDataWithPhone:homeTel
                                       description:@"住宅"
                                     isForPhoneNum:yesOrNo];
        }
    }
    
//    if (self.addressWorkTel)
//    {
//        BOOL isVaild =  [self setSearchContactArrDataWithPhone:self.addressWorkTel
//                                                   description:@"工作"
//                                                 isForPhoneNum:yesOrNo];
//        if (isVaild && !yesOrNo) {
//            return;
//        }
//    }
    
    if (self.addressWorkTelArr.count > 0) {
        for (NSString *workTel in self.addressWorkTelArr) {
            [self setSearchContactArrDataWithPhone:workTel
                                       description:@"工作"
                                     isForPhoneNum:yesOrNo];
        }
    }
    
//    if (self.addressMainTel)
//    {
//        BOOL isVaild =  [self setSearchContactArrDataWithPhone:self.addressMainTel
//                                                   description:@"主要"
//                                                 isForPhoneNum:yesOrNo];
//        if (isVaild && !yesOrNo) {
//            return;
//        }
//    }
    
    if (self.addressMainTelArr.count > 0) {
        for (NSString *mainTel in self.addressMainTelArr) {
            [self setSearchContactArrDataWithPhone:mainTel
                                       description:@"主要"
                                     isForPhoneNum:yesOrNo];
        }
    }
    
//    if (self.addressIphoneTel)
//    {
//       BOOL isVaild =  [self setSearchContactArrDataWithPhone:self.addressIphoneTel
//                                   description:@"iPhone"
//                                 isForPhoneNum:yesOrNo];
//        if (isVaild && !yesOrNo) {
//            return;
//        }
//    }
    
    if (self.addressIphoneTelArr.count > 0) {
        for (NSString *phoneTel in self.addressIphoneTelArr) {
            [self setSearchContactArrDataWithPhone:phoneTel
                                       description:@"iPhone"
                                     isForPhoneNum:yesOrNo];
        }
    }
    
    
    if(self.addressHomeFax)
    {
        BOOL isVaild =  [self setSearchContactArrDataWithPhone:self.addressHomeFax
                                                   description:@"住宅传真"
                                                 isForPhoneNum:yesOrNo];
        if (isVaild && !yesOrNo) {
            return;
        }
    }
    
    if(self.addressOtherFax)
    {
        BOOL isVaild =  [self setSearchContactArrDataWithPhone:self.addressOtherFax
                                                   description:@"其他传真"
                                                 isForPhoneNum:yesOrNo];
        if (isVaild && !yesOrNo) {
            return;
        }
    }
    
    if(self.addressWorkFax)
    {
        BOOL isVaild =  [self setSearchContactArrDataWithPhone:self.addressWorkFax
                                                   description:@"工作传真"
                                                 isForPhoneNum:yesOrNo];
        if (isVaild && !yesOrNo) {
            return;
        }
    }
    
    if(self.addressPager)
    {
        BOOL isVaild =  [self setSearchContactArrDataWithPhone:self.addressPager
                                                   description:@"传呼"
                                                 isForPhoneNum:yesOrNo];
        if (isVaild && !yesOrNo) {
            return;
        }
    }
    
    if (self.addressOtherTel)
    {
        for (NSString *phoneNo in self.addressOtherTel)
        {
            BOOL isVaild =  [self setSearchContactArrDataWithPhone:phoneNo
                                                       description:@"其他"
                                                     isForPhoneNum:yesOrNo];
            if (isVaild && !yesOrNo) return;
        }
    }
}

- (BOOL)setSearchContactArrDataWithPhone:(NSString *)phoneNum
                             description:(NSString *)des
                           isForPhoneNum:(BOOL)yesOrNo{
    NSString *formartPhoneStr = [phoneNum get11PhoneFormaterNumber];
    if ([self isVaildPhoneNumWithFormartPhoneStr:formartPhoneStr]) {
        if (!yesOrNo) {
            formartPhoneStr = [NSString stringWithFormat:@"%@@139.com",formartPhoneStr];
            [_searchContactModelArr addObject:[self createContactWithPhoneNum:formartPhoneStr  description:des]];
            return YES;
        }
        [_searchContactModelArr addObject:[self createContactWithPhoneNum:formartPhoneStr  description:des]];
        return YES;
    }
    return NO;
}

- (void)setSearchEmailModelArrData{
    if (!self.searchContactModelArr) {
        self.searchContactModelArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (self.addressHomeEmail)
    {
        if ([self isValidateEmail:self.addressHomeEmail]) {
            [_searchContactModelArr addObject:[self createContactWithEmail:self.addressHomeEmail description:@"家庭邮箱"]];
        }
    }
    if (self.addressWorkEmail)
    {
        if ([self isValidateEmail:self.addressWorkEmail]) {
            [_searchContactModelArr addObject:[self createContactWithEmail:self.addressWorkEmail description:@"工作邮箱"]];
        }
    }
    if (self.addressOtherEmail)
    {
        for (NSString *email in self.addressOtherEmail)
        {
            if ([self isValidateEmail:email]) {
                [_searchContactModelArr addObject:[self createContactWithEmail:email  description:@"其他邮箱"]];
            }
        }
    }
    
    if ([_searchContactModelArr count] == 0) {
        [self setSearchModelArrDataForPhone:NO];
    }

}


- (BOOL )isVaildPhoneNumWithFormartPhoneStr:(NSString *)formarterStr{
    //只显示合法的手机号
    NSString *regex = @"^1[0-9]{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:formarterStr])
    {
        return NO;
    }
    
    // 去除自己的电话号码
//    if ([formarterStr isEqualToString:[LoginManager sharedInstance].mobileNo]) {
//        FXTRACE(FXT_WARN_LVL,kLocalAddressBookModel,@"user account.phoneNum---%@\n",[LoginManager sharedInstance].account);
//        return NO;
//    }
    return YES;
}

/*邮箱验证 MODIFIED*/
- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9]+[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(SearchContactModel *)createContactWithPhoneNum:(NSString*)phoneNum description:(NSString*)description
{
    SearchContactModel * obj = [[SearchContactModel alloc] init];
    obj.addressRecordID = self.addressRecordID;
    obj.compositeName = self.addressFullName;
    obj.phoneNum = phoneNum;
    obj.searchType = SEARCHTYPE_PHONE;
    obj.descriPtion = description;
    return obj;
}

-(SearchContactModel *)createContactWithEmail:(NSString*)email description:(NSString*)description
{
    SearchContactModel * obj = [[SearchContactModel alloc] init];
    obj.compositeName = self.addressFullName;
    obj.email = email;
    obj.searchType = SEARCHTYPE_EMAIL;
    obj.descriPtion = description;
    return obj;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@,isSelect:%d\n, searchContactModelArr:%@",[super description],_isSelected,self.searchContactModelArr];
}


@end
