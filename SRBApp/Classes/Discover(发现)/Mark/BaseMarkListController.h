//
//  BaseMarkListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/6.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZViewController.h"

@interface BaseMarkListController : ZZViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary *sortedDataDict;
@property (nonatomic,strong) NSArray *allKeys;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) BOOL hideSectionHeader;

@property (nonatomic, strong)NoDataView *noDataView;
@end
