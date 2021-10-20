//
//  MCContactsSearchListViewCell.h
//  mCloud_iPhone
//
//  Created by 潘天乡 on 22/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFunctionDefines.h"

@class MCContactObject;

@interface MCContactsSearchListViewCell : UITableViewCell

- (void)configUIWithContact:(MCContactObject *)contact;
+ (CGFloat)cellHeight;

@end
