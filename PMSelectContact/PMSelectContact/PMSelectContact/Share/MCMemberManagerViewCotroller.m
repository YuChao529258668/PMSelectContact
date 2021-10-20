//
//  MCMemberManagerViewCotroller.m
//  mCloud_iPhone
//
//  Created by 向祖华 on 2018/1/20.
//  Copyright © 2018年 epro. All rights reserved.
//

#import "MCMemberManagerViewCotroller.h"
#import "MCContactsViewController.h"

#import "MCMemberTableViewCell.h"
#import "MCSCAlertView.h"
#import "MCContactsSearchListView.h"

#import "LocalAddressBookModel.h"
#import "AddressBookModel.h"
#import "MCContactObject.h"

#import "AddressBookLocalHelper.h"

#import "NSString+SCExtend.h"
#import "pinyin.h"
#import "PMSCToastView.h"

@interface MCMemberManagerViewCotroller ()
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MCMemberTableViewCellDelegate,
MCAlertViewDelegate,
MCContactsSearchListViewDelegate>
//联系人搜索
@property(nonatomic,strong) UITableView* search_tableView;//搜索结果展示的列表
@property(nonatomic,assign)CGFloat searchTableView_height;//搜索结果列表的高度
@property(nonatomic,strong)NSMutableArray * search_dataArr;//搜索结果列表的数据
@property(nonatomic,strong)NSMutableArray * search_originArr;//搜索的源数据

//
@property (nonatomic,strong)NSMutableArray * tempMemberArr;//存储最原始的成员数组
@property(nonatomic,strong)NSMutableArray * addMemberArr;//新添加的成员
@property(nonatomic,strong)NSMutableArray * deletedMemberArr;//删除的成员

@property (nonatomic, strong) MCContactsSearchListView *searchListView;
@property (nonatomic, strong) UIView *searchListBgView;

@property(nonatomic,strong)UIView * coverView;//蒙版
@property(nonatomic,assign)BOOL isDataChange;//yes  表示有人员改变
@property(nonatomic,assign)NSUInteger selected_row;//点击删除图标记录选中的行

//730选择好友列表为空的页面
@property (nonatomic, strong) UIView *emptyView;
//@property (nonatomic, strong) MBProgressHUD *mbProgressHUD;

@property (nonatomic, strong) UIBarButtonItem *rightItem;

@end

@implementation MCMemberManagerViewCotroller

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化相关对象---布尔值，字符串初值，数值，self.viwe的属性
    [self initObject];
    //获取数据
    [self getData];
    //初始化视图
    [self initView];
    
    [self adjustNavigationBariOS15:self.navigationController.navigationBar];
}

//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//
//    CGRect frame = self.view.frame;
//    frame.origin.y = self.navigationController.navigationBar.frame.size.height;
//    self.view.frame = frame;
//}

- (void)adjustNavigationBariOS15:(UINavigationBar *)navigationBar {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.shadowColor = [UIColor clearColor]; // 去掉底部分割线
        appearance.backgroundEffect = nil; // 去掉半透明效果
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance;
    }
}

