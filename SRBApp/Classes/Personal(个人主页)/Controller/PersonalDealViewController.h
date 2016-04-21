//
//  PersonalDealViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalViewController.h"
@interface PersonalDealViewController : UITableViewController
{
    NSMutableArray * dataArray;
}
@property (nonatomic,strong)NSString * saleAndBuyType;
@property (nonatomic,strong)NSString * categoryID;
@property (nonatomic,copy)NSString * account;
@property (nonatomic, strong) PersonalViewController * personVC;

@end
