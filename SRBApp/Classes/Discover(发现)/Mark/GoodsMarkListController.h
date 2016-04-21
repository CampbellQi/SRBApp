//
//  GoodsMarkController.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZViewController.h"

@interface GoodsMarkListController : ZZViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
