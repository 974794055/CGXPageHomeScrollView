//
//  CGXHomeListTwoViewController.h
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGXHomeListTwoViewController : UIViewController<CGXPageHomeScrollContainerViewListDelegate>

@property (nonatomic, copy) void(^scrollToTop)(CGXHomeListTwoViewController *listVC,NSIndexPath *indexPath);

@property (nonatomic, strong,readonly) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
