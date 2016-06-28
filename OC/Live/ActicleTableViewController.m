//
//  ActicleTableViewController.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/8.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "ActicleTableViewController.h"
#import "Article.h"
#import "ActicleTableViewCell.h"

@interface ActicleTableViewController ()
@property (nonatomic, strong) NSMutableArray *acticles;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ActicleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 76.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    [self getActicles];

    MJWeakSelf
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf getActicles];
    }];
    [mj_header setTitle:MJRefreshStateIdleHeaderText forState:MJRefreshStateIdle];
    [mj_header setTitle:MJRefreshStatePullingHeaderText forState:MJRefreshStatePulling];
    [mj_header setTitle:MJRefreshStateRefreshingHeaderText forState:MJRefreshStateRefreshing];
    [mj_header.lastUpdatedTimeLabel setHidden:YES];
    self.tableView.mj_header = mj_header;
    
    MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf getActicles];
    }];
    [mj_footer setTitle:MJRefreshStateIdleFooterText forState:MJRefreshStateIdle];
    [mj_footer setTitle:MJRefreshStatePullingFooterText forState:MJRefreshStatePulling];
    [mj_footer setTitle:MJRefreshStateRefreshingFooterText forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = mj_footer;
}

- (NSMutableArray *)acticles {
    if (!_acticles) {
        _acticles = [NSMutableArray array];
    }
    return _acticles;
}

- (void)getActicles {
    
    MJWeakSelf
    [[DataManager inst] getArticles:@{@"page":[NSString stringWithFormat:@"%zi",_page]} successCb:^(NSArray *responseData) {
        
        [weakSelf endRefresh];
        if (responseData.count == 0) return;
        if (weakSelf.page == 0) weakSelf.acticles = nil;
        NSArray *articles = [Article mj_objectArrayWithKeyValuesArray:responseData];
        [weakSelf.acticles addObjectsFromArray:articles];
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
    return _acticles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    [cell reloadData:_acticles[indexPath.row]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
