//
//  Session.h
//  FirstApp
//
//  Created by ruanqiaohua on 16/6/26.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject
//用户ID
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *backgroundUrl;

/***  初始化单例*/
+ (instancetype)inst;

#define gSession [Session inst]
@end
