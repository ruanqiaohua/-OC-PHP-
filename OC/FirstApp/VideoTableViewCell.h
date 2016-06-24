//
//  VideoTableViewCell.h
//  Demo
//
//  Created by ruanqiaohua on 16/6/14.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *playerView;

- (void)loadVideoWithUrlString:(NSString *)urlString Cb:(void (^)())cb;
- (void)pausePlayer;
- (void)stopPlayer;

@end
