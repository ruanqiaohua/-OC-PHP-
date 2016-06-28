//
//  PhotoCollectionView.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/5.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "PhotoCollectionViewCell.h"
#import "Common.h"

@interface PhotoCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSArray *images;
@property (nonatomic, assign) CGFloat screen_W;
@property (nonatomic, assign) CGFloat screen_H;
@end

static NSString *const cellIdentifier = @"cellIdentifier";

@implementation PhotoCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        _images = [NSArray array];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        _screen_W = width > height ? height:width;
        _screen_H = height > width ? height:width;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        
        //创建长按手势监听
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(myHandleTableviewCellLongPressed:)];
        longPress.minimumPressDuration = 1.0;
        //将长按手势添加到需要实现长按操作的视图里
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)reloadData:(NSArray *)array {
    
    _images = array;
    [self reloadData];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *imageName = _images[indexPath.item];
    [cell reloadData:imageName];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.itemDidSelectCb) {
        self.itemDidSelectCb(indexPath);
    }
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            CGFloat width = floorf((_screen_H-10*4)/3);
            return CGSizeMake(width, width);
        }
            break;
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        {
            CGFloat width = floorf((_screen_W-10*3)/2);
            return CGSizeMake(width, width);
        }
            break;
        default:
            break;
    }
    CGFloat width = floorf((CGRectGetWidth(collectionView.bounds)-10*3)/2);
    return CGSizeMake(width, width);
}

- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint pointTouch = [gestureRecognizer locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:pointTouch];

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.itemEndLongTap) {
            self.itemEndLongTap(indexPath);
        }
    }
}


@end