#pragma mark -- 控制器初始
-(void)initObject{
    self.isDataChange = NO;
    self.title = @"成员管理";
    if (self.isFriendIn||self.isFromNoteShare) {
        self.title = @"选择好友";
    }
    //添加输入监听
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //注册App从后台到前台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

}
#pragma mark -- 获取数据
-(void)getData{
    //获取到所有联系人信息作为搜索源
    [self getContactDataIsFirst:YES];
    //存储最原始的数据
    self.tempMemberArr = [NSMutableArray arrayWithArray:self.member_dataArr];
}
//isFirst:yes---表示初次进入控制器，no---用于从后台进入
-(void)getContactDataIsFirst:(BOOL)isFirst{
    // 先判断是否有权限
    if (self.requestContactPowerBlock) {
        void (^successBlock) (void) = ^{
            //1.获取通讯录中乱序的联系人数组 sourceArr
            NSMutableArray * sourcesArr = [AddressBookLocalHelper getAllSearchPeoplePhoneContactsInfo];
            self.search_originArr = sourcesArr;
        };
        self.requestContactPowerBlock(successBlock);
    }
    
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        //1.获取通讯录中乱序的联系人数组 sourceArr
//        NSMutableArray * sourcesArr = [AddressBookLocalHelper getAllSearchPeoplePhoneContactsInfo];
//        self.search_originArr = sourcesArr;
//        dispatch_async(dispatch_get_main_queue(), ^{
////            [self.reLoadingView hideProgress];
////            self.member_tableView.hidden = NO;
//        });
//    });
}
#pragma mark -- 初始化视图
-(void)initView{
    //设置tableView
    [self.member_tableView  registerNib:[UINib nibWithNibName:@"MCMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"MCMemberTableViewCell"];
    self.member_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.member_tableView.tableHeaderView = [[UIView alloc] init];
    self.member_tableView.backgroundColor = gMCColorRGB(248, 249, 251);
    self.textFiledBackgroundView.layer.cornerRadius = 4;
    self.addButton.layer.cornerRadius = 4;
    self.textField.layer.masksToBounds = YES;
    self.addButton.layer.masksToBounds = YES;
    //成员个数Label
    self.memberCountLabel.text = [self getMemberCountString: self.member_dataArr.count];
    
    if ((self.isFriendIn || self.isFromNoteShare) && self.member_dataArr.count <= 0) {
        self.emptyView.hidden = NO;
        self.rightItem.enabled = NO;
    }
    
//    if (self.isFriendIn) {
//        MBProgressHUD *progress = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.mbProgressHUD = progress;
//    }
    
    //导航栏按钮重写
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonDidClick:)];
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:(self.isFriendIn||self.isFromNoteShare) ? @"分享" : @"保存"  style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonDidClick:)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.rightItem.enabled = NO;
    
    self.addContactView.layer.masksToBounds = YES;
    self.addContactView.layer.cornerRadius = 4;
}

