//
//  ActicleTableViewCell.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/8.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "Article.h"
#import "ActicleTableViewCell.h"
#import "UIButton+WebCache.h"

@implementation ActicleTableViewCell

- (void)reloadData:(Article *)article {
    
    NSString *avatar = [NSString stringWithFormat:@"%@/app/uploads/avatar/%@",HostIp,article.avatar];
    [_avatar sd_setImageWithURL:[NSURL URLWithString:avatar] forState:UIControlStateNormal];
    _nickname.text = article.nickname;
    _message.text = article.content;
    
}

@end
