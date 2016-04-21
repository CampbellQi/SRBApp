//
//  ZZBaseNavigationController.h
//  bangApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/*! @brief UINavigationController的子类
 
 *  @description继承UINavigationController的子类都用继承它来代替
 */
@interface ZZBaseNavigationController : UINavigationController
@property (nonatomic,strong)UIViewController * currentShowVC;
@end
