//
//  PhotoCollectionViewCell.h
//  Demo
//
//  Created by ruanqiaohua on 16/6/5.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

- (void)reloadData:(NSString *)imageName;

@end
