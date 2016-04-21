//
//  GoodsOrderListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/8/31.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTopicController.h"

@interface HomeTopicListController : BaseTopicController

@property (nonatomic, strong) NSString * type;  //第三方登录类型
@property (nonatomic, assign) int resultTP;       //返回结果
@property (nonatomic, strong) NSString *token;  //第三方token
@property (nonatomic, strong) NSString *uid;
@property (nonatomic,assign)BOOL isSquareShow;
@end
