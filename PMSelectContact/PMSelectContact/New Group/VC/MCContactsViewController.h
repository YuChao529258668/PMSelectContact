//
//  MCContactsViewController.h
//  mCloud_iPhone
//
//  Created by 潘天乡 on 17/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFunctionDefines.h"

@class MCContactObject;

typedef void(^MCDidAddedContactsBlock) (NSArray<MCContactObject *> * contacts);

@interface MCContactsViewController : UIViewController

@property (nonatomic, copy) MCDidAddedContactsBlock addedBlock;

- (instancetype)init;
- (instancetype)initWithContacts:(NSArray<MCContactObject *> *)contacts;

@end
