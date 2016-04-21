//
//  LogisticsController.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/26.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#import "SRBBaseViewController.h"

@interface LogisticsController : SRBBaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSString *invoiceNo;
@property (nonatomic, strong)NSString *invoiceName;
@property (nonatomic, strong)NSString *coverUrl;
@end
