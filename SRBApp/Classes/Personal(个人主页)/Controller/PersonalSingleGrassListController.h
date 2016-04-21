//
//  PersonalSingleGrassListController.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/23.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"
//#import "BussinessModel.h"
#import "MJRefresh.h"
#import "ZZMyAttentionInfoModel.h"

@protocol PersonalSingleGrassListControllerDelegate <NSObject>

-(void)scrollwithVelocity:(CGPoint)velocity;

@end

@interface PersonalSingleGrassListController : SRBBaseViewController

@property (nonatomic,assign) id <PersonalSingleGrassListControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy)NSString * account;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLB;

@property (weak, nonatomic) IBOutlet UIView *totalPriceView;

-(void)totalPriceRequest;
@end
