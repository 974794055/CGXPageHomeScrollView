//
//  CGXPageHomeScrollContainerViewController.h
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGXPageHomeScrollContainerViewController : UIViewController

@property (copy) void(^__nullable viewWillAppearBlock)(void);
@property (copy) void(^__nullable viewDidAppearBlock)(void);
@property (copy) void(^__nullable viewWillDisappearBlock)(void);
@property (copy) void(^__nullable viewDidDisappearBlock)(void);

@end

NS_ASSUME_NONNULL_END
