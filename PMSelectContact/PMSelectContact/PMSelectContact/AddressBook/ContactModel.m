//
//  ContactModel.m
//  ContactLibrary
//
//  Created by  BBC on 12-4-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactModel.h"
#import "POAPinyin.h"
@implementation ContactModel
@synthesize contactId,contactName,WorkTel,homeEmail,homeTel,homeFax,
    mobile,groupMap,familyName,givenName,carTel,homeMobile,otherMobile;
@synthesize userID,typeIdList,groups,createTime,lastContactTime,
    status1,dataFromFlag,lastModifiedTime,syncMobileFlag,friendIdMap;
@synthesize contactUserId,email,workMail,homeMail,otherMail,iphone,fetion;
@synthesize birthday,addressHome,addressWork,addressOther,company,job;
@synthesize faxHome,faxWork,faxOther,websiteHome,websiteWork,websiteOther;
@synthesize pager,nickName,prefixName,suffixName,middleName,pinyinMing,pinyinXin;

@synthesize wokeiPhone,homeiPhone,otheriPhone,callArray,otherTEL,faxArray,
MSNnum,QQnum,website,assembleAddress,assembleOrg,noteArray,anniversary;
- (void)parseFromDictionary:(NSDictionary *)dic{
    

    /***************************联系方式***************************/
    //服务端的联系人Id号
    self.contactId = (NSString *)[self dataVerified:[dic objectForKey:@"contactId"]];
    //服务端的用户ID
    self.contactId = (NSString *)[self dataVerified:[dic objectForKey:@"contactUserId"]];
    /***************************联系方式***************************/
     //手机号
     self.mobile = (NSArray *)[self dataVerified:[dic objectForKey:@"mobile"]];
    //工作手机电话
    self.wokeiPhone = (NSArray*)[self dataVerified:[dic objectForKey:@"wokeiPhone"]];
    //家庭手机电话
    self.homeiPhone = (NSArray *)[self dataVerified:[dic objectForKey:@"homeMobile"]];
    //其他手机号码
    self.otheriPhone = (NSArray *)[self dataVerified:[dic objectForKey:@"otherMobile"]];
    //IPHONE
    self.iphone = (NSArray *)[self dataVerified:[dic objectForKey:@"iphone"]];
    
    //电话
    self.callArray = (NSArray *)[self dataVerified:[dic objectForKey:@"tel"]];
    //家庭电话
    self.homeTel = (NSArray *)[self dataVerified:[dic objectForKey:@"homeTel"]];
    //工作电话
    self.WorkTel = (NSArray *)[self dataVerified:[dic objectForKey:@"workTel"]];
    //车载电话
    self.carTel = (NSArray *)[self dataVerified:[dic objectForKey:@"carTel"]];
    //电报
    self.pager = (NSArray *)[self dataVerified:[dic objectForKey:@"pager"]];
    //其他电话
    self.otherTEL = (NSArray *)[self dataVerified:[dic objectForKey:@"otherTel"]];
    
    
    /***************************邮箱***************************/
    //邮件
    self.homeEmail = (NSArray *)[self dataVerified:[dic objectForKey:@"homeMail"]];
    //邮箱
    self.email = (NSArray *)[self dataVerified:[dic objectForKey:@"email"]];
    //工作电子邮箱
    self.workMail = (NSArray *)[self dataVerified:[dic objectForKey:@"workMail"]];
    //家庭电子邮箱
    self.homeMail = (NSArray *)[self dataVerified:[dic objectForKey:@"homeMail"]];
    //其他电子邮箱
    self.otherMail = (NSArray *)[self dataVerified:[dic objectForKey:@"otherMail"]];
     /***************************传真***************************/
    //传真
	self.faxArray = (NSArray *)[self dataVerified:[dic objectForKey:@"fax"]];
    //
    self.faxHome = (NSArray *)[self dataVerified:[dic objectForKey:@"homeFax"]];
    self.faxWork = (NSArray *)[self dataVerified:[dic objectForKey:@"workFax"]];
    self.faxOther = (NSArray *)[self dataVerified:[dic objectForKey:@"otherFax"]];
    /***************************聊天号 qq 飞信 msn***************************/
   
    self.fetion = (NSArray *)[self dataVerified:[dic objectForKey:@"fetion"]];
    self.QQnum = (NSArray *)[self dataVerified:[dic objectForKey:@"qq"]];
    self.MSNnum = (NSArray *)[self dataVerified:[dic objectForKey:@"msn"]];

     /***************************网址***************************/
    
    self.website = (NSArray *)[self dataVerified:[dic objectForKey:@"website"]];
    self.websiteHome = (NSArray *)[self dataVerified:[dic objectForKey:@"homeWebsite"]];
    self.websiteWork = (NSArray *)[self dataVerified:[dic objectForKey:@"workWebsite"]];
    
    self.websiteOther = (NSArray *)[self dataVerified:[dic objectForKey:@"otherWebsite"]];
    
    /***************************地址***************************/
    //
    self.assembleAddress = [self assembleAddressInfo:dic addressType:@"assembleAddress"];
    self.addressHome = [self assembleAddressInfo:dic addressType:@"homeAssembleAddress"];
    self.addressWork = [self assembleAddressInfo:dic addressType:@"workAssembleAddress"];
    //
    
    self.addressOther = [self assembleAddressInfo:dic addressType:@"otherAssembleAddress"];
    
    /***************************生日 纪念日***************************/
    self.birthday = (NSArray *)[self dataVerified:[dic objectForKey:@"birthday"]];
    self.anniversary = (NSArray*)[self dataVerified:[dic objectForKey:@"anniversary"]];
    //***************************职位和备注***************************/
    self.assembleOrg = [self assembleJobInfo:dic];
    self.noteArray = (NSArray *)[self dataVerified:[dic objectForKey:@"note"]];
    //通讯录分组
    self.groupMap = (NSDictionary *)[self dataVerified:[dic objectForKey:@"groupMap"]];
	//联系人姓名
    //self.contactName = (NSString *)[self dataVerified:[dic objectForKey:@"name"]];

    //姓
    self.familyName = (NSString *)[self dataVerified:[dic objectForKey:@"familyName"]];
    //名字
	self.givenName = (NSString *)[self dataVerified:[dic objectForKey:@"givenName"]];
    if ([self dataVerified:[dic objectForKey:@"middleName"]]
        &&self.familyName &&self.givenName)
    {
        //sdk数据返回不统一导致数据错乱，故再次拼接中间名字
        self.contactName = [NSString stringWithFormat:@"%@%@%@",self.familyName,
                            [self dataVerified:[dic objectForKey:@"middleName"]],
                            self.givenName];
    }
    else
    {
        self.contactName = (NSString *)[self dataVerified:[dic objectForKey:@"name"]];
    }

    //飞信号

    

    self.pinyinXin = [self stringIsNull:[NSString stringWithFormat:@"%@%@",
                                         [self stringIsNull:self.familyName],
                                         [self stringIsNull:self.givenName]]];
	//CFStringTransform((CFMutableStringRef)pinyinXin, 0, kCFStringTransformStripDiacritics, NO);
    /***************************非过滤型***************************/
    //用户ID
    self.userID = (NSString *)[self dataVerified:[dic objectForKey:@"userId"]];
    //类型ID
    self.typeIdList = (NSArray *)[self dataVerified:[dic objectForKey:@"typeIdList"]];
    //组
	self.groups = (NSArray *)[self dataVerified:[dic objectForKey:@"groups"]];
    //创建时间
    self.createTime = (NSString *)[self dataVerified:[dic objectForKey:@"createTime"]];
    //最后登录时间
	self.lastContactTime = (NSString *)[self dataVerified:[dic objectForKey:@"lastContactTime"]];
    //状态
	self.status1 = (NSString *)[self dataVerified:[dic objectForKey:@"status"]];
    //数据标识
	self.dataFromFlag = (NSString *)[self dataVerified:[dic objectForKey:@"dataFromFlag"]];
    //上次修改时间
	self.lastModifiedTime = (NSString *)[self dataVerified:[dic objectForKey:@"lastModifiedTime"]];
    //同步移动标识
	self.syncMobileFlag = (NSString *)[self dataVerified:[dic objectForKey:@"syncMobileFlag"]];
    //好友id映射
	self.friendIdMap = (NSDictionary *)[self dataVerified:[dic objectForKey:@"friendIdMap"]];
    

  
    
 
    self.nickName = (NSString *)[self dataVerified:[dic objectForKey:@"nickName"]];
    
    self.prefixName = (NSString *)[self dataVerified:[dic objectForKey:@"prefix"]];
    self.suffixName = (NSString *)[self dataVerified:[dic objectForKey:@"suffix"]];
    self.middleName = (NSString *)[self dataVerified:[dic objectForKey:@"middleName"]];
    
    
}


