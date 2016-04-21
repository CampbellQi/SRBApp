//
//  ZZLeftVCModel.h
//  SRBApp
//
//  Created by zxk on 14/12/17.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface ZZLeftVCModel : ZZBaseObject
@property (nonatomic,copy)NSString * title; //标题
@property (nonatomic,copy)NSString * icon;  //图片
@property (nonatomic,copy)void (^operation)();  //点击cell执行的操作
@property (nonatomic,assign)Class showVCClass;  //即将显示的控制器的类

+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title;
@end
