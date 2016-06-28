//
//  RootViewController.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/4.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "RootViewController.h"
#import "UIImageView+WebCache.h"
#import "DataManager.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURL *imageUrl = [NSURL URLWithString:gSession.backgroundUrl];
    [_backgroundImg sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"background"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    //获取系统配置
    [self getSystemConfig];
}

- (void)getSystemConfig {
    
    [[DataManager inst] getSystemConfig:nil successCb:^(id object) {
        gSession.backgroundUrl = object[@"backgroundUrl"];
    } failureCb:^(id object) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"TabBarVC" sender:self];
    });
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
