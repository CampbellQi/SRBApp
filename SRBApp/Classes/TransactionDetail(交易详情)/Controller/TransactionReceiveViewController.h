//
//  TransactionReceiveViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ReceiveGoodsTableViewController.h"
#import "TransactionDetailViewController.h"
@interface TransactionReceiveViewController : ReceiveGoodsTableViewController
@property (nonatomic,strong)TransactionDetailViewController * transactionVC;
@end
