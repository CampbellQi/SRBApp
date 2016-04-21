//
//  UIViewController+PushAnimate.h
//  SRBApp
//
//  Created by yujie on 14/12/29.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PushAnimate)
- (void)pushViewController:(UIViewController*)controller Completion:(void (^) (void))completion;
- (void)dismissViewController;
- (void)optionDismissViewController;
@end
