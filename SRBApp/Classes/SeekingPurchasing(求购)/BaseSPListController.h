//
//  BaseSPListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/19.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "BussinessModel.h"
#import "BaseSPListCell.h"

@interface BaseSPListController : ZZViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    int _page;
    int _count;
    BaseSPListCell *_propertyCell;
     NoDataView *_noDataView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSString * idNumber;
@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, assign)BOOL hiddenSPBtn;
-(void)loadNewDataListRequest;
-(void)loadMoreDataListRequest;
@end
