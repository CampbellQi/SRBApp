//
//  BuyandSayCellFrame.h
//  SRBApp
//
//  Created by fengwanqi on 15/8/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarkModel.h"

@interface BuyandSayCellFrame : NSObject
@property (nonatomic, assign)CGRect headImageF;
@property (nonatomic, assign)CGRect titleLabelF;
@property (nonatomic, assign)CGRect sayLabelF;
@property (nonatomic, assign)CGRect dateLabelF;
@property (nonatomic, assign)CGRect goodCommentF;
@property (nonatomic, assign)CGRect commentImgF;
@property (nonatomic, assign)CGRect photosViewF;
@property (nonatomic,assign)CGFloat cellHeight;

@property (nonatomic, strong)MarkModel *markModel;
@end
