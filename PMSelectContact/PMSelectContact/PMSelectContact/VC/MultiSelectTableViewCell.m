//
//  MultiSelectTableViewCell.m
//  AddressBookSelect-text
//
//  Created by MARVIS on 15/3/25.
//  Copyright (c) 2015年 ___Marvis___. All rights reserved.
//

#import "MultiSelectTableViewCell.h"
#import "PMSelectContactDefine.h"

static const CGFloat cellHeight = 44.0;
static const NSInteger baseLabelTag = 1111;

@interface MultiSelectTableViewCell()

@property (nonatomic, assign) NSInteger numberOfChild;

@end

@implementation MultiSelectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (CGFloat)getContentHeightWithContentModel:(LocalAddressBookModel *)contactModel{
    NSInteger phoneCount = [contactModel.searchContactModelArr count];
    if (phoneCount == 1) {
        return cellHeight;
    } else {
        return 44.0 * phoneCount + cellHeight;
    }
}

- (void)setCellContentWithModel:(LocalAddressBookModel *)contactModel{
    NSMutableArray *searchModelArr = contactModel.searchContactModelArr;
    //无论联系人是否合法，在cell展示上面必需有一个model就展示一个数据，此处不在验证联系人有没有电话号码以及电话号码是否合法的问题
    [self createCellTitleWithModel:contactModel];
    
    self.numberOfChild = [searchModelArr count];
    for (NSInteger i = 0; i < self.numberOfChild; i++) {
        SearchContactModel *searchModel = searchModelArr[i];
        [self createBtnWithModel:searchModel buttonTag:kCABASE_BTN_TAG + i + 1];
    }
}

-(void)createCellTitleWithModel:(LocalAddressBookModel *)contactModel{
    UIButton *btn = (UIButton *)[self.contentView viewWithTag:kCABASE_BTN_TAG];
    [btn setSelected:contactModel.isSelected];
    
    UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:btn.tag + baseLabelTag];
    if (contactModel.addressFullName) {
        nameLabel.text = contactModel.addressFullName;
    } else if ([contactModel.searchContactModelArr count] > 0){
        SearchContactModel *searchModel = contactModel.searchContactModelArr[0];
        if (searchModel.searchType == SEARCHTYPE_PHONE) {
            nameLabel.text = searchModel.phoneNum;
        } else {
            nameLabel.text = searchModel.email;
        }
    }
}

- (void)createBtnWithModel:(SearchContactModel *)searchModel buttonTag:(NSInteger )tag{
    UIButton *selectButton = (UIButton *)[self viewWithTag:tag];
    UILabel *namelabel = (UILabel *)[self viewWithTag:tag + baseLabelTag];
    if (!selectButton) {
        NSInteger count = tag - kCABASE_BTN_TAG;
        
        selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake(52.0, (cellHeight - 22.0) / 2 + 44 * count, 22.0, 22.0);
        [selectButton setImage:[UIImage imageNamed:@"common_small_square_unSelected"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"common_square_selected"] forState:UIControlStateSelected];
        selectButton.tag = tag;
        [selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectButton];
        
        UIFont *font = [UIFont systemFontOfSize:16.0];
        CGFloat namelabel_x = CGRectGetMaxX(selectButton.frame) + 15.0;
        namelabel = [[UILabel alloc] initWithFrame:CGRectMake(namelabel_x, 44 * count, [UIScreen mainScreen].bounds.size.width - namelabel_x - 30.0, cellHeight)];
        namelabel.font = font;
        namelabel.userInteractionEnabled = YES;
        namelabel.backgroundColor = [UIColor clearColor];
        namelabel.textAlignment = NSTextAlignmentLeft;
        namelabel.tag = tag + baseLabelTag;
        namelabel.textColor = gMCColorWithHex(0x333333, 1.0);
        [self.contentView addSubview:namelabel];
        
        
        UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapAction:)];
        [namelabel addGestureRecognizer:selectTap];
        
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(selectButton.frame), cellHeight - 0.5, [UIScreen mainScreen].bounds.size.width - CGRectGetMinX(selectButton.frame) - 15.0, 0.5)];
        bottomLine.backgroundColor = gMCColorWithHex(0xE7E7E7, 1.0);
        [self.contentView addSubview:bottomLine];
        
    }
    [selectButton setSelected:searchModel.isSelect];
    if (searchModel.searchType == SEARCHTYPE_PHONE) {
        namelabel.text = searchModel.phoneNum;
    } else {
        namelabel.text = searchModel.email;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake(15.0, (cellHeight - 22.0) / 2, 22.0, 22.0);
        [selectButton setImage:[UIImage imageNamed:@"common_cell_unselected_new"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"common_cell_selected_new"] forState:UIControlStateSelected];
        selectButton.tag = kCABASE_BTN_TAG;
        [selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectButton];
        
        UIFont *font = [UIFont systemFontOfSize:16.0];
        CGFloat namelabel_x = CGRectGetMaxX(selectButton.frame) + 15.0;
        UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(namelabel_x, 0.0, [UIScreen mainScreen].bounds.size.width - namelabel_x - 30.0, cellHeight)];
        namelabel.font = font;
        namelabel.userInteractionEnabled = YES;
        namelabel.backgroundColor = [UIColor clearColor];
        namelabel.textAlignment = NSTextAlignmentLeft;
        namelabel.tag = selectButton.tag + baseLabelTag;
        namelabel.textColor = gMCColorWithHex(0x333333, 1.0);
        [self.contentView addSubview:namelabel];
        
        
        //点击名字也会触发选择
        UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapAction:)];
        [namelabel addGestureRecognizer:selectTap];
        
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(selectButton.frame), cellHeight - 0.5, [UIScreen mainScreen].bounds.size.width - CGRectGetMinX(selectButton.frame) - 15.0, 0.5)];
        bottomLine.backgroundColor = gMCColorWithHex(0xE7E7E7, 1.0);
        [self.contentView addSubview:bottomLine];
        
    }
    return self;
}

- (void)selectTapAction:(UITapGestureRecognizer *)tap {
    UILabel *nameLabel = (UILabel *)tap.view;
    UIButton *selectButton = (UIButton *)[self.contentView viewWithTag:nameLabel.tag - baseLabelTag];
    
    if ([self.delegate respondsToSelector:@selector(multiSelectTableViewCell:onClicked:)]) {
        [self.delegate multiSelectTableViewCell:self onClicked:selectButton.tag];
    }
}

- (void)buttonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(multiSelectTableViewCell:onClicked:)]) {
        [self.delegate multiSelectTableViewCell:self onClicked:button.tag];
    }
}

- (void)dealloc {
    self.delegate = nil;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Setter
- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    
    UIButton *button = (UIButton *)[self.contentView viewWithTag:kCABASE_BTN_TAG];
    if (_isEditing) {
        [button setImage:[UIImage imageNamed:@"cloudDisk_uploadFiles_unSelected_new"] forState:UIControlStateNormal];
    }else {
        [button setImage:[UIImage imageNamed:@"common_cell_unselected_new"] forState:UIControlStateNormal];
    }
    
    for (NSInteger i = 0; i < self.numberOfChild; i++) {
        UIButton *subButton = (UIButton *)[self viewWithTag:kCABASE_BTN_TAG + i + 1];
        if (_isEditing) {
            [subButton setImage:[UIImage imageNamed:@"common_big_square_unSelected"] forState:UIControlStateNormal];
        }else {
            [subButton setImage:[UIImage imageNamed:@"common_small_square_unSelected"] forState:UIControlStateNormal];
        }
    }
}

@end

