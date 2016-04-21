//
//  PersonalTopicListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BaseTopicController.h"

@protocol PersonalTopicListControllerDelegate <NSObject>

-(void)scrollwithVelocity:(CGPoint)velocity;
@end
@interface PersonalTopicListController : BaseTopicController
@property (nonatomic,copy)NSString * account;

@property (nonatomic,assign) id <PersonalTopicListControllerDelegate> delegate;
@end
