//
//  PersonalHelpSpApplyListController.h
//  SRBApp
//  代购申请
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#import "SRBBaseViewController.h"
#import "PersonalOrderOperateButton.h"

@interface PersonalHelpSpApplyListController : SRBBaseViewController<PersonalOrderOperateButtonDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSString *modelID;
@property (nonatomic, assign)BOOL hiddenOperation;
@end
