//
//  CGXPageHomeBaseView.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXPageHomeBaseView.h"

@interface CGXPageHomeBaseView()

// 是否加载
@property (nonatomic, assign,readwrite) BOOL                      isLoaded;

@property (nonatomic, assign, readwrite) CGXPageHomeScrollContainerType containerType;

@property (nonatomic, weak ,readwrite) id<CGXPageHomeScrollViewDataSource> dataSource;

@end

@implementation CGXPageHomeBaseView

- (instancetype)initWithDelegate:(id<CGXPageHomeScrollViewDataSource>)dataSource
{
    return [self initWithDelegate:dataSource listContainerType:CGXPageHomeScrollContainerType_ScrollView];
}
- (instancetype)initWithDelegate:(id<CGXPageHomeScrollViewDataSource>)dataSource listContainerType:(CGXPageHomeScrollContainerType)type
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dataSource = dataSource;
        _containerType = type;
        [self initializeData];
        [self initializeViews];
    }
    return self;
}
- (void)initializeData
{
    self.isLoaded = NO;
    self.controlVerticalIndicator=NO;
    self.ceilPointHeight = 0;
}
- (void)initializeViews
{

}
- (void)layoutSubviews {
    [super layoutSubviews];
}
- (void)setDataSource:(id<CGXPageHomeScrollViewDataSource> _Nullable)dataSource
{
    _dataSource = dataSource;
}

- (void)reloadData
{
    self.isLoaded = YES;
    [self reloadUpdateData];
}
- (void)reloadUpdateData
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
