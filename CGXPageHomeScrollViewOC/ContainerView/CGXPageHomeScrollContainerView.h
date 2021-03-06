//
//  CGXPageHomeScrollContainerView.h
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGXPageHomeTableView.h"

#import "CGXPageHomeScrollContainerViewListDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class CGXPageHomeScrollContainerView;

/**
 列表容器视图的类型
 - ScrollView: UIScrollView。优势：没有其他副作用。劣势：视图内存占用相对大一点。
 - CollectionView:UICollectionView。优势：因为列表被添加到cell上，视图的内存占用更少。劣势：因为cell重用机制的问题，导致列表下拉刷新视图，会因为被removeFromSuperview而被隐藏。需要做特殊处理。
 */
typedef NS_ENUM(NSUInteger, CGXPageHomeScrollContainerType) {
    CGXPageHomeScrollContainerType_ScrollView,
    CGXPageHomeScrollContainerType_CollectionView,
};

@protocol CGXPageHomeScrollContainerViewContentDelegate <NSObject>
/**
 返回list的数量
 
 @param listContainerView 列表的容器视图
 @return list的数量
 */
- (NSInteger)numberOfListsInlistContainerView:(CGXPageHomeScrollContainerView *)listContainerView;

/**
 根据index返回一个对应列表实例，需要是遵从`CGXPageHomeScrollContainerViewListDelegate`协议的对象。
 你可以代理方法调用的时候初始化对应列表，达到懒加载的效果。这也是默认推荐的初始化列表方法。你也可以提前创建好列表，等该代理方法回调的时候再返回也可以，达到预加载的效果。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`CGXPageHomeScrollContainerViewListDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`CGXPageHomeScrollContainerViewListDelegate`协议，该方法返回自定义UIViewController即可。
 
 @param listContainerView 列表的容器视图
 @param index 目标下标
 @return 遵从CGXPageHomeScrollContainerViewListDelegate协议的list实例
 */
- (id<CGXPageHomeScrollContainerViewListDelegate>)listContainerView:(CGXPageHomeScrollContainerView *)listContainerView initListForIndex:(NSInteger)index;

@optional
/**
 返回自定义UIScrollView或UICollectionView的Class
 某些特殊情况需要自己处理UIScrollView内部逻辑。比如项目用了FDFullscreenPopGesture，需要处理手势相关代理。
 
 @param listContainerView CGXPageHomeScrollContainerView
 @return 自定义UIScrollView实例
 */
- (Class)scrollViewClassInlistContainerView:(CGXPageHomeScrollContainerView *)listContainerView;

/**
 控制能否初始化对应index的列表。有些业务需求，需要在某些情况才允许初始化某些列表，通过通过该代理实现控制。
 */
- (BOOL)listContainerView:(CGXPageHomeScrollContainerView *)listContainerView canInitListAtIndex:(NSInteger)index;

- (void)listContainerViewDidScroll:(UIScrollView *)scrollView;

- (void)listContainerView:(CGXPageHomeScrollContainerView *)listContainerView ScrollAtIndex:(NSInteger)index;

@end


@interface CGXPageHomeScrollContainerView : UIView

@property (nonatomic, weak) CGXPageHomeTableView *mainTableView;

@property (nonatomic, assign, readonly) CGXPageHomeScrollContainerType containerType;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) NSDictionary <NSNumber *, id<CGXPageHomeScrollContainerViewListDelegate>> *validListDict;   //已经加载过的列表字典。key是index，value是对应的列表

@property (nonatomic, assign) NSInteger defaultSelectInter; //默认NO
/**
 滚动切换的时候，滚动距离超过一页的多少百分比，就触发列表的初始化。默认0.01（即列表显示了一点就触发加载）。范围0~1，开区间不包括0和1
 */
@property (nonatomic, assign) CGFloat initListPercent;
@property (nonatomic, assign) BOOL bounces; //默认NO
@property (nonatomic, assign) BOOL animated;//默认NO
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithType:(CGXPageHomeScrollContainerType)type delegate:(id<CGXPageHomeScrollContainerViewContentDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)scrollSelectedItemAtIndex:(NSInteger)index;

- (void)reloadData;

/*
 自定义菜单相关方法调用
 */
// 菜单点击
- (void)didClickSelectedItemAtIndex:(NSInteger)index;
//菜单滚动
- (void)scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio selectedIndex:(NSInteger)selectedIndex;
@end

NS_ASSUME_NONNULL_END
