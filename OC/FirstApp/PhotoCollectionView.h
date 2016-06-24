//
//  PhotoCollectionView.h
//  Demo
//
//  Created by ruanqiaohua on 16/6/5.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionView : UICollectionView

@property (copy, nonatomic) void (^itemDidSelectCb)(NSIndexPath *);
@property (copy, nonatomic) void (^itemEndLongTap)(NSIndexPath *);
/**
 *  刷新试图
 *
 *  @param array 图片数组
 */
- (void)reloadData:(NSArray *)array;

@end
