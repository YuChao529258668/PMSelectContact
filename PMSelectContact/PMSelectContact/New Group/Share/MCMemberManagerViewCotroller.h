//
//  MCMemberManagerViewCotroller.h
//  mCloud_iPhone
//
//  Created by 向祖华 on 2018/1/20.
//  Copyright © 2018年 epro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFunctionDefines.h"

typedef void(^memberManagerChangeBlock)(BOOL isChange);
typedef void(^ChosenMemberDataBlock)(BOOL isSuccess, NSArray * _Nullable members);


//@interface MCMemberManagerViewCotroller : MCBaseViewController
@interface MCMemberManagerViewCotroller : UIViewController

//从共享界面传输过来的值
@property(nonatomic,strong)NSMutableArray * member_dataArr;//成员列表数组
@property(nonatomic,assign)BOOL isFromNoteShare;
//xib布局
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *member_tableView;
@property (weak, nonatomic) IBOutlet UIButton *pushContactButton;
@property (weak, nonatomic) IBOutlet UIView *textFiledBackView;
@property (weak, nonatomic) IBOutlet UIView *textFiledBackgroundView;

@property(nonatomic,copy)memberManagerChangeBlock block;
@property(nonatomic,copy)ChosenMemberDataBlock noteSigninChosenMemberBlock;

@property (weak, nonatomic) IBOutlet UIView *addContactView;

@property (nonatomic, assign) BOOL isFriendIn;


/// 请求联系人权限，成功后调用 successBlock
@property (nonatomic, copy) void (^requestContactPowerBlock)(void(^successBlock)(void));

@end


#if MC_THEME_EXTENSION
@interface MCMemberManagerViewCotroller (MCThemeExtensions)<MCThemeSupporting>
@end
#endif
