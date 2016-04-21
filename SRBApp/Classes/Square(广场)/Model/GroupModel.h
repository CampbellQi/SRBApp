//
//  GroupModel.h
//  SRBApp
//
//  Created by zxk on 14/12/29.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface GroupModel : ZZBaseObject
@property (nonatomic,copy)NSString * categoryID;
@property (nonatomic,copy)NSString * categoryName;
@property (nonatomic,copy)NSString * categoryType;
@property (nonatomic,copy)NSString * descriptions;
@property (nonatomic,copy)NSString * pic;
@property (nonatomic,copy)NSString * color;
@property (nonatomic,copy)NSArray * post;           //数组

@end
