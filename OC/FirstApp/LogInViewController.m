//
//  LogInViewController.m
//  Demo
//
//  Created by ruanqiaohua on 16/5/31.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *password2TextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnAction:(UIButton *)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parameters setValue:_userNameTextField.text forKey:@"username"];
    [parameters setValue:_nicknameTextField.text forKey:@"nickname"];
    [parameters setValue:_passwordTextField.text forKey:@"password"];
    [parameters setValue:_password2TextField.text forKey:@"password2"];
    [parameters setValue:_emailTextField.text forKey:@"email"];
    
    __weak typeof(self) weakSelf = self;
    [[DataManager inst]logIn:parameters successCb:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
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
