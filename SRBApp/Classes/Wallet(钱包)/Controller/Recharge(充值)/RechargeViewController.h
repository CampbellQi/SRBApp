//
//  RechargeViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

typedef void (^BackBlock) (void);
@interface RechargeViewController : ZZViewController<UITextFieldDelegate>
{
    MBProgressHUD * HUD;
}

@property (nonatomic, copy)BackBlock backBlock;
@end
