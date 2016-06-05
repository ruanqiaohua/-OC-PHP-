//
//  DataManager.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/1.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "DataManager.h"
#import "AFNetWorking.h"

@interface DataManager ()
@property (nonatomic, strong) AFHTTPSessionManager *session;
@end
@implementation DataManager

+ (instancetype)inst {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
        manager.session = [AFHTTPSessionManager manager];
        manager.session.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return manager;
}

- (void)showMessage:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController showDetailViewController:alert sender:self];
}

- (NSDictionary *)responseDictionary:(id)responseObject {
    
    NSError *error;
    NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
    if (!responseDictionary) {
        NSString *jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
    }
    return responseDictionary;
}

- (void)setNetworkActivity:(BOOL)show {
    
    if (show) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)uploadAvatar:(NSData *)imageData {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/uploads/uploadAvatar",HostIp];
    
    [self setNetworkActivity:YES];
    [_session POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData){
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject){
        NSDictionary *userInfo = [self responseDictionary:responseObject];
        NSInteger code = [userInfo[@"code"] integerValue];
        if (code == 0) {
            
        }
        [self setNetworkActivity:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        [self setNetworkActivity:NO];
    }];
}

- (void)uploadImage:(NSData *)imageData successCb:(void(^)())successCb{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/uploads/uploadImage",HostIp];
    
    [self setNetworkActivity:YES];
    [_session POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData){
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject){
        NSDictionary *userInfo = [self responseDictionary:responseObject];
        NSInteger code = [userInfo[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb();
            } 
        }
        [self setNetworkActivity:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        [self setNetworkActivity:NO];
    }];
}

- (void)logOn:(NSDictionary *)parameters successCb:(void(^)())successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/action/logOn",HostIp];

    [self setNetworkActivity:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *userInfo = [self responseDictionary:responseObject];
        NSInteger code = [userInfo[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb();
            }
        } else {
            [self showMessage:userInfo[@"message"]];
        }
        [self setNetworkActivity:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO];
    }];
}

- (void)logOut:(NSDictionary *)parameters successCb:(void(^)())successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/action/logOut",HostIp];
    
    [self setNetworkActivity:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *userInfo = [self responseDictionary:responseObject];
        NSInteger code = [userInfo[@"code"] integerValue];
        if (code == 0) {
            successCb();
        } else {
            [self showMessage:userInfo[@"message"]];
        }
        [self setNetworkActivity:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO];
    }];
}

- (void)logIn:(NSDictionary *)parameters successCb:(void(^)())successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/action/logIn",HostIp];
    
    [self setNetworkActivity:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            successCb();
        }
        [self showMessage:response[@"message"]];
        [self setNetworkActivity:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO];
    }];
}

- (void)changePasswd:(NSDictionary *)parameters successCb:(void(^)())successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/changeUserPasswd",HostIp];
    
    [self setNetworkActivity:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb();
            }
        }
        [self showMessage:response[@"message"]];
        [self setNetworkActivity:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO];
    }];
}

- (void)getUserInfo:(NSDictionary *)parameters successCb:(void(^)(NSDictionary *responseData))successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/getUserInfo",HostIp];
    
    [self setNetworkActivity:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb(response[@"data"]);
            }
        }
        [self setNetworkActivity:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO];
    }];
}

- (void)getPhoto:(NSDictionary *)parameters successCb:(void(^)(NSArray *responseData))successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/getPhoto",HostIp];
    
    [self setNetworkActivity:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb(response[@"data"]);
            }
        }
        [self setNetworkActivity:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO];
    }];
}

@end
