//
//  PersonalAssureViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalAssureViewController.h"
#import "MyAssureThingsCell.h"
#import "MyAssureThingModel.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "SubclassDetailViewController.h"
#import "NoDataView.h"
#import "AppDelegate.h"
static int page = 0;
@interface PersonalAssureViewController ()

{
    
    PublishButton * publishButton;
    int wantDown;
}
@end

@implementation PersonalAssureViewController
{
    NSMutableArray * dataArray;
    NoDataView * imageview;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    imageview = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 39 - 49)];
    imageview.hidden = YES;
    [self.tableView addSubview:imageview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailActivityViewController *detailAVC = [[DetailActivityViewController alloc] init];
    detailAVC.idNumber = [dataArray[indexPath.row] model_id];
    detailAVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailAVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAssureThingsCell * cell = [[MyAssureThingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell.thingImv sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row] cover]]placeholderImage:[UIImage imageNamed:@"zanwu"]];
    cell.thingImv.contentMode = UIViewContentModeScaleAspectFill;
    cell.thingImv.clipsToBounds = YES;
    cell.titleLb.text =[dataArray[indexPath.row] title];
    cell.detailLb.text = [dataArray[indexPath.row] content];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:[dataArray[indexPath.row] updatetime]];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString * str = [dateFormatter stringFromDate:date];
    cell.dateLb.text = str;
    [cell.deleteBtn addTarget:self action:@selector(deleteThing:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn setTag:100 + indexPath.row];
    cell.deleteBtn.indexpath = indexPath;
    if ([ACCOUNT_SELF isEqualToString:self.account]) {
        cell.deleteBtn.hidden = NO;
        cell.deleteBtn.frame  = CGRectMake(SCREEN_WIDTH - 95, cell.thingImv.frame.origin.y + cell.thingImv.frame.size.height - 25, 80, 25);
    }else{
        cell.deleteBtn.hidden = YES;
        
    }
    return cell;
}


- (void)deleteThing:(id)sender
{
    UIAlertView * alertViewdown = [[UIAlertView alloc] initWithTitle:@"是否放弃担保?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertViewdown show];
    
    publishButton = sender;
    wantDown = (int)publishButton.tag;
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString * str = [dataArray[wantDown - 100]model_id];
        [dataArray removeObjectAtIndex:wantDown - 100];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishButton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountDeleteGuaranteePost" parameters:@{ACCOUNT_PASSWORD,@"id":str}];
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
//                [dataArray removeObjectAtIndex:wantDown - 100];
//                [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishButton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                NSLog(@"%d", result);
                NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
                [AutoDismissAlert autoDismissAlert:@"请求失败"];
                imageview.center = self.tableView.center;
            }
        }];
    }
}



#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}
#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"getGuaranteeListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":self.account, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [dataArray removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                MyAssureThingModel * bussinessModel = [[MyAssureThingModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
            }
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            imageview.hidden = YES;
        }else if(result == 4){
            [dataArray removeAllObjects];
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            imageview.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView headerEndRefreshing];
        }
        page = 0;
    }];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary * dic = [self parametersForDic:@"getGuaranteeListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":self.account, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                MyAssureThingModel * bussinessModel = [[MyAssureThingModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
            
        }else if(result == 4){
            page -= NumOfItemsForZuji;
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView footerEndRefreshing];
        }
    }];
}
@end
