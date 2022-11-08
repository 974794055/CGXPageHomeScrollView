//
//  CustomTitleView.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CustomTitleView.h"
@interface CustomTitleView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSString *> *titleArray;
@property (nonatomic, assign) NSInteger currentInter;
@property (nonatomic , strong) UIView *lineView;
@end
@implementation CustomTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentInter = 0;
        self.textNormalColor = [UIColor blackColor];
        self.textSelectColor = [UIColor redColor];
        
        self.textNormalBgColor = [UIColor whiteColor];
        self.textSelectBgColor = [UIColor whiteColor];;
       
        self.textNormalFont = [UIFont systemFontOfSize:13];
        self.textSelectFont = [UIFont systemFontOfSize:13];
        self.isMoreClick  = NO;
        self.titleArray = [NSMutableArray array];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *mCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        mCollectionView.backgroundColor = [UIColor clearColor];
        mCollectionView.showsHorizontalScrollIndicator = YES;
        mCollectionView.showsVerticalScrollIndicator = YES;
        mCollectionView.dataSource = self;
        mCollectionView.delegate = self;
        [mCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        if (@available(iOS 11.0, *)) {
            mCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:mCollectionView];
        self.collectionView = mCollectionView;
        
        self.lineView =[[UIView alloc]init];
        [self addSubview:self.lineView];
        self.lineView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.lineView.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.frame)/self.titleArray.count,CGRectGetHeight(collectionView.frame));
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
    }];
    UILabel *ppLabel  =[[UILabel alloc] init];
    ppLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:ppLabel];
    
    if (self.currentInter == indexPath.row) {
        ppLabel.textColor = self.textSelectColor;
        ppLabel.font = self.textSelectFont;
    } else{
        ppLabel.textColor = self.textNormalColor;
        ppLabel.font = self.textNormalFont;
    }
    ppLabel.frame = cell.contentView.frame;
    ppLabel.text = self.titleArray[indexPath.row];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self scrollViewInter:indexPath.row];
    if (self.selectBtnBlock) {
        self.selectBtnBlock(indexPath.row);
    }
}
-  (void)updateDataTitieArray:(NSArray<NSString *> *)titleArray
{
    [self updateDataTitieArray:titleArray Inter:0];
}
-  (void)updateDataTitieArray:(NSArray<NSString *> *)titleArray Inter:(NSInteger)inter
{
    [self.titleArray removeAllObjects];
    [self.titleArray addObjectsFromArray:titleArray];
    self.currentInter = inter;
    [self.collectionView reloadData];
}
-  (void)scrollViewInter:(NSInteger)inter
{
    if (inter >=self.titleArray.count) {
        return;
    }
    self.currentInter = inter;
    [self.collectionView reloadData];
}
/*
 // Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
