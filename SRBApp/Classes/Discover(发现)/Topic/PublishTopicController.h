//
//  PublishTopicController.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"
#import "FMMoveTableView.h"
#import "FMMoveTableView.h"

@interface PublishTopicController : SRBBaseViewController
@property (weak, nonatomic) IBOutlet FMMoveTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@end
