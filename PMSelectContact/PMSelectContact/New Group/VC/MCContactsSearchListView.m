//
//  MCContactsSearchListView.m
//  mCloud_iPhone
//
//  Created by 潘天乡 on 19/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import "MCContactsSearchListView.h"
#import "MCContactsSearchListViewCell.h"

static NSString *const cellReuseIdentifier = @"cellReuseIdentifier";

@interface MCContactsSearchListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end;

@implementation MCContactsSearchListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - UI
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.allowsSelectionDuringEditing = YES;
        _tableView.hidden = YES;
        [_tableView registerClass:[MCContactsSearchListViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
        [self addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self class] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCContactsSearchListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    [cell configUIWithContact:_dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_delegate && [_delegate respondsToSelector:@selector(contactsSearchListView:didSelectContact:)]) {
        [_delegate contactsSearchListView:self didSelectContact:_dataSource[indexPath.row]];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(didScrollInView:)]) {
        [_delegate didScrollInView:self];
    }
}

#pragma mark - Public
+ (CGFloat)cellHeight {
    return [MCContactsSearchListViewCell cellHeight];
}

#pragma mark - Setter
- (void)setDataSource:(NSArray<MCContactObject *> *)dataSource {
    _dataSource = dataSource;
    
    if (dataSource.count == 0) {
        _tableView.hidden = YES;
    }else {
        self.tableView.hidden = NO;
    }
    [_tableView reloadData];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

@end
