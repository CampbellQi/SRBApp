//
//  PersonalOrderOperateView.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
//状态定义
//申请代购单
#define APPLY_HELPSP_STATUS @"APPLY_HELPSP_STATUS"

#import <UIKit/UIKit.h>
#import "BussinessModel.h"


@interface PersonalOrderOperateView : UIView


-(id)initWithFrame:(CGRect)frame OrderStatus:(NSString *)orderStatus CurrentViewController:(UIViewController *)currentVC BussinessModel:(BussinessModel *)bussinessModel;
@end
