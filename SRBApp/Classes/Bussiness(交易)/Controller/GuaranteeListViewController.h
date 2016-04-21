//
//  GuaranteeListViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface GuaranteeListViewController : ZZViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSString * idnumber;
@end
