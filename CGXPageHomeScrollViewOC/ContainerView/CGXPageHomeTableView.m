//
//  CGXPageHomeTableView.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXPageHomeTableView.h"

@implementation CGXPageHomeTableView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.gestureDelegate respondsToSelector:@selector(gx_pageHomeTableView:gestureRecognizerShouldBegin:)]) {
        return [self.gestureDelegate gx_pageHomeTableView:self gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}

// 允许多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.gestureDelegate respondsToSelector:@selector(gx_pageHomeTableView:gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.gestureDelegate gx_pageHomeTableView:self gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    if (self.horizontalScrollViewList) {
        __block BOOL exist = NO;
        [self.horizontalScrollViewList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([gestureRecognizer.view isEqual:obj]) {
                exist = YES;
                *stop = YES;
            }
            if ([otherGestureRecognizer.view isEqual:obj]) {
                exist = YES;
                *stop = YES;
            }
        }];
        if (exist) return NO;
    }
    return [gestureRecognizer.view isKindOfClass:[UIScrollView class]] && [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]];
}
@end
