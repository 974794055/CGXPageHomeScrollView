//
//  CGXPageHomeZoomView.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXPageHomeZoomView.h"
@interface CGXPageHomeZoomView()
@property (nonatomic, strong) UIImageView   *bgImgView;

@property (nonatomic , strong) NSLayoutConstraint *bgImageHeight;
@property (nonatomic , strong) NSLayoutConstraint *bgImageleft;
@property (nonatomic , strong) NSLayoutConstraint *bgImageRight;
@property (nonatomic , strong) NSLayoutConstraint *bgImageTop;
@end

@implementation CGXPageHomeZoomView
- (void)initializeData
{
    [super initializeData];
    self.zoomHeight = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(headerViewInPageScrollView:)] && [self.dataSource headerViewInPageScrollView:self]) {
        UIView *tableHeaderView = [self.dataSource headerViewInPageScrollView:self];
        self.zoomHeight= CGRectGetHeight(tableHeaderView.frame);
    }
}
- (void)initializeViews
{
    [super initializeViews];
    self.bgImgView = [UIImageView new];
    self.bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImgView.clipsToBounds = YES;
    [self.mainTableView addSubview:self.bgImgView];
    [self.mainTableView sendSubviewToBack:self.bgImgView];
    self.bgImgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bgImageTop = [NSLayoutConstraint constraintWithItem:self.bgImgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainTableView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    self.bgImageleft = [NSLayoutConstraint constraintWithItem:self.bgImgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mainTableView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    self.bgImageRight = [NSLayoutConstraint constraintWithItem:self.bgImgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mainTableView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    self.bgImageHeight = [NSLayoutConstraint constraintWithItem:self.bgImgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:CGRectGetHeight(self.frame)];
    [self.mainTableView addConstraint:self.bgImageTop];
    [self.mainTableView addConstraint:self.bgImageleft];
    [self.mainTableView addConstraint:self.bgImageRight];
    [self.bgImgView addConstraint:self.bgImageHeight];
    

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgImageTop.constant = 0;
    self.bgImageleft.constant =0;
    self.bgImageRight.constant = 0;
    self.bgImageHeight.constant = self.zoomHeight;
    __weak typeof(self) weakSelf = self;
    if (self.pageHomeZ_loadImageCallback) {
        self.pageHomeZ_loadImageCallback(weakSelf.bgImgView);
    }
}
- (void)setZoomHeight:(CGFloat)zoomHeight
{
    _zoomHeight = zoomHeight;
}
- (void)reloadUpdateData
{
    [super reloadUpdateData];

}

// 用于自行处理滑动
- (void)listScrollViewDidScroll:(UIScrollView *)scrollView
{
    [super listScrollViewDidScroll:scrollView];
}
- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView
{
    [super mainScrollViewDidScroll:scrollView];
    CGFloat offsetY = scrollView.contentOffset.y;
    self.bgImageTop.constant = offsetY;
    self.bgImageleft.constant = 0;
    self.bgImageRight.constant = 0;
    self.bgImageHeight.constant = self.zoomHeight-offsetY;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
