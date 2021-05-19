//
//  CGXPageHomeScrollView.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXPageHomeScrollView.h"
@interface CGXPageHomeScrollView()<CGXPageHomeScrollContainerViewContentDelegate>

@property (nonatomic,strong,readwrite) CGXPageHomeScrollContainerView *containerView;

/// 主列表
@property (nonatomic, strong, readwrite) CGXPageHomeTableView   *mainTableView;

// 当前已经加载过的可用的列表字典，key是index值，value是对应列表
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSNumber *, id<CGXPageHomeScrollContainerViewListDelegate>> *validListDict;

// 当前滑动的listView
@property (nonatomic, weak) UIScrollView                *currentListScrollView;

// 是否滑动到临界点，可有偏差
@property (nonatomic, assign) BOOL                      isCriticalPoint;
// 是否到达临界点，无偏差
@property (nonatomic, assign) BOOL                      isCeilPoint;
// mainTableView是否可滑动
@property (nonatomic, assign) BOOL                      isMainCanScroll;
// listScrollView是否可滑动
@property (nonatomic, assign) BOOL                      isListCanScroll;

// 是否开始拖拽，只有在拖拽中才去处理滑动，解决使用mj_header可能出现的bug
@property (nonatomic, assign) BOOL                      isBeginDragging;

// 快速切换原点和临界点
@property (nonatomic, assign) BOOL                      isScrollToOriginal;
@property (nonatomic, assign) BOOL                      isScrollToCritical;


@end
@implementation CGXPageHomeScrollView

- (void)initializeData
{
    [super initializeData];
    self.validListDict = [NSMutableDictionary new];
    self.isAllowListRefresh = NO;
    self.isMainScroll = NO;
}
- (void)initializeViews
{
    [super initializeViews];
    self.mainTableView = [[CGXPageHomeTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.tableHeaderView = [[UIView alloc] init];;
    self.mainTableView.tableFooterView = [[UIView alloc] init];;
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.mainTableView];
    
    self.containerView = [[CGXPageHomeScrollContainerView alloc] initWithType:self.containerType delegate:self];
    self.containerView.mainTableView = self.mainTableView;
    self.mainTableView.horizontalScrollViewList = @[self.containerView.scrollView];
}
- (void)setDelegate:(id<CGXPageHomeScrollViewDelegate> _Nullable)delegate
{
    _delegate = delegate;
}
- (void)setHorizontalScrollViewList:(NSArray *)horizontalScrollViewList {
    _horizontalScrollViewList = horizontalScrollViewList;
    
    NSMutableArray *list = [NSMutableArray arrayWithArray:horizontalScrollViewList];
    if (![list containsObject:self.containerView.scrollView]) {
        [list addObject:self.containerView.scrollView];
    }
    self.mainTableView.horizontalScrollViewList = list;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainTableView.frame = self.bounds;
    if (!CGRectEqualToRect(self.bounds, self.mainTableView.frame)) {
        self.mainTableView.frame = self.bounds;
        [self.mainTableView reloadData];
    }
}
#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isLoaded ? 1 : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView  =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderView"];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderView"];
    }
    headerView.contentView.backgroundColor = tableView.backgroundColor;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView  =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewFooterView"];
    if (footerView == nil) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewFooterView"];
    }
    footerView.contentView.backgroundColor = tableView.backgroundColor;
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(self.mainTableView.frame) - self.ceilPointHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *segmentedView = [self.dataSource titleViewInPageScrollView:self];
    segmentedView.frame = CGRectMake(0, 0, CGRectGetWidth(self.mainTableView.frame), CGRectGetHeight(segmentedView.frame));
    [cell.contentView addSubview:segmentedView];
    
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(segmentedView.frame), CGRectGetWidth(cell.contentView.frame),CGRectGetHeight(cell.contentView.frame)-CGRectGetHeight(segmentedView.frame));
    [cell.contentView addSubview:self.containerView];

    return cell;
}

- (NSInteger)numberOfListsInlistContainerView:(CGXPageHomeScrollContainerView *)listContainerView
{
    return [self.dataSource numberOfListsInPageScrollView:self];;
}
- (id<CGXPageHomeScrollContainerViewListDelegate>)listContainerView:(CGXPageHomeScrollContainerView *)listContainerView initListForIndex:(NSInteger)index
{
    id<CGXPageHomeScrollContainerViewListDelegate> list = self.validListDict[@(index)];
    if (list == nil) {
        list = [self.dataSource pageScrollView:self initListAtIndex:index];
        __weak typeof(self) weakSelf = self;
        if (list && [list respondsToSelector:@selector(listViewDidScrollCallback:)]) {
            [list listViewDidScrollCallback:^(UIScrollView *scrollView) {
                [weakSelf listScrollViewDidScroll:scrollView];
            }];
        }
        self.validListDict[@(index)] = list;
    }
    return list;
}
- (void)refreshHeaderView
{
    CGFloat headHeight = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(headerViewInPageScrollView:)] && [self.dataSource headerViewInPageScrollView:self]) {
        UIView *tableHeaderView = [self.dataSource headerViewInPageScrollView:self];
        headHeight = tableHeaderView.frame.size.height;
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, headHeight)];
        [containerView addSubview:tableHeaderView];
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:tableHeaderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:tableHeaderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:tableHeaderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:tableHeaderView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        [containerView addConstraints:@[top, leading, bottom, trailing]];
        self.mainTableView.tableHeaderView = containerView;
    }
}

