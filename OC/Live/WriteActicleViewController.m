//
//  WriteActicleViewController.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/9.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "WriteActicleViewController.h"

@interface WriteActicleViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation WriteActicleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [self.textView becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtnAction:(UIBarButtonItem *)sender {
    
    [self dismiss];
}

- (IBAction)sendBtnAction:(UIBarButtonItem *)sender {
    
    NSString *content = self.textView.text;
    if ([content isEqualToString:@""]) {
        return;
    }
    [self dismiss];

    [[DataManager inst] sendArticle:@{@"content":content} successCb:^{

    }];
}

- (void)dismiss {
    
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches.allObjects) {
        if (touch.view == self.view) {
            [self dismiss];
        }
    }
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
