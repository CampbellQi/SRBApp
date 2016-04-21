//
//  ShopRelationTableViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/6.
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
@interface ShopRelationTableViewController : UITableViewController
{
    NSMutableArray * dataArray;
    NoDataView * noData;
}
@property (nonatomic,strong)NSString * saleAndBuyType;
@property (nonatomic,strong)NSString * categoryID;
- (void)urlRequestPost;
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)headerRefresh;
- (void)footerRefresh;

@end
