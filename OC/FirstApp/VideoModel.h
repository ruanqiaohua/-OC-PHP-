//
//  VideoModel.h
//  FirstApp
//
//  Created by ruanqiaohua on 16/6/24.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) id cell;

@end
