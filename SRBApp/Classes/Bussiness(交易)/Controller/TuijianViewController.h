//
//  TuijianViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/3/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyCell.h"
#import "SellCell.h"
#import "BussinessModel.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "DetailActivityViewController.h"
#import "AppDelegate.h"

@interface TuijianViewController : ZZViewController
{
    NSMutableArray * dataArray;
    NoDataView * noData;
}
@property (nonatomic,strong)NSString * saleAndBuyType;
@property (nonatomic,strong)NSString * categoryID;
@property (nonatomic, strong)NSString * idNumber;
@property (nonatomic, strong)UITableView * tableView;
- (void)urlRequestPost;
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)headerRefresh;
- (void)footerRefresh;

@end
