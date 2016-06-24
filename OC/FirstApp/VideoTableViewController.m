//
//  VideoTableViewController.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/14.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "VideoTableViewController.h"
#import "VideoTableViewCell.h"
#import "VideoModel.h"

@interface VideoTableViewController ()
@property (nonatomic, strong) VideoTableViewCell *playingCell;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *videos;
@end

@implementation VideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 400.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self getVideos];
    
    MJWeakSelf
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf getVideos];
    }];
    [mj_header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
    [mj_header setTitle:@"快放手,我要刷新了" forState:MJRefreshStatePulling];
    [mj_header setTitle:@"正在努力加载中..." forState:MJRefreshStateRefreshing];
    [mj_header.lastUpdatedTimeLabel setHidden:YES];
    self.tableView.mj_header = mj_header;
    
    MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf getVideos];
    }];
    [mj_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [mj_footer setTitle:@"快放手,我要刷新了" forState:MJRefreshStatePulling];
    [mj_footer setTitle:@"正在努力加载中..." forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = mj_footer;

}

- (NSMutableArray *)videos {
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

- (void)getVideos {
    
    MJWeakSelf
    NSString *page = [NSString stringWithFormat:@"%zi",_page];
    [[DataManager inst] getVideos:@{@"page":page} successCb:^(id object) {
        
        [weakSelf endRefresh];
        if (![object isKindOfClass:[NSArray class]]) return;
        NSArray *array = (NSArray *)object;
        if (array.count == 0) return;
        if (weakSelf.page == 0) weakSelf.videos = nil;
        NSArray *videos = [VideoModel mj_objectArrayWithKeyValuesArray:object];
        [weakSelf.videos addObjectsFromArray:videos];
        if (weakSelf.playingCell) {
            [weakSelf.playingCell stopPlayer];
            weakSelf.playingCell = nil;
        }
        [weakSelf.tableView reloadData];
    } failureCb:^(id object) {
        [weakSelf endRefresh];
    }];
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    VideoModel *videoModel = _videos[indexPath.row];
    if (videoModel.cell) {
        return cell;
    }
    cell.titleLabel.text = videoModel.title;
    MJWeakSelf
    [cell loadVideoWithUrlString:videoModel.url Cb:^{
        if (weakSelf.playingCell) {
            [weakSelf.playingCell pausePlayer];
        }
        weakSelf.playingCell = cell;
    }];
    videoModel.cell = cell;
    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    if (!self.playingCell) return;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.playingCell];
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    if (CGRectGetMaxY(rect) > self.tabBarController.tabBar.origin.y || rect.origin.y < 0) {
        [self.playingCell pausePlayer];
        self.playingCell = nil;
    }
}

@end
