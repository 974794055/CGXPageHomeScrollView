//
//  CGXPageHomeUIScrollView.h
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CGXPageHomeUIScrollView;

@protocol CGXPageHomeUIScrollViewGestureDelegate <NSObject>

@optional

- (BOOL)gx_pageHomeScrollView:(CGXPageHomeUIScrollView *)scrollView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

- (BOOL)gx_pageHomeScrollView:(CGXPageHomeUIScrollView *)scrollView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end
@interface CGXPageHomeUIScrollView : UIScrollView<UIGestureRecognizerDelegate>

@property (nonatomic,assign) BOOL isNestEnabled;
@property (nonatomic, weak) id<CGXPageHomeUIScrollViewGestureDelegate> gestureDelegate;

@end

NS_ASSUME_NONNULL_END
