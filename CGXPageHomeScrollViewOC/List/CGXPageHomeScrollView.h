//
//  CGXPageHomeScrollView.h
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXPageHomeBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class CGXPageHomeScrollView;

@protocol CGXPageHomeScrollViewDelegate <NSObject>
@required

@optional
#pragma mark - mainTableView滚动相关方法
/**
 mainTableView开始滑动
 @param scrollView mainTableView
 */
- (void)pageScrollView:(CGXPageHomeScrollView *)pageScrollView scrollViewDidScroll:(UIScrollView *)scrollView;
/**
 mainTableView开始滑动
 @param scrollView mainTableView
 */
- (void)pageScrollView:(CGXPageHomeScrollView *)pageScrollView mainTableViewWillBeginDragging:(UIScrollView *)scrollView;
/**
 mainTableView滑动，用于实现导航栏渐变、头图缩放等
 @param scrollView mainTableView
 @param isMainCanScroll mainTableView是否可滑动，YES表示可滑动，没有到达临界点，NO表示不可滑动，已到达临界点
 */
- (void)pageScrollView:(CGXPageHomeScrollView *)pageScrollView mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll;
/**
 mainTableView结束滑动
 @param scrollView mainTableView
 @param decelerate 是否将要减速
 */
- (void)pageScrollView:(CGXPageHomeScrollView *)pageScrollView mainTableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
/**
 mainTableView结束滑动
 @param scrollView mainTableView
 */
- (void)pageScrollView:(CGXPageHomeScrollView *)pageScrollView mainTableViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface CGXPageHomeScrollView : CGXPageHomeBaseView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<CGXPageHomeScrollViewDelegate> delegate;

/// 主列表
@property (nonatomic, strong, readonly) CGXPageHomeTableView  *mainTableView;;
// 当前已经加载过的可用的列表字典，key是index值，value是对应列表
@property (nonatomic, strong, readonly) NSMutableDictionary <NSNumber *, id<CGXPageHomeScrollContainerViewListDelegate>> *validListDict;

/// 外层滚动视图容器 手势冲突
@property (nonatomic, strong) NSArray *horizontalScrollViewList;

/// 当前滑动的视图容器
@property (nonatomic,strong,readonly) CGXPageHomeScrollContainerView *containerView;
/// 当前滑动的子列表
@property (nonatomic, weak, readonly) UIScrollView *currentListScrollView;
// 是否在吸顶状态下禁止mainScroll滑动
@property (nonatomic, assign) BOOL     isMainScroll;
// 是否允许子列表下拉刷新
@property (nonatomic, assign) BOOL              isAllowListRefresh;

/**
  刷新头部
 */
- (void)refreshHeaderView;
/**
  处理左右滑动与上下滑动的冲突
 */
- (void)scrollHorizonViewWillBeginScroll;
- (void)scrollHorizonViewDidEndScroll;
/**
 滑动到原点，可用于在吸顶状态下，点击返回按钮，回到原始状态
 */
- (void)scrollToOriginalPoint;
/**
 滑动到临界点，可用于当headerView较长情况下，直接跳到临界点状态
 */
- (void)scrollToCriticalPoint;

// 用于子类自行处理滑动
- (void)listScrollViewDidScroll:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView NS_REQUIRES_SUPER;


@end

NS_ASSUME_NONNULL_END
