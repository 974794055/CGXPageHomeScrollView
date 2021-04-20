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
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];;
    }
    return [gestureRecognizer.view isKindOfClass:[UIScrollView class]] && [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]];
}
@end
