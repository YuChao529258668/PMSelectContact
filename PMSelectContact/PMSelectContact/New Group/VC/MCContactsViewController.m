//
//  MCContactsViewController.m
//  mCloud_iPhone
//
//  Created by 潘天乡 on 17/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import "MCContactsViewController.h"

//#import "LoadingProgressView.h"
#import "MCAlertView.h"
//#import "MCToastView.h"

#import "NSString+Extend.h"
#import "MCContactObject.h"
#import "MCContactHelper.h"

#import "LocalAddressBookModel.h"
#import "pinyin.h"
#import "MyPhonePublicDefine.h"

#import "MultiSelectTableViewCell.h"
#import "MCContactsSearchListView.h"


//#import "MCSearchCoreManager.h"
//#import "AddressBookManager.h"
#import "AddressBookLocalHelper.h"

static NSString *const cellReuseIdentifier = @"cellReuseIdentifier";

@interface MCContactsViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
MultiSelectTableViewCellDelegate,
MCContactsSearchListViewDelegate,
MCAlertViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) LoadingProgressView *loadingView;

@property (nonatomic, strong) UIView *searchBgView;
@property (nonatomic, strong) UIView *textFieldBgView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, assign) CGRect textField_originalFrame;
@property (nonatomic, strong) UIImageView *findImageView;
@property (nonatomic, strong) UIButton *cancelSearchButton;

@property (nonatomic, strong) MCContactsSearchListView *searchListView;
@property (nonatomic, strong) UIView *searchListBgView;

@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray<MCContactObject *> *selectedDatas;

@property (nonatomic, assign) BOOL isShowLoadingView;

@end

@implementation MCContactsViewController

#pragma mark - Lifecircle
- (instancetype)init {
    return [[[self class] alloc] initWithContacts:nil];
}

- (instancetype)initWithContacts:(NSArray<MCContactObject *> *)contacts {
    self = [super init];
    if (self) {
        self.selectedDatas = [NSMutableArray arrayWithArray:contacts];
        self.dataSource = [NSMutableArray array];
        self.titleArr = [NSMutableArray array];
        self.isShowLoadingView = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    [self fetchLocalContacts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect newFrame = _tableView.frame;
    
    //适配iphonex安全区域
    CGFloat safeAreaInsetsBottom=0;
    if (@available(iOS 11.0, *)) {
        safeAreaInsetsBottom = self.view.safeAreaInsets.bottom;
    }
    newFrame.size.height = self.view.frame.size.height - CGRectGetMaxY(self.searchBgView.frame) - safeAreaInsetsBottom;
    
    _tableView.frame = newFrame;
    _searchListBgView.frame = newFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)setupUI {
    [self _setTitle];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 55.0)];
    searchBgView.backgroundColor = [UIColor whiteColor];
    self.searchBgView = searchBgView;
    [self.view addSubview:searchBgView];
    
    UIView *textFieldBgView = [[UIView alloc] initWithFrame:CGRectMake(18.0, (CGRectGetHeight(searchBgView.frame) - 35.0) / 2, CGRectGetWidth(searchBgView.frame) - 2 * 18.0, 35.0)];
    textFieldBgView.backgroundColor = gMCColorWithHex(0xF7F7F7, 1.0);
    textFieldBgView.layer.cornerRadius = 4.0;
    [searchBgView addSubview:textFieldBgView];
    self.textFieldBgView = textFieldBgView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginInput)];
    [textFieldBgView addGestureRecognizer:tap];
    
    CGFloat textField_x = CGRectGetWidth(textFieldBgView.frame) / 2 - 50.0;
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(textField_x, 0, CGRectGetWidth(textFieldBgView.frame) - textField_x, CGRectGetHeight(textFieldBgView.frame))];
    searchTextField.backgroundColor = gMCColorWithHex(0xF7F7F7, 1.0);
    searchTextField.layer.cornerRadius = 4.0;
    searchTextField.textColor = [UIColor blackColor];
    searchTextField.font = [UIFont systemFontOfSize:14.0];
    searchTextField.textAlignment = NSTextAlignmentLeft;
    searchTextField.delegate = self;
    searchTextField.placeholder = NSLocalizedString(@"搜索联系人", nil);
    searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, 1.0)];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textFieldBgView addSubview:searchTextField];
    self.searchTextField = searchTextField;
    self.textField_originalFrame = searchTextField.frame;
    
    UIImage *findImage = [UIImage imageNamed:@"common_findFiles"];
    UIImageView *findImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(searchTextField.frame) - findImage.size.width, (CGRectGetHeight(textFieldBgView.frame) - findImage.size.height) / 2, findImage.size.width, findImage.size.height)];
    findImageView.image = findImage;
    [textFieldBgView addSubview:findImageView];
    self.findImageView = findImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBgView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.searchBgView.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionIndexColor = gMCThemeColor;
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.allowsSelectionDuringEditing = YES;
        _tableView.hidden = YES;
        [_tableView registerClass:[MultiSelectTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] < 13.0) {
            _tableView.estimatedRowHeight = 0;  //fix bug 22113
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//- (LoadingProgressView *)loadingView {
//    if (!_loadingView) {
//        _loadingView = [[LoadingProgressView alloc] init];
//    }
//    return _loadingView;
//}

- (MCContactsSearchListView *)searchListView {
    if (!_searchListView) {
        _searchListView = [[MCContactsSearchListView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.searchListBgView.frame), 0.0)];
        _searchListView.delegate = self;
        [self.searchListBgView addSubview:_searchListView];
    }
    return _searchListView;
}

