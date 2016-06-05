//
//  DataManager.h
//  Demo
//
//  Created by ruanqiaohua on 16/6/1.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HostIp @"http://127.0.0.1"

@interface DataManager : NSObject

/**
 *  初始化单例
 */
+ (instancetype)inst;
/**
 *  上传头像
 *
 *  @param image 头像图片
 */
- (void)uploadAvatar:(NSData *)imageData;
/**
 *  上传图片
 */
- (void)uploadImage:(NSData *)imageData successCb:(void(^)())successCb;
/**
 *  登陆
 */
- (void)logOn:(NSDictionary *)parameters successCb:(void(^)())successCb;
/**
 *   注册
 */
- (void)logIn:(NSDictionary *)parameters successCb:(void(^)())successCb;
/**
 *  登出
 */
- (void)logOut:(NSDictionary *)parameters successCb:(void(^)())successCb;
/**
 *  修改密码
 */
- (void)changePasswd:(NSDictionary *)parameters successCb:(void(^)())successCb;
/**
 *  拉取用户信息
 */
- (void)getUserInfo:(NSDictionary *)parameters successCb:(void(^)(NSDictionary *responseData))successCb;
/**
 *  获取用户上传图片
 */
- (void)getPhoto:(NSDictionary *)parameters successCb:(void(^)(NSArray *responseData))successCb;
@end
