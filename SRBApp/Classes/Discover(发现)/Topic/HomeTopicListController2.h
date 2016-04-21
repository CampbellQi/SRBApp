//
//  HomeTopicController2.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/29.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"
#import "BaseTopicController.h"

@protocol HomeTopicListController2Delegate <NSObject>

-(void)scrollWithContentOffset:(CGPoint)contentOffset;

@end

@interface HomeTopicListController2 : BaseTopicController
@property (nonatomic, strong)NSString *categoryID;

@property (nonatomic, assign)id <HomeTopicListController2Delegate> delegate;
@end
