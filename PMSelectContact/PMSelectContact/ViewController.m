//
//  ViewController.m
//  PMSelectContact
//
//  Created by 余超 on 2021/10/13.
//

#import "ViewController.h"
#import "MCContactsViewController.h"
#import "MCMemberManagerViewCotroller.h"

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
    MCMemberManagerViewCotroller * vc = [[MCMemberManagerViewCotroller alloc] init];
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
