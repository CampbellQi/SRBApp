//
//  NewsCenterViewController.h
//  SRBApp
//
//  Created by zxk on 15/3/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "MineFragmentViewController.h"
@interface NewsCenterViewController : ZZViewController
{
    NSMutableArray * dataArray;     //数据数组
    UITableView * tableview;
    NoDataView * noData;            //无数据时显示
}
@property (nonatomic, strong)NSString *messageType;
@end
