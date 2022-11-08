//
//  CGXSmoothViewController.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXSmoothViewController.h"
#import "CGXPageHomeSmoothView.h"
#import "CGXSmoothListView.h"


@interface CGXSmoothViewController ()<CGXPageHomeSmoothViewDataSource, CGXPageHomeSmoothViewDelegate>

@property (nonatomic, strong) CustomTitleView *categoryView;

@property (nonatomic, strong) CGXPageHomeSmoothView *smoothView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIView    *segmentedView;

@property (nonatomic, assign) BOOL isTitleViewShow;
@property (nonatomic, assign) CGFloat originAlpha;

@property (nonatomic, assign) CGFloat lastRatio;

@end

@implementation CGXSmoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.categoryView = [[CustomTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSegmentHeight)];
    [self.categoryView updateDataTitieArray:@[@"精选", @"微博", @"视频",@"相册"]];
    self.categoryView.backgroundColor = [UIColor orangeColor];
    self.categoryView.selectBtnBlock  = ^(NSInteger integer) {
//        [weakSelf.pageScrollView.containerView scrollSelectedItemAtIndex:integer];
//        [weakSelf.pageScrollView.containerView reloadData];
    };
    
    _smoothView = [[CGXPageHomeSmoothView alloc] initWithDataSource:self];
    _smoothView.delegate = self;
    _smoothView.ceilPointHeight = 0;
    _smoothView.bottomHover = YES;
    _smoothView.allowDragBottom = YES;
    _smoothView.allowDragScroll = YES;
    _smoothView.bottomHover = NO;
    [self.view addSubview:self.smoothView];
    [self.smoothView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.smoothView reloadData];
}

#pragma mark - CGXPageHomeSmoothViewDataSource
- (UIView *)headerViewInSmoothView:(CGXPageHomeSmoothView *)smoothView {
    
    UIImage *image = [UIImage imageNamed:@"list"];
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    _headerView.image = image;
    return self.headerView;
}

- (UIView *)segmentedViewInSmoothView:(CGXPageHomeSmoothView *)smoothView {
    _segmentedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    _segmentedView.backgroundColor = [UIColor whiteColor];
    [_segmentedView addSubview:self.categoryView];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor lightGrayColor];
    topView.layer.cornerRadius = 3;
    topView.layer.masksToBounds = YES;
    [_segmentedView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_segmentedView).offset(5);
        make.centerX.equalTo(self->_segmentedView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(6);
    }];
    return self.segmentedView;
}

- (NSInteger)numberOfListsInSmoothView:(CGXPageHomeSmoothView *)smoothView {
    return 4;
}

- (id<GKPageSmoothListViewDelegate>)smoothView:(CGXPageHomeSmoothView *)smoothView initListAtIndex:(NSInteger)index {
    CGXSmoothListView *listView = [CGXSmoothListView new];
    return listView;
}

#pragma mark - CGXPageHomeSmoothViewDelegate
- (void)smoothView:(CGXPageHomeSmoothView *)smoothView listScrollViewDidScroll:(UIScrollView *)scrollView contentOffset:(CGPoint)contentOffset {
    if (smoothView.isOnTop) return;
    
//    // 导航栏显隐
//    CGFloat offsetY = contentOffset.y;
//    CGFloat alpha = 0;
//    if (offsetY <= 0) {
//        alpha = 0;
//    }else if (offsetY > 60) {
//        alpha = 1;
//        [self changeTitle:YES];
//    }else {
//        alpha = offsetY / 60;
//        [self changeTitle:NO];
//    }
//    self.gk_navBarAlpha = alpha;
}

- (void)smoothViewDragBegan:(CGXPageHomeSmoothView *)smoothView {
    if (smoothView.isOnTop) return;
    
//    self.isTitleViewShow = (self.gk_navTitleView != nil);
//    self.originAlpha = self.gk_navBarAlpha;
}

- (void)smoothViewDragEnded:(CGXPageHomeSmoothView *)smoothView isOnTop:(BOOL)isOnTop {
    // titleView已经显示，不作处理
    if (self.isTitleViewShow) return;
    
//    if (isOnTop) {
//        self.gk_navBarAlpha = 1.0f;
//        [self changeTitle:YES];
//    }else {
//        self.gk_navBarAlpha = self.originAlpha;
//        [self changeTitle:NO];
//    }
}

- (void)changeTitle:(BOOL)isShow {
//    if (isShow) {
//        if (self.gk_navTitle == nil) return;
//        self.gk_navTitle = nil;
//        self.gk_navTitleView = self.titleView;
//    }else {
//        if (self.gk_navTitleView == nil) return;
//        self.gk_navTitle = @"电影";
//        self.gk_navTitleView = nil;
//    }
}




@end
