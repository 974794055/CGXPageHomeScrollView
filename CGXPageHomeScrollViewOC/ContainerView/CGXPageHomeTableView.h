//
//  CGXPageHomeTableView.h
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CGXPageHomeTableView;

@protocol CGXPageHomeTableViewGestureDelegate <NSObject>

@optional

- (BOOL)gx_pageHomeTableView:(CGXPageHomeTableView *)tableView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

- (BOOL)gx_pageHomeTableView:(CGXPageHomeTableView *)tableView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@interface CGXPageHomeTableView : UITableView<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<CGXPageHomeTableViewGestureDelegate> gestureDelegate;

@property (nonatomic, strong) NSArray *horizontalScrollViewList;

@end

NS_ASSUME_NONNULL_END
