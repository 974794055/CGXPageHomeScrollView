//
//  CGXMainRefreshViewController.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXMainRefreshViewController.h"

#import "CGXPageHomeScrollView.h"
#import "CGXHomeHeaderView.h"
#import "CGXHomeListViewController.h"
@interface CGXMainRefreshViewController ()<CGXPageHomeScrollViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) CGXPageHomeScrollView      *pageScrollView;

@property (nonatomic, strong) NSArray               *titles;

@property (nonatomic, strong) CustomTitleView   *categoryView;

@end

@implementation CGXMainRefreshViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"CGX_鑫";
    self.titles = @[@"精选", @"微博", @"视频",@"相册"];;;
    _pageScrollView = [[CGXPageHomeScrollView alloc] initWithDelegate:self];
    [self.view addSubview:self.pageScrollView];
    self.pageScrollView.mainTableView.bounces = YES;
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.pageScrollView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pageScrollView.mainTableView.mj_header endRefreshing];
            [self.pageScrollView reloadData];
        });
    }];
    [self.pageScrollView.mainTableView.mj_header beginRefreshing];
}
#pragma mark - CGXPageHomeScrollViewDataSource
- (UIView *)headerViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView {
    CGXHomeHeaderView *headerView = [[CGXHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2)];
    headerView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
    return headerView;
}
- (UIView *)titleViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView {
    __weak typeof(self) weakSelf = self;
    self.categoryView = [[CustomTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSegmentHeight)];
    [self.categoryView updateDataTitieArray:[NSMutableArray arrayWithArray:self.titles]];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.selectBtnBlock = ^(NSInteger integer) {
        [weakSelf.pageScrollView.containerView scrollSelectedItemAtIndex:integer];
        [weakSelf.pageScrollView.containerView reloadData];
    };
    return self.categoryView;
}
- (NSInteger)numberOfListsInPageScrollView:(CGXPageHomeBaseView *)pageScrollView
{
    return self.titles.count;
}
- (id<CGXPageHomeScrollContainerViewListDelegate>)pageScrollView:(CGXPageHomeBaseView *)pageScrollView initListAtIndex:(NSInteger)index
{
    if (index % 2 == 0) {
        CGXHomeListViewController *listVC = [[CGXHomeListViewController alloc] init];
        [self addChildViewController:listVC];
        listVC.scrollToTop = ^(CGXHomeListViewController * _Nonnull listVC, NSIndexPath * _Nonnull indexPath) {
            [self.pageScrollView scrollToCriticalPoint];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [listVC.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            });
        };
        return listVC;
    } else{
        CGXHomeListTwoViewController *listVC = [[CGXHomeListTwoViewController alloc] init];
        [self addChildViewController:listVC];
        listVC.scrollToTop = ^(CGXHomeListTwoViewController * _Nonnull listVC, NSIndexPath * _Nonnull indexPath) {
            [self.pageScrollView scrollToCriticalPoint];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [listVC.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            });
        };
        return listVC;
    }
}
// 菜单左右滚动
- (void)pageScrollView:(CGXPageHomeBaseView *)pageScrollView listContainerViewAtIndex:(NSInteger)index
{
    [self.categoryView scrollViewInter:index];
}

@end