#pragma mark -- 代理方法
#pragma mark -- UITableViewDelegate
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.member_dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MCMemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MCMemberTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    MCShareContactSearchModel * model;
    if (indexPath.row < self.member_dataArr.count) {
        model = (MCShareContactSearchModel*)self.member_dataArr[indexPath.row];
    }
    NSString * shareName = (model.name&&(![model.name isEqualToString:@""]))?model.name:model.telNumber;
    cell.titleNameLabel.text = shareName;
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark -- textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length == 0) {
        if ((range.location + range.length) > textField.text.length){
            //7.1版本摇一摇撤销，防止截取长度后导致撤销长度越界崩溃问题
            textField.text = @"";
            return NO;
        }
    }
    
    //是否为退格
    BOOL isBackspace = [string isEqualToString:@""];
    //拼接字符串
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    if (isBackspace) {
        NSMutableString * tempString = [[NSMutableString alloc] initWithString:textField.text];
        [tempString replaceCharactersInRange:range withString:@""];
        futureString = tempString;
    } else {
        [futureString  insertString:string atIndex:range.location];
    }
    if (futureString.length > 11) {//大于11位数，非法
        return NO;
    }
    return YES;
    
}
#pragma mark -- MCMemberTableViewCellDelegate
-(void)deleteButtonTapAtIndexPaht:(NSIndexPath *)indexPath{
    //回收键盘
    [self.view endEditing:YES];
    
    //确认弹框
    MCShareContactSearchModel * model;
    if (self.member_dataArr.count > indexPath.row) {
        model = self.member_dataArr[indexPath.row];
    }
    NSString * nameString = nil;
    if (model.name && ![model.name isEqualToString:@""]) {
        nameString = [NSString stringWithFormat:@"确定将“%@”移出收件人名单", model.name];
    } else {
        nameString = [NSString stringWithFormat:@"确定将“%@”移出收件人名单", model.telNumber];
    }
    MCSCAlertView * alertView = [MCSCAlertView popAlertViewWithTitle:@"" message:nameString leftButtonTitle:@"取消" rightButtonTitle:@"删除"];
    alertView.leftButtonTitleColor = gMCColorWithHex(0x999999, 1.0);
    alertView.rightButtonTitleColor = [UIColor redColor];
    alertView.delegate = self;
    alertView.tag = 850;
    self.selected_row = indexPath.row;
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
}
#pragma mark -- MCAlertViewDelegate
-(void)alertView:(MCSCAlertView *)view didClickAtIndex:(NSInteger)index{
    switch (index) {
        case 0://取消
            
            
            break;
        case 1:{
            if (view.tag == 850) {//删除
                //删除本地对应的数据
                if (self.selected_row < self.member_dataArr.count) {
                    MCShareContactSearchModel * model = self.member_dataArr[self.selected_row];
                    [self addMemberModel:model];
                    [self updataMemberArrWithModel:model arr_input:self.deletedMemberArr arr_output:self.addMemberArr arr_origin:self.tempMemberArr type:2];
                    [self.member_dataArr removeObjectAtIndex:self.selected_row];
                    
                    //刷新UI
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.member_tableView reloadData];
                        weakSelf.memberCountLabel.text = [weakSelf getMemberCountString:weakSelf.member_dataArr.count];
                        if (weakSelf.member_dataArr.count <= 0) {
                            weakSelf.emptyView.hidden = NO;
                            weakSelf.rightItem.enabled = NO;
                        }
                    });
                }
            } else if(view.tag == 851){//放弃编辑
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        
        default:
            break;
    }
    
}
#pragma mark - MCContactsSearchListViewDelegate
- (void)contactsSearchListView:(MCContactsSearchListView *)view didSelectContact:(MCContactObject *)contact {
    //点击搜索出来结果列表的cell，添加到成员列表
    MCShareContactSearchModel * model = [[MCShareContactSearchModel alloc] init];
    model.name = [contact.name string];
    model.telNumber = [contact.phoneNum string];
    //先判断是否合法
    if (![self valiMobile:model.telNumber]) {
        [self showToast:@"请输入正确的手机号"];
        return;
    }
    //智能添加成员
    [self updataViewWithAddModel:model];
}
-(void)didScrollInView:(MCContactsSearchListView *)view{
    [self.view endEditing:YES];
}

#pragma mark -- 点击事件
//添加成员
- (IBAction)addMemberButtonAction:(UIButton *)sender {

    //回收键盘
    [self.view endEditing:YES];
    //首先判断格式是否正确
    if (![self valiMobile:self.textField.text]) {
        [self showToast:@"请输入正确的手机号"];
        return;
    }
    
    //判断是否为分享给自己
    if ([self isMyselfPhoneNumberWithString:self.textField.text]){
        [self showToast:@"您不能分享给自己"];
//        self.textField.text = nil;
        return;
    }
    
    //更新本地数据
    MCShareContactSearchModel * model = [[MCShareContactSearchModel alloc] init];
    model.name = @"";
    model.telNumber = self.textField.text;
    //判断是不是在搜索结果中有,并返回模型数据
    model = [self searchRsultArrContentModel:model];
    [self updataViewWithAddModel:model];
}
//跳转到通讯录
- (IBAction)pushToContactButtonAction:(UIButton *)sender {
    // 先判断是否有权限
    if (self.requestContactPowerBlock) {
        void (^successBlock) (void) = ^{
            [self gotoLocalContactVC];
        };
        self.requestContactPowerBlock(successBlock);
    }
}

