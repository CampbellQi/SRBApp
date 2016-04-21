//
//  ZZViewController.h
//  bangApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/*! @brief UIViewController的子类
 
 *  @description其他继承UIViewController的子类都用继承它来代替
 */
@interface ZZViewController : UIViewController<UINavigationControllerDelegate>

- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic;

@end
