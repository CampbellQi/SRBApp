//
//  PersonalLocationViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewController.h"
#import "PersonalViewController.h"
@interface PersonalLocationViewController : ZZTableViewController
- (void)urlRequestPost;
@property (nonatomic,copy)NSString * account;
@property (nonatomic, strong) PersonalViewController * personVC;
@end