- (void)gotoLocalContactVC {
    MCContactsViewController * vc = [[MCContactsViewController alloc] init];

    __weak typeof(self) weakSelf = self;
    vc.addedBlock = ^(NSArray<MCContactObject *> *contacts) {
        if (contacts.count == 0) {//没有选择联系人
            return ;
        }else{
            for (MCContactObject * objc in contacts) {
                //模型转换
                MCShareContactSearchModel * model = [weakSelf getContactModelWithContactObjc:objc];
                //智能添加到成员数组
                [weakSelf addMemberModel:model];
                //更新添加成员数组
                [weakSelf updataMemberArrWithModel:model arr_input:self.addMemberArr arr_output:self.deletedMemberArr arr_origin:self.tempMemberArr type:1];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.member_tableView reloadData];
                //改变人员数量
                weakSelf.memberCountLabel.text = [weakSelf getMemberCountString: weakSelf.member_dataArr.count];
                if (weakSelf.member_dataArr.count > 0) {
                    weakSelf.emptyView.hidden = YES;
                    weakSelf.rightItem.enabled = YES;
                } else {
                    weakSelf.emptyView.hidden = NO;
                    weakSelf.rightItem.enabled = NO;
                }
            });
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//返回按钮点击事件
-(void)leftBarButtonDidClick:(UIBarButtonItem*)sender{
    //确定是否有分享人员改动
    self.isDataChange = self.deletedMemberArr.count > 0||self.addMemberArr.count > 0;
    //有变更弹出确认弹框
    if (self.isDataChange) {
        MCSCAlertView * alertView = [MCSCAlertView popAlertViewWithTitle:@"" message:self.isFriendIn ? @"放弃此次好友分享的编辑？" : @"放弃此次共享人员的编辑？" leftButtonTitle:@"取消" rightButtonTitle:@"确认"];
        alertView.leftButtonTitleColor = gMCColorWithHex(0x999999, 1.0);
        alertView.rightButtonTitleColor = [UIColor redColor];
        alertView.tag = 851;
        alertView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    }else{
        
        [self.navigationController popViewControllerAnimated: YES];
    }
}
//保存按钮点击事件
-(void)rightBarButtonDidClick:(UIButton*)sender{
    //判断人数是否超出限制
    if (self.member_dataArr.count > 50) {
        [self showToast:@"共享人数超出限制"];
        return;
    }
    if (_isFromNoteShare && self.noteSigninChosenMemberBlock) {
        // MCShareContactSearchModel
//        NSMutableArray *member_dataArr = [self.member_dataArr yy_modelToJSONObject];
//        self.noteSigninChosenMemberBlock(YES, member_dataArr);
        self.noteSigninChosenMemberBlock(YES, self.member_dataArr);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//文本框输入变化
-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if ([self isStringContainNumberWith:theTextField.text]||(theTextField.text.length <= 3 && [self isNum:theTextField.text])) {//包含英文
        [self.search_dataArr removeAllObjects];
        [self removeSearchListView];
        [self deleteCoverView];
    }else if((theTextField.text.length >= 4 && [self isNum:theTextField.text])||[self IsChinese:theTextField.text]){//纯数字且超过4个，或者汉字则进行搜索
        self.search_dataArr = [self searchContactWithSearchText:theTextField.text resourceArr:self.search_originArr];
        if (self.search_dataArr.count == 0) {
            [self removeSearchListView];
            [self deleteCoverView];
        } else {
            [self addCoverView];
            [self changeSearchTableViewSizeWithDataArrCount:self.search_dataArr.count];
        }
        
    }
}
//从后台到前台通知事件
- (void)willEnterForeground:(NSNotification *)notification {
    //重新获取联系人
    [self getContactDataIsFirst:NO];
}


#pragma mark -- 私有方法
//改变搜索结果tableView
-(void)changeSearchTableViewSizeWithDataArrCount:(NSUInteger)count{
    CGFloat tableView_h = count * 55;
    if (tableView_h > CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.textFiledBackView.frame)) {
        tableView_h = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.textFiledBackView.frame);
    }
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.textFiledBackView.frame), SCREEN_WIDTH, tableView_h);
    if (!self.searchListView) {
        //初始化搜索列表
        _searchListView = [[MCContactsSearchListView alloc] initWithFrame:frame];
        _searchListView.delegate = self;
        [self.view addSubview:_searchListView];
    }else{
        self.searchListView.frame = CGRectMake(0, CGRectGetMaxY(self.textFiledBackView.frame), SCREEN_WIDTH, tableView_h);
    }
    self.searchListView.dataSource = self.search_dataArr;
}
-(void)removeSearchListView{
    if (self.searchListView) {
        [self.searchListView removeFromSuperview];
        [self.search_dataArr removeAllObjects];
        self.searchListView = nil;
    }
}
//添加蒙版
-(void)addCoverView{
    if (!self.coverView&&self.search_dataArr.count != 0) {
        self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textFiledBackView.frame), SCREEN_WIDTH, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.textFiledBackView.frame))];
        self.coverView.backgroundColor = [UIColor blackColor];
        self.coverView.alpha = 0.4;
        [self.view addSubview:self.coverView];
        [self.view insertSubview:self.coverView belowSubview:self.searchListView];
    }
}
//删除蒙版
-(void)deleteCoverView{
    if (self.coverView) {
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }
}

