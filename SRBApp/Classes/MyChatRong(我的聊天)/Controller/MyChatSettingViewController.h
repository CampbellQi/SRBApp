//
//  MyChatSettingViewController.h
//  SRBApp
//
//  Created by lizhen on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RCChatSettingViewController.h"
#import "SubMyChatListViewController.h"
#import "SelectPersonRongViewController.h"
#import "FriendsViewController.h"
#import "AppDelegate.h"
#import "RenameViewController.h"

@interface MyChatSettingViewController : RCChatSettingViewController
@property (nonatomic, strong) NSString *type;
- (void)viewWillAppear:(BOOL)animated;
@end
