//
//  MyAssureGoodsViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewController.h"
#import "MyAssureThingsCell.h"
#import "MyAssureThingModel.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "DetailActivityViewController.h"
#import "NoDataView.h"
#import "AppDelegate.h"
#import "SecondSubclassDetailViewController.h"
#import "GoodsAssureTableViewCell.h"
#import "BussinessModel.h"
@interface MyAssureGoodsViewController : UITableViewController
{
    NSMutableArray * dataArray;
    
    
    PublishButton * publishbutton;
    int wantdown;
}
@property (nonatomic,assign) CGRect rect;
@property (nonatomic,strong)NoDataView * nodataView;

- (void)urlRequestPost;
- (void)footerRefresh;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic;


@end
