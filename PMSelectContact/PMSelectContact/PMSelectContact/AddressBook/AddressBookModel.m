//
//  AddressBookModel.m
//  mCloud
//
//  Created by allen on 13-6-27.
//
//

#import "AddressBookModel.h"

@implementation AddressBookModel
@synthesize addressRecordID;
@synthesize addressFullName;
@synthesize addressHomeEmail;
@synthesize addressOtherEmail;
@synthesize addressWorkEmail;
@synthesize addressHomeTel;
@synthesize addressMainTel;
@synthesize addressWorkTel;
@synthesize addressOtherTel;
@synthesize addressMobileTel;
@synthesize addressIphoneTel;
@synthesize addressHomeFax;
@synthesize addressOtherFax;
@synthesize addressWorkFax;
@synthesize addressPager;
@synthesize addressBookAddress;
@synthesize addressBirthday;
@synthesize addressJob;

- (BOOL)hasPhoneNumber:(NSString *)number
{
    if (addressMobileTel)
    {
        if ([number isEqualToString:addressMobileTel]) {
            return YES;
        }
    }
    NSMutableArray *arr = [NSMutableArray array];
    if (addressMobileTel)
    {
        [arr addObject:addressMobileTel];
    }
    if (addressHomeTel)
    {
        [arr addObject:addressHomeTel];
    }
    if (addressWorkTel)
    {
        [arr addObject:addressWorkTel];
    }
    if (addressMainTel)
    {
        [arr addObject:addressMainTel];
    }
    if (addressIphoneTel)
    {
        [arr addObject:addressIphoneTel];
    }
    if (addressOtherTel)
    {
        [arr addObjectsFromArray:addressOtherTel];
    }
    
    if ([arr containsObject:number])
    {
        return YES;
    }
    return NO;
}

//修复搜索数据缺失的bug
- (instancetype)init{
    self = [super init];
    if (self) {
        self.addressOtherTel = [NSMutableArray array];
        self.addressOtherEmail = [NSMutableArray array];
        
        self.addressMobileTelArr = [NSMutableArray array];
        self.addressHomeTelArr = [NSMutableArray array];
        self.addressWorkTelArr = [NSMutableArray array];
        self.addressMainTelArr = [NSMutableArray array];
        self.addressIphoneTelArr = [NSMutableArray array];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"addressRecordID:%d,addressFullName:%@,addressMobileTel:%@,addressHomeTel:%@,addressWorkTel:%@,addressMainTel:%@,addressIphoneTel:%@,addressIphoneTel:%@,addressHomeFax:%@,addressHomeFax:%@,addressWorkFax:%@,addressOtherFax:%@,addressPager:%@,addressOtherTel:%@,addressHomeEmail:%@,addressWorkEmail:%@,addressOtherEmail:%@,addressJob:%@,addressBookAddress:%@,addressBirthday:%@",addressRecordID,addressFullName,addressMobileTel,addressHomeTel,addressWorkTel,addressMainTel,addressIphoneTel,addressIphoneTel,addressHomeFax,addressHomeFax,addressWorkFax,addressOtherFax,addressPager,addressOtherTel,addressHomeEmail,addressWorkEmail,addressOtherEmail,addressJob,addressBookAddress,addressBirthday];
}

- (void)dealloc
{
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;
    
    
    
    
}
@end
