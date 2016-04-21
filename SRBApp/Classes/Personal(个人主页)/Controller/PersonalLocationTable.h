//
//  PersonalLocationTable.h
//  SRBApp
//
//  Created by zxk on 15/1/20.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TotalViewController.h"
#import "PersonalViewController.h"

@interface PersonalLocationTable : TotalViewController
@property (nonatomic,copy)NSString * account;
@property (nonatomic, strong) PersonalViewController * personVC;

@end
