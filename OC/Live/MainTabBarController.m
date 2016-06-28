//
//  MainTabBarController.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/1.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    [self setDelegate:self];
    // Do any additional setup after loading the view.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == tabBarController.viewControllers[tabBarController.viewControllers.count/2]) {
        if (gSession.uid) {
            [self performSegueWithIdentifier:@"WriteActicleVC" sender:self];
        } else {
            [self performSegueWithIdentifier:@"logOnVC" sender:self];
        }
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
