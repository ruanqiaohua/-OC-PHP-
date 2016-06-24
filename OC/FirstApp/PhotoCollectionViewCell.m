//
//  PhotoCollectionViewCell.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/5.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)reloadData:(NSString *)imageName {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/uploads/image/%@",HostIp,imageName];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];

}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
}

@end
