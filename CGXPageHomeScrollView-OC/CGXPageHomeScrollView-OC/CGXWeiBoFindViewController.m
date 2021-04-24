//
//  CGXWeiBoFindViewController.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXWeiBoFindViewController.h"

#import "CGXPageHomeZoomView.h"
#import "CGXHomeListViewController.h"

#import <MJRefresh/MJRefresh.h>

#define STATUSBAR_HEIGHT 0
@interface CGXWeiBoFindViewController ()
<CGXPageHomeScrollViewDataSource, UIScrollViewDelegate>
{
    CustomTitleView *categoryView;
}
@property (nonatomic, strong) CGXPageHomeScrollView          *pageScrollView;

@property (nonatomic, strong) UIView                    *headerView;

@property (nonatomic, strong) NSArray                   *titles;

@property (nonatomic, assign) BOOL                      isMainCanScroll;

@end

@implementation CGXWeiBoFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.isMainCanScroll = YES;
    self.navigationController.navigationBar.translucent = NO;//设置不透明
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_black"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.title = @"CGX_鑫";
    self.titles = @[@"精选", @"微博", @"视频",@"相册"];;;
    _pageScrollView = [[CGXPageHomeScrollView alloc] initWithDelegate:self];
    _pageScrollView.ceilPointHeight = STATUSBAR_HEIGHT;
    _pageScrollView.isAllowListRefresh = YES;
    _pageScrollView.isMainScroll = YES;
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.pageScrollView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pageScrollView.mainTableView.mj_header endRefreshing];
        });
    }];
    [self.pageScrollView reloadData];
}

- (void)backAction {
    if (self.isMainCanScroll) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.pageScrollView scrollToOriginalPoint];
    }
}

#pragma mark - CGXPageHomeZoomViewDelegate
- (UIView *)headerViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView {
    UIImage *headerImg = [UIImage imageNamed:@"wy_bg"];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * headerImg.size.height / headerImg.size.width + STATUSBAR_HEIGHT)];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = _headerView.frame;
    imgView.image = headerImg;
    [_headerView addSubview:imgView];
    return self.headerView;
}
- (UIView *)titleViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView {
    __weak typeof(self) weakSelf = self;
    categoryView = [[CustomTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSegmentHeight)];
    [categoryView updateDataTitieArray:[NSMutableArray arrayWithArray:self.titles]];
    categoryView.backgroundColor = [UIColor whiteColor];
    categoryView.selectBtnBlock  = ^(NSInteger integer) {
        [weakSelf.pageScrollView.containerView scrollSelectedItemAtIndex:integer];
        [weakSelf.pageScrollView.containerView reloadData];
    };
    return categoryView;
}
// 菜单左右滚动
- (void)pageScrollView:(CGXPageHomeBaseView *)pageScrollView listContainerViewAtIndex:(NSInteger)index
{
    [categoryView scrollViewInter:index];
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

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll {
    self.isMainCanScroll = isMainCanScroll;

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
