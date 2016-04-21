//
//  ReceiveGoodsTableViewController.h
//  SRBApp
//
//  Created by lizhen on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveModel.h"
@interface ReceiveGoodsTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *receiveAddrArray;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
