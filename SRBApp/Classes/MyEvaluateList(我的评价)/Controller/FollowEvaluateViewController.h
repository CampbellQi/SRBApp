//
//  FollowEvaluateViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/5/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface FollowEvaluateViewController : ZZViewController<UIActionSheetDelegate>
{
    MBProgressHUD * HUD;
}
@property (nonatomic, strong)NSString * orderID;
@property (nonatomic, strong)NSString * itemID;
@end
