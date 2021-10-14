//
//  MCContactsSearchListView.h
//  mCloud_iPhone
//
//  Created by 潘天乡 on 19/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCContactObject;

@protocol MCContactsSearchListViewDelegate;

@interface MCContactsSearchListView : UIView

@property (nonatomic, weak) id<MCContactsSearchListViewDelegate> delegate;
@property(nonatomic, retain)NSArray<MCContactObject *> *dataSource;

+ (CGFloat)cellHeight;

@end

@protocol MCContactsSearchListViewDelegate <NSObject>
@optional
-(void)contactsSearchListView:(MCContactsSearchListView *)view didSelectContact:(MCContactObject*)contact;
-(void)didScrollInView:(MCContactsSearchListView *)view;

@end
