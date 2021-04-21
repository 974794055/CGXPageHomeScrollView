# CGXPageHomeScrollView-OC

[![platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=plastic)](#)
[![languages](https://img.shields.io/badge/language-objective--c-blue.svg)](#) 
[![cocoapods](https://img.shields.io/badge/cocoapods-supported-4BC51D.svg?style=plastic)](https://cocoapods.org/pods/CGXPageHomeScrollViewOC)
[![support](https://img.shields.io/badge/support-ios%208%2B-orange.svg)](#) 

## 基于UICollectionView和UITableView封装悬浮库

- 下载链接：https://github.com/974794055/CGXPageHomeScrollView.git
-  pod名称 ：CGXPageHomeScrollViewOC
- 最新版本号： 0.1

- 功能：    
- CGXPageHomeScrollViewOC是基于UICollectionView和UITableView封装的等主流APP个人主页列表滚动视图的库
 
 效果：
- 1、支持上下滑动、左右滑动等
- 2、支持如UITableView的头部悬停效果
- 3、可实现导航栏颜色渐变、头图下拉放大等效果
- 4、支持主页、列表页下拉刷新，列表页上拉加载

## 效果预览
### 主列表效果预览

说明 | Gif |
----|------|
效果🌈普通列表  |  <img src="https://github.com/974794055/CGXPageHomeScrollView/blob/master/CGXPageHomeScrollViewGif/scoller0" width="287" height="600"> |
效果🌈个人主页  |  <img src="https://github.com/974794055/CGXPageHomeScrollView/blob/master/CGXPageHomeScrollViewGif/scoller1.giit" width="287" height="600"> |
效果🌈顶部悬浮  |  <img src="https://github.com/974794055/CGXPageHomeScrollView/blob/master/CGXPageHomeScrollViewGif/scoller2.giit" width="287" height="600"> |
效果🌈主页刷新  |  <img src="https://github.com/974794055/CGXPageHomeScrollView/blob/master/CGXPageHomeScrollViewGif/scoller3.giit" width="287" height="600"> |
效果🌈列表刷新  |  <img src="https://github.com/974794055/CGXPageHomeScrollView/blob/master/CGXPageHomeScrollViewGif/scoller4.giit" width="287" height="600"> |
效果🌈Header左右滑动  |  <img src="https://github.com/974794055/CGXPageHomeScrollView/blob/master/CGXPageHomeScrollViewGif/scoller5.giit" width="287" height="600"> |

## 要求
- iOS 8.0+
- Xcode 9+
- Objective-C

## 安装
### 手动
Clone代码，把CGXPageHomeScrollViewOC文件夹拖入项目，#import "CGXPageHomeScrollViewOC.h"，就可以使用了；
### CocoaPods
```ruby
target '<Your Target Name>' do
    pod 'CGXPageHomeScrollViewOC'
end
```
先执行`pod repo update`，再执行`pod install`

## 使用
### CGXPageHomeScrollView使用示例
1.初始化CGXPageHomeScrollView
```Objective-C
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
```
2.加载CGXPageHomeScrollView数据源
```Objective-C
- (UIView *)headerViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView {

    CGXHeaderView *headerView = [[CGXHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kBHeaderHeight)];
        headerView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
        self.headerView = headerView;
    return self.headerView;;
}
- (UIView *)titleViewInPageScrollView:(CGXPageHomeBaseView *)pageScrollView {
    __weak typeof(self) weakSelf = self;
    CustomTitleView *categoryView = [[CustomTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSegmentHeight)];
    categoryView.backgroundColor = [UIColor whiteColor];
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
```
## 更新记录
## V0.1版本
- 1. 优化

如果刚开始使用`CGXPageHomeScrollViewOC`，当开发过程中需要支持某种特性时，请务必先搜索使用文档或者源代码。如果没有支持想要的特性，欢迎提Issue讨论，或者自己实现提一个PullRequest。

该仓库保持随时更新，对于主流新的列表效果会第一时间支持。使用过程中，有任何建议或问题，可以通过以下方式联系我：</br>
邮    箱：974794055@qq.com </br>
群名称：潮流App-iOS交流</br>
QQ  群：227219165</br>
QQ  号：974794055</br>
<img src="https://github.com/974794055/CGXPageHomeScrollView/blob/master/CGXPageHomeScrollViewGif/authorGroup.png" width="300" height="411">
喜欢就star❤️一下吧

## License

CGXPageHomeScrollViewOC is released under the MIT license.
