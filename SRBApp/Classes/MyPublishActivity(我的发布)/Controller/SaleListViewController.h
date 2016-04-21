//
//  SaleListViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
 typedef void(^MyBlock1)(id result1, id result2);
@interface SaleListViewController : ZZViewController<UITableViewDelegate, UITableViewDataSource>
{
    MBProgressHUD * HUD;
}
@property (nonatomic, strong)NSString * theSign;
@property (nonatomic ,copy)MyBlock1 block;

- (void)sendMessage:(MyBlock1)jgx;
@end
