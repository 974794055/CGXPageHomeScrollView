//
//  CGXPageHomeCollectionView.h
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CGXPageHomeCollectionView;

@protocol CGXPageHomeCollectionViewGestureDelegate <NSObject>

- (BOOL)gx_pageHomeCollectionView:(CGXPageHomeCollectionView *)collectionView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)gx_pageHomeCollectionView:(CGXPageHomeCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@interface CGXPageHomeCollectionView : UICollectionView<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isNestEnabled;
@property (nonatomic, weak) id<CGXPageHomeCollectionViewGestureDelegate> gestureDelegate;

@end

NS_ASSUME_NONNULL_END
