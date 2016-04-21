//
//  MyPublishGiveYouTableViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/3/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

@interface MyPublishGiveYouTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIAlertView * alertViewdown;
    int wantDown;
}
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic, strong)DetailModel * model;
@property (nonatomic, strong)NSString * dealType;
@property (nonatomic ,strong)NoDataView * nodataView;

//@property (nonatomic, strong) NSString *title;
//@property (nonatomic, strong) NSString *content;
//@property (nonatomic, strong) NSString *imageUrl;
//@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *idNumber;
//@property (nonatomic, strong) NSString *account;
//@property (nonatomic, strong) NSString *nickname;
//@property (nonatomic, strong) NSString *avatar;



- (void)urlRequestPost;
//- (void)reload;
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic;
- (void)headerRefresh;
- (void)footerRefresh;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath ;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)down:(id)sender;
@end
