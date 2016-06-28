//
//  Session.m
//  FirstApp
//
//  Created by ruanqiaohua on 16/6/26.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "Session.h"

@implementation Session

+ (instancetype)inst {
    static Session *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [Session new];
    });
    return session;
}

- (void)setBackgroundUrl:(NSString *)backgroundUrl {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:backgroundUrl forKey:@"backgroundUrl"];
}

- (NSString *)backgroundUrl {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *backgroundUrl = [userDefaults valueForKey:@"backgroundUrl"];
    return backgroundUrl;
}

@end
