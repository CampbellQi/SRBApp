//
//  ZZSpecial.h
//  SRBApp
//
//  Created by zxk on 15/4/17.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface ZZSpecial : ZZBaseObject
/** 这段文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 这段特殊文字的矩形框 */
@property (nonatomic,strong)NSArray * rects;
/** 第一个还是第二个名字 */
@property (nonatomic,strong)NSString * nameNum;
/** 模块对应的id */
@property (nonatomic,copy)NSString * goodsID;
/** 模块对应的类型 */
@property (nonatomic,copy)NSString *sourcemodule;
@end
