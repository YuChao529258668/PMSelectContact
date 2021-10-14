//
//  MCMemberTableViewCell.m
//  mCloud_iPhone
//
//  Created by 向祖华 on 2018/1/20.
//  Copyright © 2018年 epro. All rights reserved.
//

#import "MCMemberTableViewCell.h"

@implementation MCMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = gMCColorRGB(248, 249, 251);
}
#pragma mark -- 点击事件
- (IBAction)deletButtonAction:(UIButton *)sender {
    NSIndexPath * indexPath;
    UITableView * tableView;
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    if ([phoneVersion floatValue] >= 11.0) {
        if ([self.superview isKindOfClass:[UITableView class]]) {
            tableView = (UITableView*)self.superview;
            indexPath = [tableView indexPathForCell:self];
        }
    } else {
        if ([self.superview.superview isKindOfClass:[UITableView class]]) {
            tableView = (UITableView*)self.superview.superview;
            indexPath = [tableView indexPathForCell:self];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonTapAtIndexPaht:)]) {
        [self.delegate deleteButtonTapAtIndexPaht:indexPath];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
