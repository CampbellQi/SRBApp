//
//  NewsCenterViewController.m
//  SRBApp
//
//  Created by zxk on 15/3/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NewsCenterViewController.h"    
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "NewsCenterModel.h"
#include "NewsCenterCell.h"
#import "ZZOrderDetailViewController.h"
#import "SellerOrderDetailViewController.h"
#import "SellerEvaluateListActivityViewController.h"
#import "MyEvaluateListViewController.h"
#import "MyAssureViewController.h"
#import "SubNewFriendApplyViewController.h"
#import "MyFriendsViewController.h"
#import "SecondSubclassDetailViewController.h"
#import "SubViewController.h"
#import "LocationDetailViewController.h"
#import "GuaranteeDetailViewController.h"
#import "MessageCenterToSubClassViewController.h"
#import "SubViewController.h"
#import "SubAddressBookListActivityViewController.h"
#import "ReplaceEmotionTool.h"
#import "HandleNewsCenter.h"

static int page = 0;                    //起始页
static int count = NumOfItems;   //每次请求数量
//typedef enum{
//    sellerorder = 0,
//    buyerorder = 1,
//    userapply = 2,
//    userfriend = 3,
//    postguarantee = 4,
//    userguarantee = 4,
//    sellercomment = 5,
//    buyercomment = 6,
//    userpost = 7,
//    userposition = 8,
//    inviteguarantee = 9,
//    userinfo = 10
//}model;

typedef NS_ENUM(NSInteger, model) {
    sellerorder = 0,
    buyerorder = 1,
    userapply = 2,
    userfriend = 3,
    postguarantee = 4,
    userguarantee = 4,
    sellercomment = 5,
    buyercomment = 6,
    userpost = 7,
    userposition = 8,
    inviteguarantee = 9,
    userinfo = 10
};
@interface NewsCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UIButton * cleanBtn;
@end

@implementation NewsCenterViewController
{
    BOOL isBack;            //是否是返回
    MBProgressHUD * HUD;    //
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [HUD removeFromSuperview];
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"加载中";
//    HUD.dimBackground = YES;
//    [HUD show:YES];
    [self customInit];
    
    [tableview headerBeginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self urlRequestPost];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
        //[self.mineVC postRun];
        page = 0;
        count = 0;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary * dic = [self parametersForDic:@"accountClearSystemMessageBox" parameters:@{ACCOUNT_PASSWORD, @"partition":self.messageType}];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [dataArray removeAllObjects];
                [tableview reloadData];
                noData.hidden = NO;
                self.navigationItem.rightBarButtonItem = nil;
            }else{
                if (![result isEqualToString:@"4"]) {
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
            }
        } andFailureBlock:^{
            
        }];
    }
}

#pragma mark - 清除按钮
- (void)cleanBtn:(UIButton *)sender
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定清空?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)dealloc
{
    count = NumOfItemsForZuji;
}

#pragma mark - 初始化控件
- (void)customInit
{
    dataArray = [NSMutableArray array];
    //返回按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //清除按钮
    UIButton * cleanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cleanBtn.frame = CGRectMake(0, 0, 55, 25);
    cleanBtn.layer.cornerRadius = CGRectGetHeight(cleanBtn.frame) * 0.5;
    cleanBtn.layer.masksToBounds = YES;
    cleanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cleanBtn.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [cleanBtn setTitle:@"清 空" forState:UIControlStateNormal];
    [cleanBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    self.cleanBtn = cleanBtn;
    [cleanBtn addTarget:self action:@selector(cleanBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableview];
    tableview.backgroundColor = [UIColor clearColor];
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    
    
    tableview.delaysContentTouches = NO;
    
    //无数据时展示
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    noData.hidden = YES;
    [tableview addSubview:noData];
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 网络请求
-(void)resetNewsCountRequest {

}
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountGetSystemMessageBox" parameters:@{ACCOUNT_PASSWORD, @"partition":self.messageType ,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",NumOfItems]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [dataArray removeAllObjects];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cleanBtn];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                NewsCenterModel * newsCenterModel = [[NewsCenterModel alloc]init];
                [newsCenterModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:newsCenterModel];
            }
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            self.navigationItem.rightBarButtonItem = nil;
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [tableview reloadData];
        [tableview headerEndRefreshing];
        [HUD removeFromSuperview];
    } andFailureBlock:^{
        noData.hidden = NO;
        [dataArray removeAllObjects];
        [tableview reloadData];
        [tableview headerEndRefreshing];
        [HUD removeFromSuperview];
    }];
    
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        page = 0;
        count = NumOfItems;
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItems;
    count += NumOfItems;
//    if (dataArray.count < 10) {
//        page = (int)dataArray.count;
//        count = count - NumOfItemsForZuji + (int)dataArray.count;
//    }
    NSDictionary * dic = [self parametersForDic:@"accountGetSystemMessageBox" parameters:@{ACCOUNT_PASSWORD, @"partition": self.messageType, @"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItems]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++){
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                NewsCenterModel * newsCenterModel = [[NewsCenterModel alloc]init];
                [newsCenterModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:newsCenterModel];
                //如果已达到最大数据,则移除数组最后一个对象
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    count -= NumOfItemsForZuji;
                    break;
                }
            }
            noData.hidden = YES;
            [tableview reloadData];
        }else if(result == 4){
            page -= NumOfItemsForZuji;
            count -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            count -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [tableview footerEndRefreshing];
    } andFailureBlock:^{
        count -= NumOfItemsForZuji;
        page -= NumOfItemsForZuji;
        [tableview footerEndRefreshing];
    }];
}

-(void)deleteRequet:(NewsCenterModel *)model{
    NSDictionary * dic = [self parametersForDic:@"accountDeleteNewMessageBox" parameters:@{ACCOUNT_PASSWORD,@"id":model.ID}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self urlRequestPost];
            if (dataArray.count == 0) {
                noData.hidden = NO;
            }else{
                noData.hidden = YES;
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        
    }];
}

#pragma mark - tableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCenterModel * newsCenterModel = dataArray[indexPath.row];
    NSAttributedString * attributedString = [ReplaceEmotionTool enumerateStringWithStr:newsCenterModel.content andFont:SIZE_FOR_14];
    
    CGRect tempRect = [attributedString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 65, 4000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
//    CGRect tempRect = [newsCenterModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 - 30 - 5, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
    
    return tempRect.size.height + 39;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建一个cell
    NewsCenterCell * cell = [NewsCenterCell newsCenterCellWithTableView:tableView];
    //2.取出对应的模型
    NewsCenterModel * newsCenterModel = [dataArray objectAtIndex:indexPath.row];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.newsCenterModel = newsCenterModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsCenterModel * newsCenterModel = dataArray[indexPath.row];
    newsCenterModel.isNew = @"0";
    [tableView reloadData];
    [HandleNewsCenter handleMsgCenterModule:newsCenterModel.module Value:newsCenterModel.value NavigationController:self.navigationController];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPat
//{
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NewsCenterModel *model = [dataArray objectAtIndex:indexPath.row];
        [dataArray removeObject:model];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteRequet:model];
        
    }
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
