//
//  ContactModel.h
//  ContactLibrary
//
//  Created by  BBC on 12-4-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicModel.h"

@interface ContactModel:BasicModel{
    
	//过滤型
	NSString *contactId; //服务端的联系人Id号
    NSString *contactUserId;//服务端的用户ID  *
    
    NSArray *carTel;//车载电话
	NSArray *WorkTel;//工作电话
	NSArray *homeEmail;//家庭邮件
	NSArray *homeTel;//家庭电话
	NSArray *homeFax;//传真
 
    
    //邮箱
    NSArray *email;//邮箱 *
    NSArray *workMail;//工作电子邮箱 *
    NSArray *homeMail;//家庭电子邮箱 *
    NSArray *otherMail;//其他电子邮箱 *
    
	//公用
	NSArray *mobile;//手机号
   
    NSArray *homeMobile;//家庭电话
    NSArray *otherMobile;//其他电话
    NSArray *iphone;//IPHONE  *
    NSArray *wokeiPhone; //工作手机
    NSArray *homeiPhone; //家庭手机
    
    
	NSDictionary *groupMap;//所属分组,分组ID与分组名称对应关系
	NSString *contactName;//联系人姓名
    NSString *familyName;//姓
    NSString *givenName;//名字
    NSArray *fetion;//飞信号  *
    
	//非过滤型
	NSString *userID;//用户ID
	NSArray *typeIdList;//类型ID
	NSArray *groups;//联系人和组的对应关系
	NSString *createTime;//创建时间
	NSString *lastContactTime;//最后登录时间
	NSString *status1;//状态
	NSString *dataFromFlag;//数据标识
	NSString *lastModifiedTime;//上次修改时间
	NSString *syncMobileFlag;//同步移动标识
	NSDictionary *friendIdMap;//好友id映射
    
    //717版本新增
    NSArray *birthday; //生日
    
    NSArray *addressHome; //家庭地址
    NSArray *addressWork; //工作地址
    NSArray *addressOther; //其它地址
    
	NSString *company; //公司
    NSString *job; //职位
    
    //传真
    NSArray *faxHome;
    NSArray *faxWork;
    NSArray *faxOther;
    
    //网站
    NSArray *websiteHome;
    NSArray *websiteWork;
    NSArray *websiteOther;
    
    NSArray *pager;//寻呼机
    
    NSString *nickName;//昵称
    
    NSString *prefixName;//前缀名
    NSString *suffixName;//后缀名
    NSString *middleName;//中间名
    
    NSMutableString *pinyinXin;//姓拼音
    NSString *pinyinMing;//名拼音
}

@property(nonatomic, retain) NSString *contactId;
@property(nonatomic, retain) NSString *contactUserId;
@property(nonatomic, retain) NSString *contactName;
@property(nonatomic, retain) NSString *familyName;
@property(nonatomic, retain) NSString *givenName;
@property(nonatomic, retain) NSString *prefixName;//前缀名
@property(nonatomic, retain) NSString *suffixName;//后缀名
@property(nonatomic, retain) NSString *middleName;//中间名

@property(nonatomic, retain) NSMutableString *pinyinXin;//姓拼音
@property(nonatomic, retain) NSString *pinyinMing;//名拼音

@property(nonatomic, retain) NSArray *birthday;
@property(nonatomic, retain) NSArray *addressHome;
@property(nonatomic, retain) NSArray *addressWork;
@property(nonatomic, retain) NSArray *addressOther;
@property(nonatomic, retain) NSString *company; //公司
@property(nonatomic, retain) NSString *job; //职位
@property(nonatomic, retain) NSArray *faxHome;
@property(nonatomic, retain) NSArray *faxWork;
@property(nonatomic, retain) NSArray *faxOther;

@property(nonatomic, retain) NSArray *fetion;
@property(nonatomic, retain) NSArray *pager;//寻呼机
@property(nonatomic, retain) NSString *nickName;//昵称

@property(nonatomic, retain) NSArray *WorkTel;
@property(nonatomic, retain) NSArray *homeEmail;
@property(nonatomic, retain) NSArray *homeTel;
@property(nonatomic, retain) NSArray *mobile;
@property(nonatomic, retain) NSDictionary	*groupMap;
@property(nonatomic, retain) NSArray *homeFax;
@property(nonatomic, retain) NSArray *carTel;


@property(nonatomic, retain) NSArray *homeMobile;
@property(nonatomic, retain) NSArray *otherMobile;
@property(nonatomic, retain) NSArray *iphone;

@property(nonatomic, retain) NSArray *email;
@property(nonatomic, retain) NSArray *workMail;
@property(nonatomic, retain) NSArray *homeMail;
@property(nonatomic, retain) NSArray *otherMail;
@property(nonatomic, retain) NSArray *websiteHome;
@property(nonatomic, retain) NSArray *websiteWork;
@property(nonatomic, retain) NSArray *websiteOther;

@property(nonatomic, retain) NSString *userID;
@property(nonatomic, retain) NSArray *typeIdList;
@property(nonatomic, retain) NSArray *groups;
@property(nonatomic, retain) NSString *createTime;
@property(nonatomic, retain) NSString *lastContactTime;
@property(nonatomic, retain) NSString *status1;
@property(nonatomic, retain) NSString *dataFromFlag;
@property(nonatomic, retain) NSString *lastModifiedTime;
@property(nonatomic, retain) NSString *syncMobileFlag;
@property(nonatomic, retain) NSDictionary *friendIdMap;
@property(nonatomic, retain) NSArray      *wokeiPhone;
@property(nonatomic, retain) NSArray      *homeiPhone;
@property(nonatomic, retain) NSArray      *otheriPhone;
@property(nonatomic, retain) NSArray      *callArray;
@property(nonatomic, retain) NSArray      *otherTEL;
@property(nonatomic, retain) NSArray      *faxArray;

@property(nonatomic, retain) NSArray      *MSNnum;
@property(nonatomic, retain) NSArray      *QQnum;
@property(nonatomic, retain) NSArray      *website;

@property(nonatomic, retain) NSArray      *anniversary;
@property(nonatomic, retain) NSArray      *assembleAddress;
@property(nonatomic, retain) NSArray      *assembleOrg;
@property(nonatomic, retain) NSArray      *noteArray;
@end
