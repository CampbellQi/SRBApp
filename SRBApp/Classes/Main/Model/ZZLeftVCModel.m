//
//  ZZLeftVCModel.m
//  SRBApp
//
//  Created by zxk on 14/12/17.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZLeftVCModel.h"

@implementation ZZLeftVCModel
+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    ZZLeftVCModel * leftModel = [[self alloc]init];
    leftModel.icon = icon;
    leftModel.title = title;
    return leftModel;
}
@end
