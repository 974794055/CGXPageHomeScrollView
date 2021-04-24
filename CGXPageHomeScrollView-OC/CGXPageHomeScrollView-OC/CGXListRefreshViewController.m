//
//  CGXListRefreshViewController.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXListRefreshViewController.h"
#import "CGXHomeHeaderView.h"
#import "CGXHomeListViewController.h"
@interface CGXListRefreshViewController()<UIScrollViewDelegate,CGXPageHomeScrollViewDataSource>

@property (nonatomic, strong) CGXPageHomeScrollView  *pageScrollView;

@property (nonatomic, strong) CustomTitleView   *categoryView;

@property (nonatomic,strong) NSMutableArray *titlArr;

@end

@implementation CGXListRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.titlArr = [NSMutableArray arrayWithArray:@[@"主页", @"微博", @"视频", @"故事"]];
    self.navigationItem.title = @"CGX_鑫";
    self.categoryView = [[CustomTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSegmentHeight)];
    [self.categoryView updateDataTitieArray:self.titlArr];
    self.categoryView.backgroundColor = [UIColor orangeColor];
    self.categoryView.selectBtnBlock  = ^(NSInteger integer) {
        [weakSelf.pageScrollView.containerView scrollSelectedItemAtIndex:integer];
        [weakSelf.pageScrollView.containerView reloadData];
    };
    _pageScrollView = [[CGXPageHomeScrollView alloc] initWithDelegate:self];
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.pageScrollView.mainTableView.bounces = NO;
    self.pageScrollView.isMainScroll = NO;
    self.pageScrollView.isAllowListRefresh = YES;
    [self.pageScrollView reloadData];
}

- (UIView *)headerViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView {
    CGXHomeHeaderView *headerView = [[CGXHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2)];
        headerView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
    return headerView;
}
- (UIView *)titleViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView
{
    return self.categoryView;
}
- (NSInteger)numberOfListsInPageScrollView:(CGXPageHomeBaseView *)pageScrollView
{
    return 4;
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
