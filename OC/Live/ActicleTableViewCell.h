//
//  ActicleTableViewCell.h
//  Demo
//
//  Created by ruanqiaohua on 16/6/8.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActicleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *avatar;

@property (weak, nonatomic) IBOutlet UILabel *nickname;

@property (weak, nonatomic) IBOutlet UILabel *message;

- (void)reloadData:(Article *)article;

@end
