//
//  HandleMsgCenter.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsCenterModel.h"

@interface HandleNewsCenter : NSObject
+(void)handleMsgCenterModule:(NSString *)module Value:(NSString *)value NavigationController:(UINavigationController *)navigationController;
@end
