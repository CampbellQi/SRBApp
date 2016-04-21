//
//  BaseMarkTopicListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//


#import "ZZViewController.h"
#import "BussinessModel.h"
#import "TopicDetailListController.h"
#import "PersonalViewController.h"
#import "UIScrollView+MJRefresh.h"

@interface BaseMarkTopicListController : ZZViewController<UITableViewDataSource, UITableViewDelegate>
{
    int _page;
    int _count;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

-(void)loadNewDataListRequest;
-(void)loadMoreDataListRequest;
@end
