//
//  MCMemberTableViewCell.h
//  mCloud_iPhone
//
//  Created by 向祖华 on 2018/1/20.
//  Copyright © 2018年 epro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFunctionDefines.h"


@protocol MCMemberTableViewCellDelegate <NSObject>
-(void)deleteButtonTapAtIndexPaht:(NSIndexPath*)indexPath;

@end

@interface MCMemberTableViewCell : UITableViewCell
@property (nonatomic,weak)id<MCMemberTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deletButton;

@end
