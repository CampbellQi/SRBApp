//
//  AutoDismissAlert.m
//  SRBApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "AutoDismissAlert.h"
#import "AppDelegate.h"

@implementation AutoDismissAlert
/**
 *  @brief  自动消失提示框
 *  @param string 显示的内容
 */
+ (void)autoDismissAlert:(NSString *)string
{
    if (string == nil || [string isEqualToString:@""]) {
        string = @"连接异常";
    }
    if (0) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window.rootViewController presentViewController:vc animated:YES completion:nil];
        [vc dismissViewControllerAnimated:YES completion:nil];
    }else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
        [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@"0",@"1"] afterDelay:1.5];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    // 遍历 UIAlertView 所包含的所有控件
    for (UIView *tempView in alertView.subviews) {
        
        if ([tempView isKindOfClass:[UILabel class]]) {
            // 当该控件为一个 UILabel 时
            UILabel *tempLabel = (UILabel *) tempView;
            
            if ([tempLabel.text isEqualToString:alertView.message]) {
                // 调整对齐方式
                tempLabel.textAlignment = UITextAlignmentLeft;
                // 调整字体大小
                [tempLabel setFont:[UIFont systemFontOfSize:8.0]];
            }
        }
    }
}



/**
 *  @brief  自动消失提示框(1.5s)
 *  @param string 显示的内容
 */
+ (void)autoDismissAlertSecond:(NSString *)string
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@"0",@"1"] afterDelay:1.5];
}
@end
