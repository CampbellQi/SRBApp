//
//  GoodFriendViewController.h
//  SRBApp
//
//  Created by yujie on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewController.h"
#import "MarkOrCommentsCell.h"
#import "MarkModel.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "DetailActivityViewController.h"
#import "AppDelegate.h"
#import "ZZNavigationController.h"
#import "WQOneToSixPhotosView.h"

@interface GoodFriendViewController : ZZTableViewController<WQOneToSixPhotosViewViewDelegate>
{
    NSMutableArray * dataArray;
}
@property (nonatomic, strong) NSString *idNumber;

- (void)urlRequestPost;
- (void)footerRefresh;
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
