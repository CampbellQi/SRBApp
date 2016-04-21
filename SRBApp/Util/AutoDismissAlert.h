//
//  AutoDismissAlert.h
//  SRBApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import <Foundation/Foundation.h>
/*! @brief 自动消失提示框
 *  @description
 */

@interface AutoDismissAlert : NSObject
+ (void)autoDismissAlert:(NSString *)string;
+ (void)autoDismissAlertSecond:(NSString *)string;
@end
