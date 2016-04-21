//
//  PersonalSkinSettingViewController.h
//  SRBApp
//  皮肤设置
//  Created by fengwanqi on 16/1/25.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface PersonalSkinSettingController : SRBBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(id)initWithSkin;
-(id)initWithStature;
@end
