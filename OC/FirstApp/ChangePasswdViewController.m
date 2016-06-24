//
//  ChangePasswdViewController.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/4.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "ChangePasswdViewController.h"

@interface ChangePasswdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *olbPasswdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwd2TextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@end

@implementation ChangePasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sureBtnAction:(UIButton *)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parameters setValue:_olbPasswdTextField.text forKey:@"oldPasswd"];
    [parameters setValue:_passwdTextField.text forKey:@"newPasswd"];
    [parameters setValue:_passwd2TextField.text forKey:@"newPasswd2"];
    
    __weak typeof(self) weakSelf = self;
    [[DataManager inst]changePasswd:parameters successCb:^{
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
