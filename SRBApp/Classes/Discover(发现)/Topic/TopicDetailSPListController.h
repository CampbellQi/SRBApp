//
//  TopicDetailSPListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/10.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"
#import "TopicDetailModel.h"
#import "TPMarkModel.h"

@interface TopicDetailSPListController : SRBBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *ContentView;
@property (nonatomic, strong)TopicDetailModel *topicDetailModel;

@property (nonatomic, strong)TPMarkModel *selectedMarkModel;

@end
