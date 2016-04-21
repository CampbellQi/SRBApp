//
//  ZZAlertView.h
//  SRBApp
//
//  Created by zxk on 15/4/23.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"

@interface ZZAlertView : ZZView
/**
 *  @brief  消失
 */
- (void)dismiss;
/**
 *  @brief  显示的文字
 *  @param str NSString
 */
- (void)setAlertWord:(NSString *)str;
/**
 *  @brief  初始化
 *  @return self
 */
+ (instancetype)zzAlertView;
/**
 *  @brief  设置确定按钮点击事件
 *  @param target 调用哪个对象
 *  @param action 调用target的哪个方法
 */
- (void)setSureBtnEvent:(id)target action:(SEL)action;
/**
 *  @brief  显示alertView
 */
- (void)showAlert;
@end
