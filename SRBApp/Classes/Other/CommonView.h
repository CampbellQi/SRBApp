//
//  CommonView.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonView : UIView
+(UIBarButtonItem *)backBarButtonItemTarget:(id)target Action:(SEL)action;
+(UIBarButtonItem *)rightWithBgBarButtonItemTitle:(NSString *)title Target:(id)target Action:(SEL)action;
+(UIBarButtonItem *)rightBarButtonItemTitle:(NSString *)title Target:(id)target Action:(SEL)action;
@end