- (UIView *)searchListBgView {
    if (!_searchListBgView) {
        _searchListBgView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        _searchListBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _searchListBgView.hidden = YES;
        [self.view addSubview:_searchListBgView];
    }
    return _searchListBgView;
}

- (UIButton *)cancelSearchButton {
    if (!_cancelSearchButton) {
        _cancelSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelSearchButton.frame = CGRectMake(CGRectGetWidth(self.searchBgView.frame), (CGRectGetHeight(self.searchBgView.frame) - 35.0) / 2, 60.0, 35.0);
        _cancelSearchButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _cancelSearchButton.backgroundColor = gMCThemeColor;
        [_cancelSearchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelSearchButton.layer.cornerRadius = 4.0;
        [_cancelSearchButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_cancelSearchButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
        _cancelSearchButton.hidden = YES;
        [self.searchBgView addSubview:_cancelSearchButton];
    }
    return _cancelSearchButton;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] init];
        _emptyView.hidden = YES;
        [self.view addSubview:_emptyView];
        
        UIImage *icon = [UIImage imageNamed:@"common_no_contact"];
        UIImageView *emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.0, icon.size.width, icon.size.height)];
        emptyImageView.image = icon;
        [_emptyView addSubview:emptyImageView];
        
        UIFont *font = [UIFont systemFontOfSize:16.0];
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(emptyImageView.frame) + 20.0, CGRectGetWidth(emptyImageView.frame), font.lineHeight)];
        emptyLabel.font = font;
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.textColor = gMCColorWithHex(0x666666, 1.0);
        emptyLabel.text = NSLocalizedString(@"暂无联系人", nil);
        [_emptyView addSubview:emptyLabel];
        
        _emptyView.frame = CGRectMake((CGRectGetWidth(self.view.frame) - CGRectGetWidth(emptyImageView.frame)) / 2, 182.0, CGRectGetWidth(emptyImageView.frame), CGRectGetMaxY(emptyLabel.frame));
    }
    return _emptyView;
}

- (void)_setTitle {
    NSString *title = NSLocalizedString(@"联系人", nil);
    if (self.selectedDatas.count > 0) {
        title = [NSString stringWithFormat:@"%@（已选%ld）", title, (unsigned long)self.selectedDatas.count];
    }
    self.title = title;
}

