//
//  MultiSelectTableViewCell.h
//  AddressBookSelect-text
//
//  Created by MARVIS on 15/3/25.
//  Copyright (c) 2015年 ___Marvis___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalAddressBookModel.h"
#import "MCFunctionDefines.h"

@class MultiSelectTableViewCell;

@protocol MultiSelectTableViewCellDelegate <NSObject>

@optional
- (void)multiSelectTableViewCell:(MultiSelectTableViewCell *)mSelectTableCell onClicked:(NSInteger )tag;

@end


@interface MultiSelectTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isEditing; //是否处于编辑状态
@property (nonatomic, weak) id<MultiSelectTableViewCellDelegate> delegate;

+ (CGFloat)getContentHeightWithContentModel:(LocalAddressBookModel *)contactModel;


- (void)setCellContentWithModel:(LocalAddressBookModel *)contactModel;

@end
