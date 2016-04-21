//
//  FriendGroupModel.h
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface FriendGroupModel : ZZBaseObject
@property (nonatomic,strong)NSString * count;
@property (nonatomic,strong)NSArray * group;
@property (nonatomic,strong)NSString * groupId;
@property (nonatomic,strong)NSString * groupName;
@property (nonatomic,strong)NSString * groupOrder;
@property (nonatomic,assign)BOOL isZhedie;
@end
