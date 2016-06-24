//
//  MainTabBarController.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/1.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self alterTabBarItem];
    [self.tabBar addSubview:self.addBtn];
    // Do any additional setup after loading the view.
}


- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _addBtn.frame = CGRectMake(0, 0, 40, 40);
        _addBtn.layer.cornerRadius = 2.0;
        _addBtn.layer.masksToBounds = YES;
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _addBtn.center = CGPointMake(self.tabBar.frame.size.width/2, self.tabBar.frame.size.height/2);
        [_addBtn setBackgroundColor:[UIColor purpleColor]];
        [_addBtn setTitle:@"✚" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (void)alterTabBarItem {
    
    NSMutableArray *mulSubView = [NSMutableArray arrayWithArray:self.tabBar.items];
    [mulSubView enumerateObjectsUsingBlock:^(UITabBarItem * obj, NSUInteger idx, BOOL *stop) {
        switch (idx) {
            case 0:
            {
                [obj setTitlePositionAdjustment:UIOffsetMake(-10, 0)];
            }
                break;
            case 1:
            {
                [obj setTitlePositionAdjustment:UIOffsetMake(-30, 0)];
            }
                break;
            case 2:
            {
                [obj setTitlePositionAdjustment:UIOffsetMake(30, 0)];
            }
                break;
            case 3:
            {
                [obj setTitlePositionAdjustment:UIOffsetMake(10, 0)];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)addBtnAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"WriteActicleVC" sender:self];
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
