//
//  Common.h
//  Demo
//
//  Created by ruanqiaohua on 16/6/5.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

static NSString *const MJRefreshStateIdleHeaderText = @"下拉加载更多";
static NSString *const MJRefreshStateIdleFooterText = @"上拉加载更多";
static NSString *const MJRefreshStatePullingHeaderText = @"快放手,我要刷新了";
static NSString *const MJRefreshStatePullingFooterText = @"快放手,我要刷新了";
static NSString *const MJRefreshStateRefreshingHeaderText = @"正在努力加载中...";
static NSString *const MJRefreshStateRefreshingFooterText = @"正在努力加载中...";

@interface Common : NSObject

@end
