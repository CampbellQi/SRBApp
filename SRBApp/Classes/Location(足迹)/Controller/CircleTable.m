//
//  CircleTable.m
//  SRBApp
//
//  Created by zxk on 15/1/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CircleTable.h"
#import "FindLocationViewController.h"
#import "ZZAlertView.h"

static int page = 0;
static int count = NumOfItemsForZuji;
@interface CircleTable ()
@property (nonatomic,weak)ZZAlertView * alertView;
@end

@implementation CircleTable

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableview.delaysContentTouches = NO;
    [self noDataView];
}



- (void)seeSomething
{
    [self.alertView dismiss];
    FindLocationViewController * findLocationVC = [[FindLocationViewController alloc]init];
    [self.navigationController pushViewController:findLocationVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"positionCircle"];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"positionCircle"];
}
- (void)hidden
{
    NSArray * temparr = [self.tableview visibleCells];
    for (LocationCell * tempCell in temparr) {
        tempCell.descriptionLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic;
    
    dic = [self parametersForDic:@"getDynamicLocationByCircle" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tableview;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                locationModel.zanCount = locationModel.likeCount;
                [dataArray addObject:locationModel];
            }
            self.listNoDataView.hidden = YES;
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            self.listNoDataView.hidden = NO;
            noData.hidden = YES;
            toTopBtn.hidden = YES;
//            //提示框
//            ZZAlertView * alertView = [ZZAlertView zzAlertView];
//            [alertView setAlertWord:@"一条足迹消息都没有耶"];
//            self.alertView = alertView;
//            [alertView setSureBtnEvent:self action:@selector(seeSomething)];
//            [alertView showAlert];
        }else{
            self.listNoDataView.hidden = YES;
            noData.hidden = NO;
            toTopBtn.hidden = YES;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView reloadData];
        [huds removeFromSuperview];
        page = 0;
        [temTableView headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        [huds removeFromSuperview];
        toTopBtn.hidden = YES;
        [temTableView headerEndRefreshing];
        [dataArray removeAllObjects];
        [temTableView reloadData];
        self.listNoDataView.hidden = YES;
        noData.hidden = NO;
    }];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    Singleton * singleton = [Singleton sharedInstance];
//    singleton.isShow = NO;
//    if (buttonIndex == 1) {
//        [self presentViewController:self.nav animated:YES completion:nil];
//    }
//}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary * dic;
    dic = [self parametersForDic:@"getDynamicLocationByCircle"
                      parameters:@{ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    
    __block UITableView *temTableView = self.tableview;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                locationModel.zanCount = locationModel.likeCount;
                [dataArray addObject:locationModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            self.listNoDataView.hidden = YES;
            noData.hidden = YES;
            [temTableView reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [temTableView footerEndRefreshing];
    }];
}
@end
