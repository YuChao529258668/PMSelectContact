//
//  MCContactObject.h
//  mCloud_iPhone
//
//  Created by 潘天乡 on 22/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCContactObject : NSObject


@property (nonatomic, assign) uint32_t addressRecordID; //联系人唯一ID
@property (nonatomic, copy) NSAttributedString *name; //名字
@property (nonatomic, copy) NSAttributedString *phoneNum; //电话号码

@end
