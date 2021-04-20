//
//  CGXPageHomeZoomView.h
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXPageHomeScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGXPageHomeZoomView : CGXPageHomeScrollView


/** 加载图片 */
@property (nonatomic, copy) void(^pageHomeZ_loadImageCallback)(UIImageView *hotImageView);

// 背景拉升的高度 默认等于头部高度
@property (nonatomic, assign) CGFloat zoomHeight;

@property (nonatomic, strong) NSString *zoomImageStr;

@end

NS_ASSUME_NONNULL_END
