//
//  MarkTopicListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/10.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "BaseMarkTopicListController.h"

typedef void (^BackBlock) (void);
@interface MarkTopicListController : BaseMarkTopicListController

@property (nonatomic, strong)NSString *tagName;
@property (nonatomic, strong)BackBlock backBlock;
@end
