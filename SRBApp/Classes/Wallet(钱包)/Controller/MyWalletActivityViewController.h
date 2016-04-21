//
//  MyWalletActivityViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/21.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface MyWalletActivityViewController : ZZViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSString *aliPayAccount;//支付宝账号
@end
