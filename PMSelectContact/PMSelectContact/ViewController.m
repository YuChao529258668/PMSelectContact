//
//  ViewController.m
//  PMSelectContact
//
//  Created by 余超 on 2021/10/13.
//

#import "ViewController.h"
#import "MCContactsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"联系人" forState:UIControlStateNormal];
//    btn setTitleColor:@"" forState:
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 200, 100, 50);
    [btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
}

- (void)jump {
    // 将成员数组传给联系人界面
    MCContactsViewController * vc = [[MCContactsViewController alloc] init];

//    __weak typeof(self) weakSelf = self;
//    vc.addedBlock = ^(NSArray<MCContactObject *> *contacts) {
//        if (contacts.count == 0) {//没有选择联系人
//            return ;
//        }else{
//            for (MCContactObject * objc in contacts) {
//                //模型转换
//                MCShareContactSearchModel * model = [weakSelf getContactModelWithContactObjc:objc];
//                //智能添加到成员数组
//                [weakSelf addMemberModel:model];
//                //更新添加成员数组
//                [weakSelf updataMemberArrWithModel:model arr_input:self.addMemberArr arr_output:self.deletedMemberArr arr_origin:self.tempMemberArr type:1];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.member_tableView reloadData];
//                //改变人员数量
//                weakSelf.memberCountLabel.text = [weakSelf getMemberCountString: weakSelf.member_dataArr.count];
//                if (weakSelf.member_dataArr.count > 0) {
//                    weakSelf.emptyView.hidden = YES;
//                    weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
//                } else {
//                    weakSelf.emptyView.hidden = NO;
//                    weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
//                }
//            });
//        }
//    };
//    [self.navigationController pushViewController:vc animated:YES];
    
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];

}

@end
