//
//  MyChatListViewController.h
//  SRBApp
//
//  Created by lizhen on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RCChatListViewController.h"
#import "AppDelegate.h"
@class FriendsViewController;


@interface MyChatListViewController : RCChatListViewController
{
    BOOL isBack;
}
@property (nonatomic, strong) FriendsViewController *friendFragmentVC;
- (void)leftBarButtonItemPressed:(UIBarButtonItem *)sender;
@end