//去掉+86或86，获取11位电话号码
-(NSString*)get11PhoneNumber:(NSString *)phoneNo
{
    //@系统号码去掉86
    NSString *telNo = [phoneNo sc_telephoneWithReformat];
    if ([telNo hasPrefix:@"86"])
    {
        telNo = [telNo substringWithRange:NSMakeRange(2, [telNo length]-2)];
    }else if ([telNo hasPrefix:@"+86"])
    {
        telNo = [telNo substringWithRange:NSMakeRange(3, [telNo length]-3)];
    }
    telNo = [telNo stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return telNo;
}
//判断输入的字符串是否有中文
-(BOOL)IsChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)//判断输入的是否是中文
        {
            return YES;
        }
    }
    return NO;
}
- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}
//搜索匹配
-(NSMutableArray<MCContactObject *> *)searchContactWithSearchText:(NSString *)searchText resourceArr:(NSMutableArray<LocalAddressBookModel *> *)resourceArr {
    NSMutableArray<MCContactObject *> *matchArray = [[NSMutableArray alloc] init];
    
    NSString *regex = @"^\[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",  regex];
    BOOL isAllNumbers = [predicate evaluateWithObject:searchText];
        for(LocalAddressBookModel *model in resourceArr){
            NSArray *arr = model.searchContactModelArr;
            for (SearchContactModel *curSearchModel in arr) {
                if (isAllNumbers) {
                    //一.如果是纯数字则匹配手机号和名字
                    if ([curSearchModel.phoneNum sc_containsString:searchText] ||
                        [curSearchModel.compositeName sc_containsString:searchText]) {
                        MCContactObject *contact = [[MCContactObject alloc] init];
                        contact.name = [self getHightLightStringWithOriginal:curSearchModel.compositeName matchString:searchText normalColor:[UIColor blackColor] heightLightColor:gMCColorWithHex(0xff725b, 1.0)];
                        contact.phoneNum = [self  getHightLightStringWithOriginal:curSearchModel.phoneNum matchString:searchText normalColor:gMCColorWithHex(0x000000, 1.0) heightLightColor:gMCColorWithHex(0xff725b, 1.0)];
                        //名字可能为空
                        if (contact.name.length == 0) {
                            contact.name = contact.phoneNum;
                        }
                        [matchArray addObject:contact];
                    }
                }else {
                    //二.如果不是纯数字则只匹配名字
                    BOOL isMatch = NO;
                    if ([[curSearchModel.compositeName uppercaseString]
                         sc_containsString:[searchText uppercaseString]]) {
                        //1.名字匹配
                        isMatch = YES;
                    }else if ([model.firstLetterString sc_containsString:[searchText uppercaseString]]) {
                        //2.拼音首字母匹配
                        isMatch = YES;
                    }else {
                        NSString *pinyin = [model.pinYinName stringByReplacingOccurrencesOfString:@" " withString:@""];
                        if ([[pinyin uppercaseString] sc_containsString:[searchText uppercaseString]]){
                            //3.拼音匹配
                            isMatch = YES;
                        }
                    }
                    if (isMatch) {
                        MCContactObject *contact = [[MCContactObject alloc] init];
                        contact.name = [self getHightLightStringWithOriginal:curSearchModel.compositeName matchString:searchText normalColor:[UIColor blackColor] heightLightColor:gMCColorWithHex(0xff725b, 1.0)];
                        contact.phoneNum = [[NSAttributedString alloc] initWithString:curSearchModel.phoneNum];
                        //名字可能为空
                        if (contact.name.length == 0) {
                            contact.name = contact.phoneNum;
                        }
                        [matchArray addObject:contact];
                    }
                }
            }
        }
    return matchArray;
}
//将匹配到的字符串显示高亮
- (NSAttributedString *)getHightLightStringWithOriginal:(NSString *)original
                                            matchString:(NSString *)matchString
                                            normalColor:(UIColor *)normalColor
                                       heightLightColor:(UIColor *)heightLightColor {
    if (!original && original.length == 0) {
        return [[NSMutableAttributedString alloc] init];
    }
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:original];
    [result addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(0, original.length)];
    
    NSInteger locationOffset = 0;
    NSRange range = [original rangeOfString:matchString];
    while (range.location != NSNotFound && range.length != 0) {
        range.location = range.location + locationOffset;
        locationOffset = range.location + range.length;
        [result addAttribute:NSForegroundColorAttributeName value:heightLightColor range:range];
        
        if (original.length > locationOffset) {
            original = [original substringFromIndex:locationOffset];
            range = [original rangeOfString:matchString];
        }else {
            break;
        }
    }
    
    return result;
}
//提示框
- (void)showToast:(NSString *)text{
    if (text == nil) {
        return;
    }

    NSLog(@"%@", text);
    
    [PMSCToastView toastWithText:text];
}
//添加一个成员到成员数组
-(void)addMemberModel:(MCShareContactSearchModel*)model{
    //去重再添加
    BOOL isExist = NO;
    for (int i =0; i < self.member_dataArr.count; i++) {
        MCShareContactSearchModel * model_i = self.member_dataArr[i];
        if ([model_i.telNumber isEqualToString: model.telNumber]) {
            isExist = YES;
            //存在就替换
            [self.member_dataArr replaceObjectAtIndex:i withObject:model];
            break;
        }
    }
    if (!isExist) {
        [self.member_dataArr insertObject:model atIndex:0];
    }
}

