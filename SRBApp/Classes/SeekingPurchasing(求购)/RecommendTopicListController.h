//
//  RecommendTopicListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BaseMarkTopicListController.h"

@protocol RecommendTopicListControllerDelegate <NSObject>
-(void)scrollViewWillEndDraggingDelegate:(CGPoint)velocity;
@end

@interface RecommendTopicListController : BaseMarkTopicListController
@property (nonatomic, strong)NSString *name;

@property (nonatomic, assign)id <RecommendTopicListControllerDelegate> delegate;
@end
