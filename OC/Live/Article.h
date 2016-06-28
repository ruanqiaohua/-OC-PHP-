//
//  Article.h
//  Demo
//
//  Created by ruanqiaohua on 16/6/8.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, assign) NSInteger articleId;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *nickname;

@end