/**
 * 将真实有效的删除数据模型放到删除数组中；将真实有效的添加数据模型放到添加数组中。
 * 其实就是4种情况:单独添加A;单独删除A;删除A再添加A;添加A再删除A
 * model:   要操作的数据模型
 * arr_input: 添加的成员存储的数组
 * arr_output: 删除的成员存储的数组
 * arr_origin:比对数组,即源成员数据数组
 * type: 1/添加到添加数组；2/添加到删除数组
*/
-(void)updataMemberArrWithModel:(MCShareContactSearchModel*)model arr_input:(NSMutableArray *)arr_input arr_output:(NSMutableArray*)arr_output arr_origin:(NSMutableArray*)arr_origin type:(NSInteger)type{
    //判断arr_origin中是否有model
    BOOL isExist_0 = NO;
    for (int i =0; i < arr_origin.count; i++) {
        MCShareContactSearchModel * model_i = arr_origin[i];
        if ([model_i.telNumber isEqualToString: model.telNumber]) {
            isExist_0 = YES;
            break;
        }
    }
    if ((isExist_0 && type == 2)||(isExist_0 == NO && type == 1)) {//在源数据中有，且是进行删除的操作;或者在源数据中没有，且进行的是添加操作。
        //判断在第一个数组中有没有该数据模型，有则不需要重复添加
        BOOL isExist_1 = NO;
        for (int i =0; i < arr_input.count; i++) {
            MCShareContactSearchModel * model_i = arr_input[i];
            if ([model_i.telNumber isEqualToString: model.telNumber]) {
                isExist_1 = YES;
                break;
            }
        }
        if (!isExist_1) {
            [arr_input addObject:model];
        }
    }else if((isExist_0 && type == 1) || (isExist_0 == NO && type == 2)){//在源数据中有，且进行的是添加操作;在源数据中没有，且进行的是删除操作
        //先判断，output里面有没有,有的话要将output中的该数据模型删掉
        for (int i =0; i < arr_output.count; i++) {
            MCShareContactSearchModel * model_i = arr_output[i];
            if ([model_i.telNumber isEqualToString: model.telNumber]) {
                [arr_output removeObjectAtIndex:i];
                break;
            }
        }
    }
}
//判断文本框输入的电话号码是否在筛选结果中包含
-(MCShareContactSearchModel*)searchRsultArrContentModel:(MCShareContactSearchModel*)model{
    for (MCContactObject * obj in self.search_dataArr) {
        MCShareContactSearchModel * model_j = [self getContactModelWithContactObjc:obj];
        if ([model_j.telNumber isEqualToString:model.telNumber]) {
            return model_j;
        }
    }
    return model;
}
//将属性模型转换为可直接使用的非属性模型
-(MCShareContactSearchModel*)getContactModelWithContactObjc:(MCContactObject*)objc{
    MCShareContactSearchModel * model = [[MCShareContactSearchModel alloc] init];
    model.name = [objc.name string];
    model.telNumber = [objc.phoneNum string];
    return model;
}
//将非属性模型转换为属性模型
-(NSArray<MCContactObject*>*)getContactObjcsWithContactModels:(NSMutableArray<MCShareContactSearchModel*>*)models{
    NSMutableArray * tempArr = [[NSMutableArray alloc] init];
    for (MCShareContactSearchModel * model in models) {
        MCContactObject * objc = [[MCContactObject alloc] init];
        objc.phoneNum = [[NSAttributedString alloc] initWithString:model.telNumber];
        objc.name = [[NSAttributedString alloc] initWithString:model.name];
        [tempArr addObject:objc];
    }
    return [[NSArray alloc] initWithArray:tempArr];
}
//判断两个成员个数相等的数组是否相等
-(BOOL)comparisonArray1:(NSMutableArray<MCShareContactSearchModel *> *)array1 array2:(NSMutableArray<MCShareContactSearchModel *> *)array2{
    if (array1.count != array2.count) {
        return NO;
    }
    int index = 0;
    NSInteger count = 0;//记录计算次数
    BOOL isEqual = NO;
    for (int i = 0; i < array1.count; i++) {
        MCShareContactSearchModel * model_i = array1[i];
        for (int j = index; j < array2.count; j++) {
            MCShareContactSearchModel * model_j = array2[j];
            count++;
            if ([model_i.telNumber isEqualToString:model_j.telNumber]) {
                isEqual = YES;
                [array2 exchangeObjectAtIndex:j withObjectAtIndex:0];
                index++;
                break;
            }else{
                isEqual = NO;
            }
        }
        if (isEqual == NO) {
            return NO;
        }
    }
    return YES;
}
//根据添加成员进行一系列的处理
-(void)updataViewWithAddModel:(MCShareContactSearchModel*)model{
    //智能添加到成员数组
    [self addMemberModel:model];
    //更新添加成员数组
    [self updataMemberArrWithModel:model arr_input:self.addMemberArr arr_output:self.deletedMemberArr arr_origin:self.tempMemberArr type:1];
    //隐藏搜索列表
    [self removeSearchListView];
    [self deleteCoverView];
    //刷新列表
    [self.member_tableView reloadData];
    //改变人员数量
    self.memberCountLabel.text = [self getMemberCountString: self.member_dataArr.count];
    //去掉textField的字符串
    self.textField.text = nil;
    
    if (self.member_dataArr.count > 0) {
        self.emptyView.hidden = YES;
        self.rightItem.enabled = YES;
    }
    
    //收起键盘
    [self.view endEditing:YES];
}
//获取成员个数字符串
-(NSString*)getMemberCountString:(NSUInteger)count{
    return [NSString stringWithFormat:@"(%ld/50人)",(unsigned long)count];
}
// 联系人匹配
- (NSString *)queryContactNameByPhoneNumber:(NSString *)number
{
    if (number.length > 0){
        NSString * name = [AddressBookLocalHelper getAddressBookFullNameByPhoneNumber:number];

        if ([name length] > 0) {
        }else {
            name = number;
        }
        return name;
    }
    return nil;
}
//判断是不是电话号码
- (BOOL)valiMobile:(NSString *)mobile{
    if (mobile.length != 11)
    {
        return NO;
    }
    NSString *MOBILE = @"^1([0-9])\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    if ([regextestmobile evaluateWithObject:mobile] == YES){
        return YES;
    }else{
        return NO;
    }
}
//判断是否包含英文
- (BOOL)isStringContainNumberWith:(NSString *)str {
    
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        
        return YES;
    }
    return NO;
}

