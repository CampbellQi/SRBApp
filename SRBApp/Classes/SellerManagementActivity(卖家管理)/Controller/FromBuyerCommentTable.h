//
//  FromBuyerCommentTable.h
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ToBuyerCommentTable.h"

@interface FromBuyerCommentTable : ToBuyerCommentTable
@property (nonatomic,strong)NSString * evaGrade;    //评价等级
- (void)urlRequestPost;
@end
