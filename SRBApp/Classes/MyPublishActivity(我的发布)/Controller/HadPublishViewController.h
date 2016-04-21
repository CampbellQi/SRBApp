//
//  AlreadyPublishViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/9.
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
#import "HadPublishCell.h"
#import "WaitPublishCell.h"
#import "NoDataView.h"
#import "HadPublishModel.h"
#import "WaitPublishModel.h"
#import "NotPublishModel.h"
#import "WaitPublishCell.h"
#import "NotPublishModel.h"
#import "RealPosition.h"
#import "EndCell.h"
#import "ModifGoodsInfoViewController.h"

@interface HadPublishViewController : UITableViewController
{
    NSMutableArray * dataArray;
    UIAlertView * alertViewdown;
    int wantDown;
    PublishButton * publishibutton;
    
}
@property (nonatomic, strong)NSString * dealType;
- (void)urlRequestPost;
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic;
- (void)headerRefresh;
- (void)footerRefresh;
-  (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath ;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)down:(id)sender;
@end