- (void)showRightButton:(BOOL)show {
    if (show) {
        UIButton *Button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0, 22.0f)];
        [Button setTitle:NSLocalizedString(@"添加", nil) forState:UIControlStateNormal];
        Button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [Button setTitleColor:gMCThemeColor forState:UIControlStateNormal];
        [Button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [Button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:Button];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - Data
//获取本地通讯录
- (void)fetchLocalContacts {
    if (_isShowLoadingView) {
//        [self.loadingView showProgressWithTitle:NSLocalizedString(@"加载中...", nil) inView:self.view];
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //1.获取通讯录中乱序的联系人数组 sourceArr
        NSMutableArray *sourcesArr = [AddressBookLocalHelper getAllSearchPeoplePhoneContactsInfo];
        //2.获取排好序的数据源，电话号码合法性检测处理
        self.dataSource = [[self getRankedDataArrWithArr:sourcesArr] mutableCopy];
        
        //3.如果是从后台进入前台重新获取通讯录，则需要同步已选联系人（self.selectedDatas）
        NSMutableArray *tempSlectArr = [NSMutableArray arrayWithArray:self.selectedDatas];
        [self.selectedDatas removeAllObjects];
        if (self.dataSource.count > 0 && tempSlectArr.count > 0) {
            for (NSMutableArray *array in self.dataSource) {
                for(LocalAddressBookModel *model in array){
                    NSArray *arr = model.searchContactModelArr;
                    for (SearchContactModel *curSearchModel in arr) {
                        NSString *curPhoneNum = curSearchModel.phoneNum;
                        for (MCContactObject *contact in tempSlectArr) {
                            NSString *forePhoneNum = contact.phoneNum.string;
                            if (contact.addressRecordID == model.addressRecordID &&
                                [curPhoneNum isEqualToString:forePhoneNum]) {
                                //标记之前选中的号码
                                curSearchModel.isSelect = YES;
                                
                                //重新添加已选
                                MCContactObject *newContact = [[MCContactObject alloc] init];
                                newContact.addressRecordID = model.addressRecordID;
                                newContact.phoneNum = [[NSAttributedString alloc] initWithString:curSearchModel.phoneNum];
                                if (curSearchModel.compositeName.length == 0) {
                                    newContact.name = newContact.phoneNum;
                                }else {
                                    newContact.name = [[NSAttributedString alloc] initWithString:curSearchModel.compositeName];
                                }
                                [self.selectedDatas addObject:newContact];
                            }
                        }
                    }
                    
                    //只要选了其中一个手机号，就标记该联系人已选
                    BOOL isAllSelected = NO;
                    for (SearchContactModel *searchModel in arr) {
                        if ([searchModel isSelect]) {
                            isAllSelected = YES;
                            break;
                        }
                    }
                    model.isSelected = isAllSelected;
                }
            }
        }
        
        //4.主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isShowLoadingView) {
//                [self.loadingView hideProgress];
            }else {
                self.isShowLoadingView = YES;
            }
            
            [self _setTitle];
            if (self.dataSource.count > 0) {
                [self showRightButton:YES];
                self.tableView.hidden = NO;
                _emptyView.hidden = YES;
                
                [self.tableView reloadData];
            }else {
                [self showRightButton:NO];
                _tableView.hidden = YES;
                self.emptyView.hidden = NO;
            }
        });
    });
}

- (NSMutableArray *)getRankedDataArrWithArr:(NSMutableArray *)sourceArr{
    [self.titleArr removeAllObjects];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < 27; i++) {
        [tempArr addObject:[NSMutableArray array]];
    }
    for (int i = 0; i < [sourceArr count]; i++) {
        //查询sectionName的第一个字母看是否是A-Z中的一个，是就加入相应数组
        LocalAddressBookModel *contactObj = sourceArr[i];
        NSUInteger firstLetter = [ALPHA rangeOfString:[contactObj.nameFirstLetter substringToIndex:1]].location;
        if (firstLetter != NSNotFound){// 有号码联系人按首字母分组展示，
            if (i < [sourceArr count]){
                [[tempArr objectAtIndex:firstLetter] addObject:contactObj];
            }
        } else {//无号码联系人存入#数组
            if (i < [sourceArr count]){
                [[tempArr objectAtIndex:26] addObject:contactObj];
            }
        }
    }
    
    NSMutableArray *sectionArray = [NSMutableArray array];
    
    NSMutableArray *nameArray=[[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",
                               @"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",
                               @"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#",nil];
    for (int i = 0; i < 27; i++)
    {
        NSMutableArray *subTempArr = [tempArr objectAtIndex:i];
        if ([subTempArr count]!=0)
        {
            [sectionArray addObject:[self storeContenctName:subTempArr]];
            [self.titleArr addObject:[nameArray objectAtIndex:i]];
        }
    }
    return sectionArray;
}