#pragma mark -- 发送共享
//校验是否分享给自己
- (BOOL)isMyselfPhoneNumberWithString:(NSString*)inputNumber
{
//    NSString *account = [[LoginManager sharedInstance] mobileNo];
//    NSString *numType = [NSString stringWithFormat:@"86%@", account];
//    NSString *numAnotherType = [NSString stringWithFormat:@"+86%@", account];
//
//    if ([inputNumber isEqualToString:account] ||
//        [inputNumber isEqualToString:numType] ||
//        [inputNumber isEqualToString:numAnotherType])
//    {
////        //不能分享给自己
////        [self showAlertMessage:
////         @"您不能分享给自己"];
//        return YES;
//    }
    return NO;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotification-SharerDismiss" object:nil];
}

#pragma mark -- 懒加载
-(NSMutableArray *)search_dataArr{
    if (!_search_dataArr) {
        _search_dataArr = [[NSMutableArray alloc] init];
    }
    return _search_dataArr;
}
-(NSMutableArray *)search_originArr{
    if (!_search_originArr) {
        _search_originArr = [[NSMutableArray alloc] init];
    }
    return _search_originArr;
}
-(NSMutableArray *)member_dataArr{
    if (!_member_dataArr) {
        _member_dataArr = [[NSMutableArray alloc] init];
    }
    return _member_dataArr;
}
-(NSMutableArray *)tempMemberArr{
    if (!_tempMemberArr) {
        _tempMemberArr = [[NSMutableArray alloc] init];
    }
    return _tempMemberArr;
}
-(NSMutableArray *)addMemberArr{
    if (!_addMemberArr) {
        _addMemberArr = [[NSMutableArray alloc] init];
    }
    return _addMemberArr;
}
-(NSMutableArray *)deletedMemberArr{
    if (!_deletedMemberArr) {
        _deletedMemberArr = [[NSMutableArray alloc] init];
    }
    return _deletedMemberArr;
}

