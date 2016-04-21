//
//  UIViewController+PushAnimate.m
//  SRBApp
//
//  Created by yujie on 14/12/29.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "UIViewController+PushAnimate.h"
#import "AppDelegate.h"
#import "ShoppingViewController.h"

#define durationTime 0.25

@implementation UIViewController (PushAnimate)
- (void)pushViewController:(UIViewController*)controller Completion:(void (^) (void))completion {
    
    
    
    CGRect destFrame = controller.view.frame;
    destFrame.origin.x = controller.view.frame.size.width;
    if (down_IOS_8) {
        destFrame.size.height += 44.0f;
    }
    controller.view.frame = destFrame;
    
    [self.view.superview addSubview:controller.view];

    destFrame.origin.x = 0;
    CGRect sourceFrame = self.view.frame;
    sourceFrame.origin.x = -sourceFrame.size.width;
    
    [UIView animateWithDuration:durationTime
                     animations:^{
                         self.view.frame = sourceFrame;
                         controller.view.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         CGRect d = destFrame;
                         CGRect s = sourceFrame;
                         d.origin.x = 0;
                         s.origin.x = 0;

                         self.view.frame = s;
                         controller.view.frame = d;
                         [self.view addSubview:controller.view];
                         [self addChildViewController:controller];
                         if (completion) {
                             completion();
                         }
                     }];
    
}

- (void)dismissViewController {
    UIView* superView = self.view.superview;
    
    CGRect destFrame = self.view.frame;
    destFrame.origin.x = 0;
    self.view.frame = destFrame;

    CGRect sourceFrame = superView.frame;
    sourceFrame.origin.x = -sourceFrame.size.width;
    superView.frame = sourceFrame;

    [superView.superview addSubview:self.view];

    sourceFrame.origin.x = 0;
    destFrame.origin.x = sourceFrame.size.width;
    [UIView animateWithDuration:durationTime
                     animations:^{
                         superView.frame = sourceFrame;
                         self.view.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         CGRect s = sourceFrame;
                         s.origin.x = 0;
                         superView.frame = s;
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
    AppDelegate * app = APPDELEGATE;
    UINavigationController * tempNC = app.mainTab.viewControllers[0];
    ShoppingViewController * shoppingVC = tempNC.viewControllers[0];
    if (shoppingVC.isSquareShow == YES) {
        shoppingVC.typeView.hidden = YES;
        shoppingVC.sv.frame = CGRectMake(0, 39, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 -49);
        shoppingVC.shopRelationTVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
        shoppingVC.shopRelationTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
        shoppingVC.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
        shoppingVC.shopCircleTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
        CGRect tempBtn1 = shoppingVC.shopRelationTVC.toTopBtn.frame;
        CGRect tempBtn2 = shoppingVC.shopCircleTVC.toTopBtn.frame;
        tempBtn1.origin.y = SCREEN_HEIGHT - 49 - 60 - 64 - 40;
        tempBtn2.origin.y = SCREEN_HEIGHT - 49 - 60 - 64 - 40;
        shoppingVC.shopRelationTVC.toTopBtn.frame = tempBtn1;
        shoppingVC.shopCircleTVC.toTopBtn.frame = tempBtn2;
    }
    
}

- (void)optionDismissViewController
{
    UIView* superView = self.view.superview;
    
    CGRect destFrame = self.view.frame;
    destFrame.origin.x = 0;
    self.view.frame = destFrame;
    
    CGRect sourceFrame = superView.frame;
    sourceFrame.origin.x = -sourceFrame.size.width;
    superView.frame = sourceFrame;
    
    [superView.superview addSubview:self.view];
    
    sourceFrame.origin.x = 0;
    destFrame.origin.x = sourceFrame.size.width;
    [UIView animateWithDuration:0
                     animations:^{
                         superView.frame = sourceFrame;
                         self.view.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         CGRect s = sourceFrame;
                         s.origin.x = 0;
                         superView.frame = s;
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];

}

@end
