//
//  OptionViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionView.h"
#import "ZZViewController.h"
#import "AMBlurView.h"
#import "ShoppingViewController.h"
#import "BussinessViewController.h"
//#import "FriendFragmentViewController.h"
#import "AppDelegate.h"
#import "BuyViewController.h"
#import "SaleViewController.h"
#import "WantAssureViewController.h"

@interface OptionViewController : ZZViewController< UITableViewDelegate, UIAlertViewDelegate,UITableViewDataSource>
{
    MBProgressHUD * HUD;
}
@property (nonatomic, retain)OptionView * optionView;
@property (nonatomic, strong) NSString *userqrcode;//二维码

@end
