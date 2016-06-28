//
//  LogOnViewController.m
//  Demo
//
//  Created by ruanqiaohua on 16/5/31.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "LogOnViewController.h"
#import "MainTabBarController.h"

@interface LogOnViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LogOnViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = NO;
    self.fd_interactivePopDisabled = YES;
    // Do any additional setup after loading the view.
}

- (IBAction)logOnBtnAction:(UIButton *)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_userNameTextField.text forKey:@"username"];
    [parameters setValue:_passwordTextField.text forKey:@"password"];
    //登陆
    __weak typeof(self) weakSelf = self;
    [[DataManager inst] logOn:parameters successCb:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)cancelBtnAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
