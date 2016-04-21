//
//  BaseTopicController.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "MarkTopicListController.h"
#import "PersonalViewController.h"
#import "LayoutFrame.h"
#import "TopicDetailListController.h"
#import "MJRefresh.h"

static int page = 0;
static int count = NumOfItemsForZuji;

@interface BaseTopicController : ZZViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)loadNewDataListRequest;
-(void)loadMoreDataListRequest;

@property (nonatomic, strong)NSMutableArray *dataArray;
@end

