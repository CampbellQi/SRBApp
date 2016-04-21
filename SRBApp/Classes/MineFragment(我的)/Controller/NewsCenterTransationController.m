//
//  NewsCenterTransationController.m
//  SRBApp
//  消息中心-交易
//  Created by fengwanqi on 16/1/26.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "NewsCenterTransationController.h"
#import "NewsCenterTransationCell.h"
#import "CommonView.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "WQAlertView.h"
#import "HandleNewsCenter.h"
#import "NoDataView.h"

static int page,count;
@interface NewsCenterTransationController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
    NewsCenterTransationCell *_propertyCell;
    NSMutableArray *_dataArray;
    NoDataView * _noDataView;
    UIButton *_clearBtn;
}
@end

@implementation NewsCenterTransationController
- (void)viewWillAppear:(BOOL)animated
{
    //[self urlRequestPost];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = [NSMutableArray new];
    self.title = @"交易";
    UIBarButtonItem *clearBBI = [CommonView rightWithBgBarButtonItemTitle:@"清 空" Target:self Action:@selector(clearBtnClicked)];
    _clearBtn = clearBBI.customView;
    _clearBtn.hidden = YES;
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    self.navigationItem.rightBarButtonItem = clearBBI;
    
    //无数据图
    _noDataView = [[NoDataView alloc]initWithFrame:self.tableView.bounds];
    _noDataView.width = SCREEN_WIDTH;
    _noDataView.center = CGPointMake(SCREEN_WIDTH/2, self.tableView.height/2);
    _noDataView.hidden = YES;
    [self.tableView addSubview:_noDataView];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    UINib *nib = [UINib nibWithNibName:@"NewsCenterTransationCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"NewsCenterTransationCell"];
    _propertyCell = [self.tableView dequeueReusableCellWithIdentifier:@"NewsCenterTransationCell"];
    
    [self.tableView headerBeginRefreshing];
}
#pragma mark- 事件
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clearBtnClicked {
    [[WQAlertView alloc] showAlertWithCurrentViewController:self Title:@"提示" Message:@"确定清空?" ConfirmName:@"确定" CancelName:@"取消" ConfirmBlock:^{
        [self clearMessageRequest];
    } CancelBlock:nil];
}
//清空交易信息
-(void)clearMessageRequest {
    
        NSDictionary * dic = [self parametersForDic:@"accountClearSystemMessageBox" parameters:@{ACCOUNT_PASSWORD, @"partition":self.messageType}];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [_dataArray removeAllObjects];
                [self.tableView reloadData];
                _noDataView.hidden = NO;
                self.navigationItem.rightBarButtonItem = nil;
            }else{
                if (![result isEqualToString:@"4"]) {
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
            }
        } andFailureBlock:^{
            
        }];
    }

#pragma mark- tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCenterTransationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCenterTransationCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.sourceDict = dict;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight(_propertyCell.frame);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _dataArray[indexPath.row];
    [HandleNewsCenter handleMsgCenterModule:dict[@"module"] Value:dict[@"value"] NavigationController:self.navigationController];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
        [_dataArray removeObject:dict];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteRequest:dict];
        
    }
}
#pragma mark- 网络请求
-(void)headerRefresh {
    [self loadNewDataListRequest];
}
-(void)footerRefresh {
    [self loadMoreDataListRequest];
}
//最新话题列表
-(void)loadNewDataListRequest {
    page = 0;
    NSDictionary * param = [self parametersForDic:@"accountGetSystemMessageBox" parameters:@{ACCOUNT_PASSWORD, @"partition": self.messageType, @"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [_dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            _clearBtn.hidden = NO;
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            [_dataArray addObjectsFromArray:temparrs];
            _noDataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            _noDataView.hidden = NO;
            self.navigationItem.rightBarButtonItem = nil;
        }else{
            _noDataView.hidden = NO;
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
        _noDataView.hidden = NO;
        self.navigationItem.rightBarButtonItem = nil;
    }];
}
//更多话题列表
- (void)loadMoreDataListRequest
{
    page += NumOfItemsForZuji;
    count += NumOfItemsForZuji;
    NSDictionary * param = [self parametersForDic:@"accountGetSystemMessageBox" parameters:@{ACCOUNT_PASSWORD, @"partition": self.messageType, @"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                [_dataArray addObject:tempdic];
                if (_dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [_dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    count -= NumOfItemsForZuji;
                    break;
                }
            }
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
            count -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            count -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        count -= NumOfItemsForZuji;
        [self.tableView footerEndRefreshing];
    }];
}
//删除消息
-(void)deleteRequest:(NSDictionary *)paramDict{
    NSDictionary * dic = [self parametersForDic:@"accountDeleteNewMessageBox" parameters:@{ACCOUNT_PASSWORD,@"id":paramDict[@"id"]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (_dataArray.count == 0) {
                _noDataView.hidden = NO;
            }else{
                _noDataView.hidden = YES;
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