//对名字排序
- (NSArray *)storeContenctName:(NSMutableArray *)contactArray
{
    return  [contactArray  sortedArrayUsingComparator:^NSComparisonResult(LocalAddressBookModel *obj1,
                                                                          LocalAddressBookModel *obj2)
             {
                 if ([obj1.pinYinName  compare:obj2.pinYinName
                                       options:NSCaseInsensitiveSearch] ==NSOrderedDescending)
                 {
                     return NSOrderedDescending;
                 }
                 return NSOrderedSame;
                 
             }];
}

//去掉+86或86，获取11位电话号码
-(NSString*)get11PhoneNumber:(NSString *)phoneNo
{
    //@系统号码去掉86
    NSString *telNo = [phoneNo telephoneWithReformat];
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

#pragma mark - Notification Handler
- (void)willEnterForeground:(NSNotification *)notification {
    self.isShowLoadingView = NO;
    [self fetchLocalContacts];
}

#pragma mark - Event Handler
- (void)leftButtonAction {
    if (self.selectedDatas.count > 0) {
        MCAlertView *alertView = [MCAlertView popAlertViewWithTitle:nil message:NSLocalizedString(@"退出此次选择？", nil) leftButtonTitle:NSLocalizedString(@"取消", nil) rightButtonTitle:NSLocalizedString(@"确定", nil)];
        alertView.delegate = self;
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightButtonAction {
    if (self.selectedDatas.count > 0) {
        if (self.addedBlock) {
            self.addedBlock([NSArray arrayWithArray:self.selectedDatas]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        //恢复为未搜索状态之后再弹toast
        if (!self.searchListBgView.hidden) {
            self.searchListBgView.hidden = YES;
            [self endInput];
        }
//        [[MCToastView shareInstance] showInView:self.view withText:NSLocalizedString(@"请勾选联系人", nil) hideDelay:1.0];
    }
}

- (void)cancelSearch {
    [self endInput];
}

- (void)beginInput {
    if (!self.searchTextField.isFirstResponder) {
        [self.searchTextField becomeFirstResponder];
    }
    self.findImageView.hidden = YES;
    self.searchListBgView.hidden = NO;
    self.cancelSearchButton.hidden = NO;
    
    //动画：输入框的宽度向左缩小，取消搜索按钮向左进入屏幕
    CGFloat cancelX = CGRectGetWidth(self.searchBgView.frame) - 15.0 - 60.0;
    CGFloat textFieldWidth = cancelX - 10.0 - CGRectGetMinX(self.textFieldBgView.frame);
    [UIView animateWithDuration:0.20 animations:^{
        self.textFieldBgView.frame = CGRectMake(CGRectGetMinX(self.textFieldBgView.frame), CGRectGetMinY(self.textFieldBgView.frame), textFieldWidth, CGRectGetHeight(self.textFieldBgView.frame));
        self.searchTextField.frame = CGRectMake(0.0, 0.0, textFieldWidth, CGRectGetHeight(self.textFieldBgView.frame));
        self.cancelSearchButton.frame = CGRectMake(cancelX, CGRectGetMinY(self.cancelSearchButton.frame), CGRectGetWidth(self.cancelSearchButton.frame), CGRectGetHeight(self.cancelSearchButton.frame));
    }];
}

- (void)endInput {
    [self.searchTextField resignFirstResponder];
    self.findImageView.hidden = NO;
    self.searchTextField.text = @"";
    
    self.searchListBgView.hidden = YES;
    self.searchListView.dataSource = [NSMutableArray array];
    CGRect newFrame = self.searchListView.frame;
    newFrame.size.height = 0;
    self.searchListView.frame = newFrame;
    
    //动画：输入框的宽度向右放大还原，取消搜索按钮向右移出屏幕
    [UIView animateWithDuration:0.20 animations:^{
        self.textFieldBgView.frame = CGRectMake(18.0, (CGRectGetHeight(self.searchBgView.frame) - 35.0) / 2, CGRectGetWidth(self.searchBgView.frame) - 2 * 18.0, 35.0);
        self.searchTextField.frame = self.textField_originalFrame;
        self.cancelSearchButton.frame = CGRectMake(CGRectGetWidth(self.searchBgView.frame) , CGRectGetMinY(self.cancelSearchButton.frame), CGRectGetWidth(self.cancelSearchButton.frame), CGRectGetHeight(self.cancelSearchButton.frame));
    } completion:^(BOOL finished) {
        self.cancelSearchButton.hidden = YES;
    }];
}

- (void)endSearch {
    [self endInput];
}

//当显示搜索页面的时候，点击阴影处则结束搜索。
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    if (!self.searchListBgView.hidden) {
        //阴影面积(相对于整个屏幕) = 搜索背景面积 - 搜索列表面积
        CGFloat shadow_y = CGRectGetMinY(self.searchListBgView.frame) + CGRectGetMaxY(self.searchListView.frame);
        CGFloat shadow_height = CGRectGetHeight(self.searchListBgView.frame) - CGRectGetMaxY(self.searchListView.frame);
        CGRect shadowRect = CGRectMake(0.0, shadow_y, CGRectGetWidth(self.view.frame), shadow_height);
        if (CGRectContainsPoint(shadowRect, touchPoint)) {
            [self endSearch];
        }
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *tempArr = [self.dataSource objectAtIndex:section];
    return [tempArr count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  self.titleArr[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.titleArr;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = gMCColorWithHex(0xF7F7F7, 1.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocalAddressBookModel *ABModel = self.dataSource[indexPath.section][indexPath.row];
    return [MultiSelectTableViewCell getContentHeightWithContentModel:ABModel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultiSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    LocalAddressBookModel *contactObj = self.dataSource[indexPath.section][indexPath.row];
    [cell setCellContentWithModel:contactObj];
    cell.isEditing = self.selectedDatas.count > 0;
    return cell;
}

#pragma mark - MultiSelectTableViewCellDelegate
- (void)multiSelectTableViewCell:(MultiSelectTableViewCell *)mSelectTableCell onClicked:(NSInteger )tag {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:mSelectTableCell];
    LocalAddressBookModel *ABModel = self.dataSource[indexPath.section][indexPath.row];
    NSInteger modelIndex = tag - kCABASE_BTN_TAG ;
    if (modelIndex == 0) {
        //点击了全部选择或取消全部选择按钮的cell
        [self setCellAllPickWithABModel:ABModel];
    } else {
        //点击了只选择一个按钮的cell
        [self setCellRadioModeWithABModel:ABModel withModelIndex:modelIndex];
    }
    [self _setTitle];
    [self.tableView reloadData];
}

- (void)setCellAllPickWithABModel:(LocalAddressBookModel *)ABModel{
    NSArray *searchModelArr = ABModel.searchContactModelArr;
    ABModel.isSelected = !ABModel.isSelected;
    for (SearchContactModel *searchModel in searchModelArr)
    {
        if (ABModel.isSelected == YES) {
            if (![self isSelectedPhonesArrContainsObject:searchModel addressID:ABModel.addressRecordID])
            {
                searchModel.isSelect = YES;
                
                MCContactObject *contact = [[MCContactObject alloc] init];
                contact.addressRecordID = ABModel.addressRecordID;
                
                contact.phoneNum = [[NSAttributedString alloc] initWithString:searchModel.phoneNum];
                if (searchModel.compositeName.length == 0) {
                    contact.name = contact.phoneNum;
                }else {
                    contact.name = [[NSAttributedString alloc] initWithString:searchModel.compositeName];
                }
                [self.selectedDatas addObject:contact];
            }
        }
        else
        {
            searchModel.isSelect = NO;
            for (MCContactObject *contact in self.selectedDatas) {
                if (contact.addressRecordID == ABModel.addressRecordID && [contact.phoneNum.string isEqualToString:searchModel.phoneNum]) {
                    [self.selectedDatas removeObject:contact];
                    break;
                }
            }
        }
    }
}

- (void)setCellRadioModeWithABModel:(LocalAddressBookModel *)ABModel withModelIndex:(NSInteger)modelIndex{
    NSArray *searchModelArr = ABModel.searchContactModelArr;
    modelIndex --;
    
    SearchContactModel *selSearchModel = searchModelArr[modelIndex];
    selSearchModel.isSelect = !selSearchModel.isSelect;
    
    if (selSearchModel.isSelect == YES) {
        if (![self isSelectedPhonesArrContainsObject:selSearchModel addressID:ABModel.addressRecordID]) {
            MCContactObject *contact = [[MCContactObject alloc] init];
            contact.addressRecordID = ABModel.addressRecordID;
            contact.phoneNum = [[NSAttributedString alloc] initWithString:selSearchModel.phoneNum];
            if (selSearchModel.compositeName.length == 0) {
                contact.name = contact.phoneNum;
            }else {
                contact.name = [[NSAttributedString alloc] initWithString:selSearchModel.compositeName];
            }
            [self.selectedDatas addObject:contact];
        }
    } else {
        for (MCContactObject *contact in self.selectedDatas) {
            if (contact.addressRecordID == ABModel.addressRecordID &&
                [contact.phoneNum.string isEqualToString:selSearchModel.phoneNum]) {
                [self.selectedDatas removeObject:contact];
                break;
            }
        }
    }
    
    //只要选了其中一个手机号，就标记该联系人已选
    BOOL allSelect = NO;
    for (int i = 0; i < [searchModelArr count]; i++) {
        SearchContactModel *searchModel = searchModelArr[i];
        if (searchModel.isSelect == YES) {
            allSelect = YES;
            break;
        }
    }
    ABModel.isSelected = allSelect;
}

- (BOOL)isSelectedPhonesArrContainsObject:(SearchContactModel *)contactModel addressID:(uint32_t)addressID {
    for (MCContactObject *contact in self.selectedDatas) {
        if (contact.addressRecordID == addressID &&
            [contact.phoneNum.string isEqualToString:contactModel.phoneNum]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - MCContactsSearchListViewDelegate
- (void)contactsSearchListView:(MCContactsSearchListView *)view didSelectContact:(MCContactObject *)contact {
    for (NSMutableArray *array in self.dataSource) {
        for(LocalAddressBookModel *model in array){
            NSArray *arr = model.searchContactModelArr;
            for (SearchContactModel *curSearchModel in arr) {
                if (contact.addressRecordID == model.addressRecordID && [curSearchModel.phoneNum isEqualToString:contact.phoneNum.string]) {
                    curSearchModel.isSelect = YES;
                    if (![self isSelectedPhonesArrContainsObject:curSearchModel addressID:model.addressRecordID]) {
                        MCContactObject *contact = [[MCContactObject alloc] init];
                        contact.addressRecordID = model.addressRecordID;
                        contact.phoneNum = [[NSAttributedString alloc] initWithString:curSearchModel.phoneNum];
                        if (curSearchModel.compositeName.length == 0) {
                            contact.name = contact.phoneNum;
                        }else {
                            contact.name = [[NSAttributedString alloc] initWithString:curSearchModel.compositeName];
                        }
                        [self.selectedDatas addObject:contact];
                    }
                    break;
                }
            }
            
            //只要选了其中一个手机号，就标记该联系人已选
            BOOL isAllSelected = NO;
            for (SearchContactModel *searchModel in arr) {
                if ([searchModel isSelect]) {
                    isAllSelected = YES;
                    break;
                }
            }
            model.isSelected = isAllSelected;
        }
    }
    [self _setTitle];
    [self endInput];
    [self.tableView reloadData];
}

- (void)didScrollInView:(MCContactsSearchListView *)view {
    [self.searchTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self beginInput];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.searchListView.dataSource = [NSMutableArray array];
    CGRect newFrame = self.searchListView.frame;
    newFrame.size.height = 0;
    self.searchListView.frame = newFrame;
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *searchText = nil;
    if ([string isEqualToString:@"\n"])
    {
        searchText = textField.text;
    }else
    {
        searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (searchText.length == 0) {
        self.searchListView.dataSource = [NSMutableArray array];
    }else {
        self.searchListView.dataSource = [MCContactHelper searchContactWithSearchText:searchText resourceArr:self.dataSource];
    }
    
    //给定一个搜索列表展示的最大高度，搜索列表的高度跟随搜索的数据总数变化，但不能超过最大高度。
    CGFloat maxHeight = CGRectGetHeight(self.searchListBgView.frame);
    CGRect newFrame = self.searchListView.frame;
    CGFloat newHeight = [MCContactsSearchListView cellHeight] * self.searchListView.dataSource.count;
    if (newHeight > maxHeight) {
        newHeight = maxHeight;
    }
    newFrame.size.height = newHeight;
    self.searchListView.frame = newFrame;
    
    return YES;
}

#pragma mark - MCAlertViewDelegate
- (void)alertView:(MCAlertView *)view didClickAtIndex:(NSInteger)index {
    if (index == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
