//
//  CustomTitleView.h
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CustomTitleView : UIView

@property (nonatomic, copy) void(^selectBtnBlock)(NSInteger inter);

@property (nonatomic, strong) UIColor *textNormalColor;
@property (nonatomic, strong) UIColor *textSelectColor;

@property (nonatomic, strong) UIColor *textNormalBgColor;
@property (nonatomic, strong) UIColor *textSelectBgColor;

@property (nonatomic, strong) UIFont *textNormalFont;
@property (nonatomic, strong) UIFont *textSelectFont;


@property (nonatomic, assign) BOOL isMoreClick;// 是否支持多次点击 默认NO
-  (void)updateDataTitieArray:(NSArray<NSString *> *)titleArray;

-  (void)updateDataTitieArray:(NSArray<NSString *> *)titleArray Inter:(NSInteger)inter;

-  (void)scrollViewInter:(NSInteger)inter;

@end

NS_ASSUME_NONNULL_END
