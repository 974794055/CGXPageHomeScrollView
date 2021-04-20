//
//  CGXHomeListViewController.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXHomeListViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface CGXHomeListViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong , readwrite) UITableView *tableView;

@end

@implementation CGXHomeListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadMoreData];
        });
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            self.count = 30;
            [self.tableView reloadData];
        });
    }];
    
    self.count = 0;
    self.tableView.mj_footer.hidden = self.count == 0;
    [self.tableView reloadData];
    [self loadData];
}
- (void)listDidAppearAtIndex:(NSInteger)index
{
//    [self.tableView reloadData];
}
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    [self loadData];
//}
- (void)loadData {
    self.count = 30;
    
    [self.tableView reloadData];
}

- (void)loadMoreData {
    self.count += 20;
    
    if (self.count >= 50) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = self.count == 0;
    return self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行", indexPath.row + 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    !self.scrollToTop ? : self.scrollToTop(self, indexPath);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.listScrollViewScrollCallback ? : self.listScrollViewScrollCallback(scrollView);
}
#pragma mark - CGXPageHomeListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.listScrollViewScrollCallback = callback;
}
@end
