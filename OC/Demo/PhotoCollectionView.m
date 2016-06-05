//
//  PhotoCollectionView.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/5.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSArray *images;

@end

static NSString *const cellIdentifier = @"cellIdentifier";

@implementation PhotoCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        _images = [NSArray array];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
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



@end
