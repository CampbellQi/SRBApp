//
//  NewsCenterTransationController.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/26.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface NewsCenterTransationController : SRBBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSString *messageType;
@end
