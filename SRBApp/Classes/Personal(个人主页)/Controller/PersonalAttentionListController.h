//
//  PersonalAttentionListController.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/23.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface PersonalAttentionListController : SRBBaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