- (NSArray *)assembleJobInfo:(NSDictionary *)dic
{
    
    NSMutableArray *assembleArrays = [NSMutableArray array];
    NSArray *assembleArray = (NSArray *)[self dataVerified:[dic objectForKey:@"assembleOrg"]];
    for (NSDictionary *dicAssenble in assembleArray)
    {
        NSString *t_company = [dicAssenble objectForKey:@"company"];
        if (!t_company)
        {
            t_company = @"";
        }
        NSString *t_department = [dicAssenble objectForKey:@"department"];
        if (!t_department)
        {
            t_department = @"";
        }
         NSString *t_position = [dicAssenble objectForKey:@"position"];
        if (!t_position)
        {
            t_position = @"";
        }
        NSString  *t_assembleInfo = [NSString stringWithFormat:@"%@.%@.%@",t_company,t_department,t_position];
        [assembleArrays addObject:t_assembleInfo];
    }
    return assembleArrays;
}

- (NSArray *)assembleAddressInfo:(NSDictionary *)dic addressType:(NSString *)addressName
{
    NSMutableArray *arrAddress = [NSMutableArray array];
    NSArray *dicAddress = (NSArray *)[self dataVerified:[dic objectForKey:addressName]];
    for (NSDictionary *dicItem in dicAddress)
    {
        NSString *street = [dicItem objectForKey:@"street"];
        if (!street)
        {
            street = @"";
        }
        NSString *state = [dicItem objectForKey:@"state"];
        if (!state)
        {
            state = @"";
        }
        NSString *city = [dicItem objectForKey:@"city"];
        if (!city)
        {
            city = @"";
        }
        NSString *area = [dicItem objectForKey:@"area"];
        if (!area)
        {
            area = @"";
        }
        NSString *postalCode = [dicItem objectForKey:@"postalCode"];
        if (!postalCode)
        {
            postalCode = @"";
        }
        
        NSString *addressInfo = [NSString stringWithFormat:@"%@.%@.%@,%@ %@",street,state,city,area,postalCode];
        [arrAddress addObject:addressInfo];
    }
    return arrAddress;
}

- (NSObject *)dataVerified:(NSObject *)object{
    
    if ([object isKindOfClass:[NSArray class]]){//数组处理
        
        NSArray *array = (NSArray *)object;
        
        if ([array count] > 0) {
            return object;
        }
        return nil;
        
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {//字典处理
        
        NSDictionary *dic = (NSDictionary *)object;
        
        if ([dic count] > 0)
        {
            return object;
        }
     return nil;

    }
    else if([object isEqual:@"<null>"]) //字符串处理
    {
        return nil;
    }
    return object;
}

-(NSMutableString *)stringIsNull:(NSString *)string_
{
    NSMutableString *description = [[NSMutableString alloc] init];
    if (string_)
    {
        [description appendString:string_];
        return description ;
    }
    
    [description appendString:@""];
    return description;
}
- (NSString *)description{
    
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendFormat:@"mobile: %@",self.mobile];
    [description appendFormat:@"contactName: %@",self.contactName];
    
    return description;
    
}

@end
