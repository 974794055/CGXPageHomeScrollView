//
//  CGXHomeHeaderScrollViewController.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXHomeHeaderScrollViewController.h"
#import "CGXHomeHeaderView.h"
@interface CGXHomeHeaderScrollViewController ()<CGXPageHomeScrollViewDataSource>
@property (nonatomic,strong) CustomTitleView *categoryView;
@property (nonatomic,strong) CGXPageHomeScrollView *homeScrollView;

@property (nonatomic,strong) NSMutableArray *titlArr;
@end

@implementation CGXHomeHeaderScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    self.titlArr = [NSMutableArray arrayWithArray:@[@"精选", @"微博", @"视频",@"相册"]];
    self.navigationItem.title = @"CGX_鑫";
    
    self.homeScrollView = [[CGXPageHomeScrollView alloc] initWithDelegate:self];
    self.homeScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-kTopHeight);
    [self.view addSubview:self.homeScrollView];

    self.categoryView = [[CustomTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSegmentHeight)];
    [self.categoryView updateDataTitieArray:self.titlArr];
    self.categoryView.backgroundColor = [UIColor orangeColor];
    self.categoryView.selectBtnBlock  = ^(NSInteger integer) {
        [weakSelf.homeScrollView.containerView scrollSelectedItemAtIndex:integer];
        [weakSelf.homeScrollView.containerView reloadData];
    };
    
    [self.homeScrollView reloadData];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.homeScrollView.ceilPointHeight = 0;
}
- (UIView *)headerViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView
{
    CGFloat headerH = (ScreenWidth - 40) / 4 + 20;
    CGXHomeHorizontalView *headerView= [[CGXHomeHorizontalView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headerH)];
    headerView.backgroundColor = [UIColor grayColor];
    return headerView;
}
- (UIView *)titleViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView
{
    return self.categoryView;
}
- (NSInteger)numberOfListsInPageScrollView:(CGXPageHomeBaseView *)pageScrollView
{
    return self.titlArr.count;
}
- (id<CGXPageHomeScrollContainerViewListDelegate>)pageScrollView:(CGXPageHomeBaseView *)pageScrollView initListAtIndex:(NSInteger)index
{
    if (index % 2 == 0) {
        CGXHomeListViewController *listVC = [[CGXHomeListViewController alloc] init];
        [self addChildViewController:listVC];
        listVC.scrollToTop = ^(CGXHomeListViewController * _Nonnull listVC, NSIndexPath * _Nonnull indexPath) {
            [self.homeScrollView scrollToCriticalPoint];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [listVC.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            });
        };
        return listVC;
    } else{
        CGXHomeListTwoViewController *listVC = [[CGXHomeListTwoViewController alloc] init];
        [self addChildViewController:listVC];
        listVC.scrollToTop = ^(CGXHomeListTwoViewController * _Nonnull listVC, NSIndexPath * _Nonnull indexPath) {
            [self.homeScrollView scrollToCriticalPoint];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
