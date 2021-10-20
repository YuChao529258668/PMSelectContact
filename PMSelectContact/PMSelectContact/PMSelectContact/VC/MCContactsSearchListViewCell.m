//
//  MCContactsSearchListViewCell.m
//  mCloud_iPhone
//
//  Created by 潘天乡 on 22/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import "MCContactsSearchListViewCell.h"
#import "MCContactObject.h"

static const CGFloat cellHeight = 55.0;

@interface MCContactsSearchListViewCell ()

@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end;

@implementation MCContactsSearchListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        phoneLabel.font = [UIFont systemFontOfSize:16.0];
        phoneLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:phoneLabel];
        self.phoneLabel = phoneLabel;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(15.0, cellHeight - 0.5, CGRectGetWidth(self.frame) - 2 * 15.0, 0.5)];
        bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        bottomLine.backgroundColor = gMCColorWithHex(0xE7E7E7, 1.0);
        [self.contentView addSubview:bottomLine];
    }
    return self;
}

- (void)configUIWithContact:(MCContactObject *)contact {
    _phoneLabel.attributedText = contact.phoneNum;
    [_phoneLabel sizeToFit];
    _phoneLabel.frame = CGRectMake(22.0, 7.0, CGRectGetWidth(_phoneLabel.frame), _phoneLabel.font.lineHeight);
    
    _nameLabel.attributedText = contact.name;
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(CGRectGetMinX(_phoneLabel.frame), CGRectGetMaxY(_phoneLabel.frame) + 5.0, CGRectGetWidth(_nameLabel.frame), _nameLabel.font.lineHeight);
}

#pragma mark - Public
+ (CGFloat)cellHeight {
    return cellHeight;
}

@end
