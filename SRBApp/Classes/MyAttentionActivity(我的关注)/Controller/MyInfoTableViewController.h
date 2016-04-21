//
//  MyInfoTableViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *customView;
- (void)urlRequestForVIP;
- (void)navigationEditButtonClick:(UIButton *)sender;
@end