- (void)reloadUpdateData
{
    [super reloadUpdateData];
    for (id<CGXPageHomeScrollContainerViewListDelegate> list in self.validListDict.allValues) {
        [list.listView removeFromSuperview];
    }
    [_validListDict removeAllObjects];
    [self refreshHeaderView];
    [self.mainTableView reloadData];
    [self.containerView reloadData];
}
// 菜单左右滚动
- (void)listContainerViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentInter = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageScrollView:listContainerViewAtIndex:)]) {
        [self.dataSource pageScrollView:self listContainerViewAtIndex:currentInter];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isBeginDragging = YES;
    if (self.isScrollToOriginal) {
        self.isScrollToOriginal = NO;
        self.isCeilPoint = NO;
    }
    if (self.isScrollToCritical) {
        self.isScrollToCritical = NO;
        self.isCeilPoint = YES;
    }
    if ([self.delegate respondsToSelector:@selector(pageScrollView:mainTableViewWillBeginDragging:)]) {
        [self.delegate pageScrollView:self mainTableViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pageScrollView:scrollViewDidScroll:)]) {
        [self.delegate pageScrollView:self scrollViewDidScroll:scrollView];
    }
    [self mainScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.isBeginDragging = NO;
    }
    if ([self.delegate respondsToSelector:@selector(pageScrollView:mainTableViewDidEndDragging:willDecelerate:)]) {
        [self.delegate pageScrollView:self mainTableViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isBeginDragging = NO;
    if ([self.delegate respondsToSelector:@selector(pageScrollView:mainTableViewDidEndDecelerating:)]) {
        [self.delegate pageScrollView:self mainTableViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.isScrollToOriginal) {
        self.isScrollToOriginal = NO;
        self.isCeilPoint = NO;
        // 修正listView偏移
        [self listScrollViewOffsetFixed];
    }
    if (self.isScrollToCritical) {
        self.isScrollToCritical = NO;
        self.isCeilPoint = YES;
    }
    [self mainTableViewCanScrollUpdate];
}

// 列表滚动
- (void)listScrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentListScrollView = scrollView;
    if (self.isScrollToOriginal || self.isScrollToCritical) return;
    // 获取listScrollview偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    // listScrollView下滑至offsetY小于0，禁止其滑动，让mainTableView可下滑
    if (offsetY <= 0) {
        if (self.isMainScroll) {
            if (self.isAllowListRefresh && offsetY < 0 && self.isCeilPoint) {
                self.isMainCanScroll = NO;
                self.isListCanScroll = YES;
            }else {
                self.isMainCanScroll = YES;
                self.isListCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                if (self.isControlVerticalIndicator) {
                    scrollView.showsVerticalScrollIndicator = NO;
                }
            }
        }else {
            if (self.isAllowListRefresh && offsetY < 0 && self.mainTableView.contentOffset.y == 0) {
                self.isMainCanScroll = NO;
                self.isListCanScroll = YES;
            }else {
                self.isMainCanScroll = YES;
                self.isListCanScroll = NO;
                if (scrollView.isDecelerating) return;
                scrollView.contentOffset = CGPointZero;
                if (self.isControlVerticalIndicator) {
                    scrollView.showsVerticalScrollIndicator = NO;
                }
            }
        }
    }else {
        if (self.isListCanScroll) {
            if (self.isControlVerticalIndicator) {
                scrollView.showsVerticalScrollIndicator = YES;
            }
            CGFloat headerHeight = CGRectGetHeight([self.dataSource headerViewInPageScrollView:self].frame);
            if (floor(headerHeight) == 0) {
                CGFloat criticalPoint = [self.mainTableView rectForSection:0].origin.y - self.ceilPointHeight;
                self.mainTableView.contentOffset = CGPointMake(0, criticalPoint);
            }else {
                // 如果此时mianTableView并没有滑动，则禁止listView滑动
                if (self.mainTableView.contentOffset.y == 0 && floor(headerHeight) != 0) {
                    self.isMainCanScroll = YES;
                    self.isListCanScroll = NO;
                    if (scrollView.isDecelerating) return;
                    scrollView.contentOffset = CGPointZero;
                    if (self.isControlVerticalIndicator) {
                        scrollView.showsVerticalScrollIndicator = NO;
                    }
                }else { // 矫正mainTableView的位置
                    CGFloat criticalPoint = [self.mainTableView rectForSection:0].origin.y - self.ceilPointHeight;
                    self.mainTableView.contentOffset = CGPointMake(0, criticalPoint);
                }
            }
        }else {
            if (scrollView.isDecelerating) return;
            scrollView.contentOffset = CGPointZero;
        }
    }
    
}

- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isBeginDragging) {
        // 点击状态栏滑动
        [self listScrollViewOffsetFixed];
        [self mainTableViewCanScrollUpdate];
        return;
    }
    // 获取mainScrollview偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    // 临界点
    CGFloat criticalPoint = [self.mainTableView rectForSection:0].origin.y - self.ceilPointHeight;
    if (self.isScrollToOriginal || self.isScrollToCritical) return;
    // 根据偏移量判断是否上滑到临界点
    if (offsetY >= criticalPoint) {
        self.isCriticalPoint = YES;
    }else {
        self.isCriticalPoint = NO;
    }
    // 无偏差临界点，对float值取整判断
    if (!self.isCeilPoint ) {
        if (floor(offsetY) == floor(criticalPoint)) {
            self.isCeilPoint = YES;
        }
    }
    if (self.isCriticalPoint) {
        // 上滑到临界点后，固定其位置
        scrollView.contentOffset = CGPointMake(0, criticalPoint);
        self.isMainCanScroll = NO;
        self.isListCanScroll = YES;
    }else {
        // 当滑动到无偏差临界点且不允许mainScrollView滑动时做处理
        if (self.isCeilPoint && self.isMainScroll) {
            self.isMainCanScroll = NO;
            self.isListCanScroll = YES;
            scrollView.contentOffset = CGPointMake(0, criticalPoint);
        }else {
            if (self.isMainScroll) {
                if (self.isMainCanScroll) {
                    // 未达到临界点，mainScrollview可滑动，需要重置所有listScrollView的位置
                    [self listScrollViewOffsetFixed];
                }else {
                    // 未到达临界点，mainScrollView不可滑动，固定mainScrollView的位置
                    [self mainScrollViewOffsetFixed];
                }
            }else {
                // 如果允许列表刷新，并且mainTableView的offsetY小于0 或者 当前列表的offsetY小于0,mainScrollView不可滑动
                if (self.isAllowListRefresh && ((offsetY <= 0 && self.isMainCanScroll) || (self.currentListScrollView.contentOffset.y < 0 && self.isListCanScroll))) {
                    scrollView.contentOffset = CGPointZero;
                }else {
                    if (self.isMainCanScroll) {
                        // 未达到临界点，mainScrollview可滑动，需要重置所有listScrollView的位置
                        [self listScrollViewOffsetFixed];
                    }else {
                        // 未到达临界点，mainScrollView不可滑动，固定mainScrollView的位置
                        [self mainScrollViewOffsetFixed];
                    }
                }
            }
        }
    }
    [self mainTableViewCanScrollUpdate];
}
// 修正mainTableView的位置
- (void)mainScrollViewOffsetFixed {
    // 获取临界点位置
    CGFloat criticalPoint = [self.mainTableView rectForSection:0].origin.y - self.ceilPointHeight;
    for (id<CGXPageHomeScrollContainerViewListDelegate> list in self.validListDict.allValues) {
        if (list && [list respondsToSelector:@selector(listScrollView)]) {
            UIScrollView *listScrollView = [list listScrollView];
            if (listScrollView.contentOffset.y != 0) {
                self.mainTableView.contentOffset = CGPointMake(0, criticalPoint);
            }
        }
    }
}
// 修正listScrollView的位置
- (void)listScrollViewOffsetFixed {
    
    for (id<CGXPageHomeScrollContainerViewListDelegate> list in self.validListDict.allValues) {
        if (list && [list respondsToSelector:@selector(listScrollView)]) {
            UIScrollView *listScrollView = [list listScrollView];
            listScrollView.contentOffset = CGPointZero;
            if (self.isControlVerticalIndicator) {
                listScrollView.showsVerticalScrollIndicator = NO;
            }
        }
    }
}
- (void)mainTableViewCanScrollUpdate {
    if ([self.delegate respondsToSelector:@selector(pageScrollView:mainTableViewDidScroll:isMainCanScroll:)]) {
        [self.delegate pageScrollView:self mainTableViewDidScroll:self.mainTableView isMainCanScroll:self.isMainCanScroll];
    }
}
- (void)scrollHorizonViewWillBeginScroll {
    self.mainTableView.scrollEnabled = NO;
}
- (void)scrollHorizonViewDidEndScroll {
    self.mainTableView.scrollEnabled = YES;
}
- (void)scrollToOriginalPoint {
    // 这里做了0.01秒的延时，是为了解决一个坑：当通过手势滑动结束调用此方法时，会有可能出现动画结束后UITableView没有回到原点的bug
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isScrollToOriginal) return;
        self.isScrollToOriginal  = YES;
        self.isCeilPoint         = NO;
        self.isMainCanScroll     = YES;
        self.isListCanScroll     = NO;
        [self.mainTableView setContentOffset:CGPointZero animated:YES];
    });
}
- (void)scrollToCriticalPoint {
    if (self.isScrollToCritical) return;
    self.isScrollToCritical = YES;
    CGFloat criticalPoint = [self.mainTableView rectForSection:0].origin.y - self.ceilPointHeight;
    [self.mainTableView setContentOffset:CGPointMake(0, criticalPoint) animated:YES];
    self.isMainCanScroll = NO;
    self.isListCanScroll = YES;
    [self mainTableViewCanScrollUpdate];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
