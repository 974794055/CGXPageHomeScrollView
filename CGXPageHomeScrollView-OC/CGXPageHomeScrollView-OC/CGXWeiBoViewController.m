//
//  CGXWeiBoViewController.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXWeiBoViewController.h"
#import "CGXHeaderView.h"
#import "CGXHomeListViewController.h"

@interface CGXWeiBoViewController ()
<CGXPageHomeScrollViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) CGXPageHomeZoomView      *pageScrollView;

@property (nonatomic, strong) CGXHeaderView            *headerView;
@property (nonatomic, strong) CustomTitleView *titleView;
@property (nonatomic, strong) CGXHomeNavView *navView;
@property (nonatomic, strong) NSArray               *titles;

@end

@implementation CGXWeiBoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.pageScrollView.backgroundColor = APPRandomColor;
    self.titleView.backgroundColor = APPRandomColor;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
     __weak typeof(self) weakSelf = self;
    _titles = @[@"精选", @"微博", @"视频",@"相册"];;

    self.pageScrollView = [[CGXPageHomeZoomView alloc] initWithDelegate:self];
    self.pageScrollView.mainTableView.bounces = YES;
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
    self.pageScrollView.pageHomeZ_loadImageCallback = ^(UIImageView * _Nonnull hotImageView) {
        hotImageView.image = [UIImage imageNamed:@"wy_bg"];
//        [hotImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.pageScrollView.zoomImageStr]];
    };
    self.pageScrollView.zoomImageStr = @"";
    [self.pageScrollView reloadData];
    
    self.navView = [[CGXHomeNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kTopHeight)];
    [self.view addSubview:self.navView];
    self.navView.cancelBtnBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.navView scrollNavAlpha:0 IsOpaque:NO];
    


}
- (UIView *)headerViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView {

    CGXHeaderView *headerView = [[CGXHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kBHeaderHeight)];
        headerView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
        self.headerView = headerView;
    return self.headerView;;
}
- (UIView *)titleViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView {
    __weak typeof(self) weakSelf = self;
    CustomTitleView *categoryView = [[CustomTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSegmentHeight)];
    categoryView.backgroundColor = APPRandomColor;
    [categoryView updateDataTitieArray:[NSMutableArray arrayWithArray:self.titles]];
    categoryView.selectBtnBlock = ^(NSInteger integer) {
        [weakSelf.pageScrollView.containerView scrollSelectedItemAtIndex:integer];
        [weakSelf.pageScrollView.containerView reloadData];
    };
    self.titleView = categoryView;
    return categoryView;
}

- (NSInteger)numberOfListsInPageScrollView:(CGXPageHomeBaseView *)pageScrollView {
    return self.titles.count;
}

- (id<CGXPageHomeScrollContainerViewListDelegate>)pageScrollView:(CGXPageHomeBaseView *)pageScrollView initListAtIndex:(NSInteger)index {
    
    if (index % 2 ==0) {
        CGXHomeListViewController *listVC = [[CGXHomeListViewController alloc] init];
        [self addChildViewController:listVC];
        return listVC;
    } else {
        CGXHomeListTwoViewController *listVC = [[CGXHomeListTwoViewController alloc] init];
        [self addChildViewController:listVC];
        return listVC;
    }
}
// 菜单左右滚动
- (void)pageScrollView:(CGXPageHomeScrollView *)pageScrollView listContainerViewAtIndex:(NSInteger)index
{
    [self.titleView scrollViewInter:index];
}
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alpha = 0;
    BOOL isOpaque = YES;
    if (offsetY <= kTopHeight) {
        alpha = 0.0f;
        isOpaque = NO;
    }else if (offsetY >= kBHeaderHeight) {
        alpha = 1.0f;
        isOpaque = YES;
    }else {
        alpha = offsetY / (kBHeaderHeight - kTopHeight);

        if (alpha > 0.8) {
            isOpaque = YES;
        }else {
            isOpaque = NO;
        }
    }
    [self.navView scrollNavAlpha:alpha IsOpaque:isOpaque];

}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pageScrollView.ceilPointHeight = kTopHeight;
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
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
