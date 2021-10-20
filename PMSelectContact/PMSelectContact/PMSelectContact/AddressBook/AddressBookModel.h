//
//  AddressBookModel.h
//  mCloud
//
//  Created by allen on 13-6-27.
//
//

#import <Foundation/Foundation.h>

@interface AddressBookModel : NSObject
{
    
	uint32_t addressRecordID; //联系人Id号
    
    NSString *addressFullName;//联系人姓名
    
    NSString *addressJob;//职业
    
    NSString *addressBookAddress;//通信地址
    
    NSString *addressBirthday;//生日
    
    //号码
    NSString *addressMobileTel;//移动电话
    NSString *addressHomeTel;//住宅电话
    NSString *addressWorkTel;//工作电话
    NSString *addressMainTel;//主要电话
    NSString *addressIphoneTel;//
    NSString *addressHomeFax;//家庭传真
    NSString *addressWorkFax;//工作传真
    NSString *addressOtherFax;//其他传真
    NSString *addressPager;//传呼
    NSMutableArray *addressOtherTel;//其他号码

    //邮箱
    NSString *addressHomeEmail;//家庭邮箱
    NSString *addressWorkEmail;//工作邮箱
    NSMutableArray *addressOtherEmail;//其他邮箱
    
}
@property (nonatomic, assign) uint32_t addressRecordID;
@property (nonatomic, copy) NSString *addressFullName;
@property (nonatomic, copy) NSString *addressMobileTel;
@property (nonatomic, copy) NSString *addressHomeTel;
@property (nonatomic, copy) NSString *addressWorkTel;
@property (nonatomic, copy) NSString *addressMainTel;
@property (nonatomic, copy) NSString *addressIphoneTel;
@property (nonatomic, copy) NSString *addressHomeFax;
@property (nonatomic, copy) NSString *addressWorkFax;
@property (nonatomic, copy) NSString *addressOtherFax;
@property (nonatomic, copy) NSString *addressPager;
@property (nonatomic, retain) NSMutableArray *addressOtherTel;
@property (nonatomic, copy) NSString *addressHomeEmail;
@property (nonatomic, copy) NSString *addressWorkEmail;
@property (nonatomic, retain) NSMutableArray *addressOtherEmail;
@property (nonatomic, copy) NSString *addressJob;
@property (nonatomic, copy) NSString *addressBookAddress;
@property (nonatomic, copy) NSString *addressBirthday;

//同类的手机号可能存在多个
@property (nonatomic, retain) NSMutableArray *addressMobileTelArr;
@property (nonatomic, retain) NSMutableArray *addressHomeTelArr;
@property (nonatomic, retain) NSMutableArray *addressWorkTelArr;
@property (nonatomic, retain) NSMutableArray *addressMainTelArr;
@property (nonatomic, retain) NSMutableArray *addressIphoneTelArr;

- (BOOL)hasPhoneNumber:(NSString *)number;

@end