// todo
//- (UIView *)emptyView {
//    if (!_emptyView) {
//        _emptyView = [[UIView alloc] init];
//        _emptyView.backgroundColor = gMCColorWithHex(0xF8F9FB, 1.0);
//        _emptyView.hidden = YES;
//        [self.view addSubview:_emptyView];
//
//        __weak typeof(self) weakSelf = self;
//        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf.pushContactButton.mas_bottom);
//            make.left.right.bottom.mas_offset(0);
//        }];
//
//        UIImageView *emptyIV = [[UIImageView alloc] init];
//        emptyIV.image = [UIImage imageNamed:@"nofriends_empty_img"];
//        [_emptyView addSubview:emptyIV];
//
//
//        [emptyIV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_offset(106);
//            make.centerX.equalTo(weakSelf.view.mas_centerX);
//            make.width.mas_equalTo(221);
//            make.height.mas_equalTo(140);
//        }];
//
//        UILabel *tipsLabel = [[UILabel alloc] init];
//        tipsLabel.text = @"未添加好友";
//        tipsLabel.textColor = gMCColorWithHex(0x001026, 0.3);
//        tipsLabel.textAlignment = NSTextAlignmentCenter;
//        tipsLabel.font = [UIFont systemFontOfSize:14];
//        [_emptyView addSubview:tipsLabel];
//
//        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(emptyIV.mas_bottom).mas_offset(16);
//            make.left.right.mas_offset(0);
//            make.height.mas_equalTo(20);
//        }];
//    }
//    return _emptyView;
//}

@end

#if MC_THEME_EXTENSION
@implementation MCMemberManagerViewCotroller (MCThemeExtensions)
@end
#endif
