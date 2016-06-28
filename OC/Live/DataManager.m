//
//  DataManager.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/1.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "DataManager.h"
#import "AFNetWorking.h"

#define ReturnCode @"code"
#define ReturnData @"data"
#define ReturnMessage @"message"
#define SuccessCb(data) if (successCb) {successCb(data);}
#define FailureCb(data) if (failureCb) {failureCb(data);}

static NSString *const app = @"app";
static NSString *const action = @"action";
static NSString *const uploads = @"uploads";
static NSString *const user = @"user";

@interface DataManager ()
@property (nonatomic, strong) AFHTTPSessionManager *session;
@end
@implementation DataManager

+ (instancetype)inst {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
        manager.session = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:HostIp]];
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
        NSLog(@"%@",error);
        NSLog(@"%@",jsonString);
    }
    return responseDictionary;
}

- (void)setNetworkActivity:(BOOL)show userInteractionEnabled:(BOOL)userInteractionEnabled {
    
    if (show) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [[UIApplication sharedApplication].keyWindow.rootViewController.view setUserInteractionEnabled:YES];
    }
    if (userInteractionEnabled) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view setUserInteractionEnabled:YES];
    } else {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view setUserInteractionEnabled:NO];
    }
}

- (void)getSystemConfig:(NSDictionary *)parameters successCb:(void (^)(id))successCb failureCb:(void (^)(id))failureCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/getSystemConfig.php",app,user];
    
    [self setNetworkActivity:YES userInteractionEnabled:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self setNetworkActivity:NO userInteractionEnabled:YES];
        
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) {
            FailureCb(nil)
            return;
        }
        NSInteger code = [ReturnCode integerValue];
        if (code == 0) {
            SuccessCb(response[ReturnData])
        } else {
            FailureCb(nil)
            [self showMessage:response[ReturnMessage]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FailureCb(nil)
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)uploadAvatar:(NSData *)imageData {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/uploadAvatar.php",app,uploads];
    
    [self setNetworkActivity:YES userInteractionEnabled:YES];
    [_session POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData){
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject){
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) return;

        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            
        }
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)uploadImage:(NSData *)imageData successCb:(void(^)())successCb{
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/uploadImage.php",app,uploads];

    [self setNetworkActivity:YES userInteractionEnabled:YES];
    [_session POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData){
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject){
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) return;

        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb();
            } 
        }
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)removeImage:(NSDictionary *)parameters successCb:(void(^)())successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/removeImage.php",app,action];

    [self setNetworkActivity:YES userInteractionEnabled:NO];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) return;

        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb();
            }
        } else {
            [self showMessage:response[@"message"]];
        }
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)logOn:(NSDictionary *)parameters successCb:(void(^)())successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/logOn.php",app,action];

    [self setNetworkActivity:YES userInteractionEnabled:NO];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) return;
        gSession.uid = response[ReturnData][@"uid"]?:nil;
        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb();
            }
        } else {
            [self showMessage:response[@"message"]];
        }
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)logOut:(NSDictionary *)parameters successCb:(void(^)())successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/logOut.php",app,action];

    [self setNetworkActivity:YES userInteractionEnabled:NO];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) return;

        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            successCb();
        } else {
            [self showMessage:response[@"message"]];
        }
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)logIn:(NSDictionary *)parameters successCb:(void(^)())successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/logIn.php",app,action];

    [self setNetworkActivity:YES userInteractionEnabled:NO];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) return;

        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            successCb();
        }
        [self showMessage:response[@"message"]];
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)changePasswd:(NSDictionary *)parameters successCb:(void(^)())successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/changeUserPasswd.php",app,user];

    [self setNetworkActivity:YES userInteractionEnabled:NO];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) return;

        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb();
            }
        }
        [self showMessage:response[@"message"]];
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)getUserInfo:(NSDictionary *)parameters successCb:(void(^)(NSDictionary *responseData))successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/getUserInfo.php",app,user];

    [self setNetworkActivity:YES userInteractionEnabled:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self setNetworkActivity:NO userInteractionEnabled:YES];

        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) return;

        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb(response[@"data"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)getPhoto:(NSDictionary *)parameters successCb:(void(^)(NSArray *responseData))successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/getPhoto.php",app,user];

    [self setNetworkActivity:YES userInteractionEnabled:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) return;

        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb(response[@"data"]);
            }
        } else {
            [self showMessage:response[@"message"]];
        }
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)getArticles:(NSDictionary *)parameters successCb:(void (^)(id object))successCb failureCb:(void(^)(id object))failureCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/getArticles.php",app,user];

    [self setNetworkActivity:YES userInteractionEnabled:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self setNetworkActivity:NO userInteractionEnabled:YES];

        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) {
            FailureCb(nil)
            return;
        }

        NSInteger code = [ReturnCode integerValue];
        if (code == 0) {
            SuccessCb(response[ReturnData])
        } else {
            FailureCb(nil)
            [self showMessage:response[ReturnMessage]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FailureCb(nil)
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)sendArticle:(NSDictionary *)parameters successCb:(void (^)())successCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/sendArticle.php",app,user];

    [self setNetworkActivity:YES userInteractionEnabled:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) return;
        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            if (successCb) {
                successCb();
            }
        }
        [self showMessage:response[@"message"]];
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

- (void)getVideos:(NSDictionary *)parameters successCb:(void (^)(id))successCb failureCb:(void (^)(id))failureCb {
    
    NSString *urlString = [NSString stringWithFormat:@"/%@/%@/getVideos.php",app,user];

    [self setNetworkActivity:YES userInteractionEnabled:YES];
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self setNetworkActivity:NO userInteractionEnabled:YES];
        
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) {
            FailureCb(nil)
            return;
        }
        
        NSInteger code = [ReturnCode integerValue];
        if (code == 0) {
            SuccessCb(response[ReturnData])
        } else {
            FailureCb(nil)
            [self showMessage:response[ReturnMessage]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FailureCb(nil)
        [self setNetworkActivity:NO userInteractionEnabled:YES];
    }];
}

@end
