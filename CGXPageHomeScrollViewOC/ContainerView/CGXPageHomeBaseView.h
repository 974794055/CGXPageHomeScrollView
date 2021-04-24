//
//  CGXPageHomeBaseView.h
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGXPageHomeTableView.h"
#import "CGXPageHomeScrollContainerView.h"
NS_ASSUME_NONNULL_BEGIN

@class CGXPageHomeBaseView;

@protocol CGXPageHomeScrollViewDataSource <NSObject>

@required
/**
 返回tableHeaderView
 @param pageScrollView pageScrollView description
 @return tableHeaderView
 */
- (UIView *)headerViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView;
/**
 返回中间的segmentedView
 @param pageScrollView pageScrollView description
 @return segmentedView
 */
- (UIView *)titleViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView;
/**
 返回列表的数量
 @param pageScrollView pageScrollView description
 @return 列表的数量
 */
- (NSInteger)numberOfListsInPageScrollView:(CGXPageHomeBaseView *)pageScrollView;
/**
 根据index初始化一个列表实例，需实现`CGXPageHomeScrollContainerViewContentDelegate`代理
 @param pageScrollView pageScrollView description
 @param index 对应的索引
 @return 实例对象
 */
- (id<CGXPageHomeScrollContainerViewListDelegate>)pageScrollView:(CGXPageHomeBaseView *)pageScrollView initListAtIndex:(NSInteger)index;

@optional
/**
 视图容器左右滚动菜单左右滚动
 @param index 对应的索引
 */
- (void)pageScrollView:(CGXPageHomeBaseView *)pageScrollView listContainerViewAtIndex:(NSInteger)index;

@end

@interface CGXPageHomeBaseView : UIView
/*
 初始化
 */
- (instancetype)initWithDelegate:(id<CGXPageHomeScrollViewDataSource>)dataSource;
- (instancetype)initWithDelegate:(id<CGXPageHomeScrollViewDataSource>)dataSource listContainerType:(CGXPageHomeScrollContainerType)type NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak ,readonly) id<CGXPageHomeScrollViewDataSource> dataSource;

@property (nonatomic, assign, readonly) CGXPageHomeScrollContainerType containerType;
// 是否加载
@property (nonatomic, assign,readonly) BOOL isLoaded;

// 是否内部控制指示器的显示与隐藏（默认为NO）
@property (nonatomic, assign, getter=isControlVerticalIndicator) BOOL controlVerticalIndicator;

// 吸顶临界点高度（默认值：状态栏+导航栏）
@property (nonatomic, assign) CGFloat  ceilPointHeight;

- (void)reloadData;


/* 子类使用*/
- (void)reloadUpdateData NS_REQUIRES_SUPER;
- (void)initializeData NS_REQUIRES_SUPER;
- (void)initializeViews NS_REQUIRES_SUPER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;


@end

NS_ASSUME_NONNULL_END
