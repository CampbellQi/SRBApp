//
//  PersonalNicknameSettingController.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/26.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface PersonalNicknameSettingController : SRBBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (nonatomic, strong)NSDictionary *soureUserInfoDict;
@end
