//
//  NewsCenterModel.h
//  SRBApp
//
//  Created by zxk on 15/3/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"
/**
 *  @brief  新消息提示model
 */
@interface NewsCenterModel : ZZBaseObject
@property (nonatomic,copy)NSString * content;           //内容
@property (nonatomic,copy)NSString * ID;                //id
@property (nonatomic,copy)NSString * isNew;             //是否是未读
@property (nonatomic,copy)NSString * module;            //类型
@property (nonatomic,copy)NSString * title;             //标题
@property (nonatomic,copy)NSString * updatetime;        //
@property (nonatomic,copy)NSString * updatetimeLong;
@property (nonatomic,copy)NSString * value;             //value值
@property (nonatomic, strong)NSString * account;        //账号
@end
