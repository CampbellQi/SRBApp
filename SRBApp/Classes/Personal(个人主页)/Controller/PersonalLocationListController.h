//
//  PersonalLocationListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BaseLocationViewController.h"
#import "PersonalViewController.h"
#import "MJRefresh.h"

@protocol PersonalLocationListControllerDelegate <NSObject>

-(void)scrollwithVelocity:(CGPoint)velocity;

@end

@interface PersonalLocationListController : BaseLocationViewController
@property (nonatomic,copy)NSString * account;
@property (nonatomic, strong) PersonalViewController * personVC;

@property (nonatomic,assign) id <PersonalLocationListControllerDelegate> delegate;
@end
