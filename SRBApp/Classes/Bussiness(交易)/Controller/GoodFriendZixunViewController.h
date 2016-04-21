//
//  GoodFriendZixunViewController.h
//  SRBApp
//
//  Created by zxk on 15/4/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface GoodFriendZixunViewController : ZZViewController
@property (nonatomic, strong) NSString *idNumber;
@property (strong,nonatomic)UITableView * tableView;
- (void)urlRequestPost;
@end
