//
//  PersonalSignSettingController.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/26.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface PersonalSignSettingController : SRBBaseViewController
@property (weak, nonatomic) IBOutlet UITextView *signTV;
@property (nonatomic, strong)NSDictionary *soureUserInfoDict;
@property (weak, nonatomic) IBOutlet UILabel *wordsCountLbl;

@end
