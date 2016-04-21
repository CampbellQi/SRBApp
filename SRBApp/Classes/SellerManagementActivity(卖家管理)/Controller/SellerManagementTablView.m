//
//  SellerManagementTablView.m
//  SRBApp
//
//  Created by zxk on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SellerManagementTablView.h"
#import "MJRefresh.h"
#import "SellerManagementModel.h"
#import "ZZGoPayBtn.h"
#import "SellerManagementCell.h"
#import "SellerOrderDetailViewController.h"
#import "KxMenu.h"
#import "MoreOrderViewController.h"
#import "ZZOrderCustomBtn.h"

static int page = 0;    //起始条数
static int count = NumOfItemsForZuji;   //请求数量

@interface SellerManagementTablView ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@end

@implementation SellerManagementTablView
{
    UITableView * tableview;
    NSMutableArray * dataArray; //数据数组
    UIView * xialaBgView;  //下拉
    ZZOrderCustomBtn * allBtn;          //全部
    ZZOrderCustomBtn * waitPaybtn;      //待付款
    ZZOrderCustomBtn * waitSendBtn;     //待发货
    ZZOrderCustomBtn * waitRebtn;       //待收货
    ZZOrderCustomBtn * waitSayBtn;      //待退款
    ZZOrderCustomBtn * finishBtn;       //完成
    NoDataView * noData;    //无数据时显示
    MBProgressHUD * hud;
    NSIndexPath * tempIndex;    //临时的indexpath
    UIActivityIndicatorView * orderActivity;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"卖家订单";
    dataArray = [NSMutableArray array];
    [self customInit];
}

#pragma mark - 返回
- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.sellerManagementVC urlRequest];
}
#pragma mark - 控件初始化
- (void)customInit
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

    
//    UIButton * sandianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    sandianBtn.frame = CGRectMake(0, 0, 40, 35);
//    [sandianBtn setBackgroundImage:[UIImage imageNamed:@"sandian"] forState:UIControlStateNormal];
//    [sandianBtn addTarget:self action:@selector(otherOrder:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sandianBtn];
    
    //创建顶部view
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59)];
    topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    topBGView.layer.shadowOffset = CGSizeMake(4, 3);
    topBGView.layer.shadowOpacity = 0.8;
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    

    NSArray * tempArr = @[@"  全部",@"待付款",@"待发货",@"待收货",@"待退款",@" 完成"];
    
    //1.全部
    allBtn = [ZZOrderCustomBtn buttonWithType:UIButtonTypeCustom];
    [allBtn setTitle:tempArr[0] forState:UIControlStateNormal];
    [allBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dd_b_1.png"]] forState:UIControlStateNormal];
    [allBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dd_r_1.png"]] forState:UIControlStateSelected];
    allBtn.tag = 1005;
    [allBtn addTarget:self action:@selector(allBtn:) forControlEvents:UIControlEventTouchUpInside];
    allBtn.frame = CGRectMake(0, 5, SCREEN_WIDTH/5, 43);
    [topBGView addSubview:allBtn];
    
    //2.待付款
    waitPaybtn = [ZZOrderCustomBtn buttonWithType:UIButtonTypeCustom];
    [waitPaybtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dd_b_2.png"]] forState:UIControlStateNormal];
    [waitPaybtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dd_r_2.png"]] forState:UIControlStateSelected];
    [waitPaybtn setTitle:tempArr[1] forState:UIControlStateNormal];
    waitPaybtn.tag = 1000 + 0;
    [waitPaybtn addTarget:self action:@selector(waitPaybtn:) forControlEvents:UIControlEventTouchUpInside];
    waitPaybtn.frame = CGRectMake(allBtn.frame.size.width + allBtn.frame.origin.x, 5, SCREEN_WIDTH/5, 43);
    [topBGView addSubview:waitPaybtn];
    
    //3.待发货
    waitSendBtn = [ZZOrderCustomBtn buttonWithType:UIButtonTypeCustom];
    [waitSendBtn setImage:[UIImage imageNamed:@"dd_b_3.png"] forState:UIControlStateNormal];
    [waitSendBtn setImage:[UIImage imageNamed:@"dd_r_3.png"] forState:UIControlStateSelected];
    [waitSendBtn setTitle:tempArr[2] forState:UIControlStateNormal];
    waitSendBtn.tag = 1000 + 1;
    [waitSendBtn addTarget:self action:@selector(waitSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    waitSendBtn.frame = CGRectMake(waitPaybtn.frame.size.width + waitPaybtn.frame.origin.x, 5, SCREEN_WIDTH/5, 43);
    [topBGView addSubview:waitSendBtn];
    
    //4.待收货
    waitRebtn = [ZZOrderCustomBtn buttonWithType:UIButtonTypeCustom];
    [waitRebtn setImage:[UIImage imageNamed:@"dd_b_4.png"] forState:UIControlStateNormal];
    [waitRebtn setImage:[UIImage imageNamed:@"dd_r_4.png"] forState:UIControlStateSelected];
    [waitRebtn setTitle:tempArr[3] forState:UIControlStateNormal];
    waitRebtn.tag = 1000 + 2;
    [waitRebtn addTarget:self action:@selector(waitRebtn:) forControlEvents:UIControlEventTouchUpInside];
    waitRebtn.frame = CGRectMake(waitSendBtn.frame.size.width + waitSendBtn.frame.origin.x, 5, SCREEN_WIDTH/5, 43);
    [topBGView addSubview:waitRebtn];
    
    //5.待退款
    waitSayBtn = [ZZOrderCustomBtn buttonWithType:UIButtonTypeCustom];
    [waitSayBtn setImage:[UIImage imageNamed:@"dd_b_6.png"] forState:UIControlStateNormal];
    [waitSayBtn setImage:[UIImage imageNamed:@"dd_r_6.png"] forState:UIControlStateSelected];
    [waitSayBtn setTitle:tempArr[4] forState:UIControlStateNormal];
    waitSayBtn.tag = 1000 + 5;
    [waitSayBtn addTarget:self action:@selector(waitSayBtn:) forControlEvents:UIControlEventTouchUpInside];
    waitSayBtn.frame = CGRectMake(waitRebtn.frame.size.width + waitRebtn.frame.origin.x, 5, SCREEN_WIDTH/5, 43);
    [topBGView addSubview:waitSayBtn];
    
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 59) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.rowHeight = 139;
    tableview.tableFooterView = [[UIView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableview];
    [self.view addSubview:topBGView];
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    
    
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60)];
    noData.hidden = YES;
    noData.imageV.image = [UIImage imageNamed:@"noOrder"];
    noData.imageV.frame = CGRectMake((SCREEN_WIDTH - 65)/2, 75, 65, 75);
    noData.label.frame = CGRectMake(0, CGRectGetMaxY(noData.imageV.frame) + 10, SCREEN_WIDTH, 16);
    noData.label.textAlignment = NSTextAlignmentCenter;
    noData.label.text = @"您还没有相关订单";
    [tableview addSubview:noData];
    
    if ([self.orderType isEqualToString:@"6"]) {
        allBtn.selected = YES;
    }else if ([self.orderType isEqualToString:@"0"]){
        waitPaybtn.selected = YES;
    }else if ([self.orderType isEqualToString:@"1"]){
        waitSendBtn.selected = YES;
    }else if ([self.orderType isEqualToString:@"2"]){
        waitRebtn.selected = YES;
    }else if ([self.orderType isEqualToString:@"5"]){
        waitSayBtn.selected = YES;
    }else if ([self.orderType isEqualToString:@"4"]){
        finishBtn.selected = YES;
    }else if (self.orderType == nil || [self.orderType isEqualToString:@""]){
        allBtn.selected = YES;
    }
    
    orderActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    orderActivity.center = self.view.center;
    [orderActivity setHidesWhenStopped:YES];
    [self.view addSubview:orderActivity];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //友盟统计
    [MobClick beginLogPageView:@"sellerOrder"];
    [self urlRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"sellerOrder"];
}
//#pragma mark - 其他订单
//- (void)otherOrder:(UIButton *)sender
//{
//    MoreOrderViewController * moreOrderVC = [[MoreOrderViewController alloc]init];
//    moreOrderVC.array = ORDER_TYPE_ARR;
//    moreOrderVC.imgArr = @[@"dd_r_1",@"daifukuan",@"daifahuo",@"daishouhuo",@"daipingjia",@"wancheng"];
//    [[[UIApplication sharedApplication].windows lastObject]addSubview:moreOrderVC.view];
//    [self addChildViewController:moreOrderVC];
//    
//}

- (void)dealloc
{
    count = NumOfItemsForZuji;
    page = 0;
}

#pragma mark - 网络请求
- (void)urlRequest
{
    if ([self.orderType isEqualToString:@"6"] || self.orderType == nil) {
        self.orderType = @"";
    }
    NSDictionary * dic = [self parametersForDic:@"sellerGetOrderRecords" parameters:@{ACCOUNT_PASSWORD,@"status":self.orderType,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    //请求过程按钮禁止点击
    allBtn.userInteractionEnabled = NO;
    waitPaybtn.userInteractionEnabled = NO;
    waitRebtn.userInteractionEnabled = NO;
    waitSayBtn.userInteractionEnabled = NO;
    waitSendBtn.userInteractionEnabled = NO;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            //对dataArray添加数据
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                SellerManagementModel * orderModel = [[SellerManagementModel alloc]init];
                [orderModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:orderModel];
            }
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        allBtn.userInteractionEnabled = YES;
        waitPaybtn.userInteractionEnabled = YES;
        waitRebtn.userInteractionEnabled = YES;
        waitSayBtn.userInteractionEnabled = YES;
        waitSendBtn.userInteractionEnabled = YES;
        //page = 0;
        [hud removeFromSuperview];
        [orderActivity stopAnimating];
        [tableview reloadData];
        [tableview headerEndRefreshing];
    } andFailureBlock:^{
        allBtn.userInteractionEnabled = YES;
        waitPaybtn.userInteractionEnabled = YES;
        waitRebtn.userInteractionEnabled = YES;
        waitSayBtn.userInteractionEnabled = YES;
        waitSendBtn.userInteractionEnabled = YES;
        noData.hidden = NO;
        [hud removeFromSuperview];
        [orderActivity stopAnimating];
        [dataArray removeAllObjects];
        [tableview reloadData];
        [tableview headerEndRefreshing];
    }];
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequest];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
//    int tempCount = 0;
//    if (dataArray.count < 10 || dataArray.count % 10 != 0) {
//        tempCount = (int)dataArray.count;
//    }else{
//        tempCount = NumOfItemsForZuji;
//    }
    page += NumOfItemsForZuji;
    count += NumOfItemsForZuji;
    if ([self.orderType isEqualToString:@"6"] || self.orderType == nil) {
        self.orderType = @"";
    }
    NSDictionary * dic = [self parametersForDic:@"sellerGetOrderRecords" parameters:@{ACCOUNT_PASSWORD,@"status":self.orderType,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                SellerManagementModel * orderModel = [[SellerManagementModel alloc]init];
                [orderModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:orderModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    count -= NumOfItemsForZuji;
                    break;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableview reloadData];
            });
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
            count -= NumOfItemsForZuji;
            [tableview reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            page -= NumOfItemsForZuji;
            count -= NumOfItemsForZuji;
        }
        [tableview footerEndRefreshing];
    } andFailureBlock:^{
        count -= NumOfItemsForZuji;
        page -= NumOfItemsForZuji;
        [tableview footerEndRefreshing];
    }];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建一个cell
    SellerManagementCell * cell = [SellerManagementCell sellerManagementCellWithTableView:tableView];
    //取出对应模型
    SellerManagementModel * sellerModel = dataArray[indexPath.row];
    [cell.operationBtn addTarget:self action:@selector(operationBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.operationBtn.indexpath = indexPath;
    cell.sellerModel = sellerModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SellerOrderDetailViewController * sellerDetailVC = [[SellerOrderDetailViewController alloc]init];
    SellerManagementModel * orderModel = dataArray[indexPath.row];
    sellerDetailVC.orderID = orderModel.orderId;
    [self.navigationController pushViewController:sellerDetailVC animated:YES];
}

- (void)refreshTable
{
    [dataArray removeAllObjects];
    [tableview reloadData];
    [orderActivity startAnimating];
    [self urlRequest];
}

#pragma mark - 切换订单状态
/**
 *  @brief  全部
 *  @param sender
 */
- (void)allBtn:(ZZOrderCustomBtn *)sender
{
    waitPaybtn.selected = NO;
    waitSendBtn.selected = NO;
    waitRebtn.selected = NO;
    waitSayBtn.selected = NO;
    finishBtn.selected = NO;
    [sender setSelected:YES];
    self.orderType = @"";
    [self refreshTable];
}
/**
 *  @brief  待付款
 *  @param sender
 */
- (void)waitPaybtn:(ZZOrderCustomBtn *)sender
{
    allBtn.selected = NO;
    waitSayBtn.selected = NO;
    waitRebtn.selected = NO;
    waitSendBtn.selected = NO;
    finishBtn.selected = NO;
    [sender setSelected:YES];
    self.orderType = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
    [self refreshTable];
}
/**
 *  @brief  待发货
 *  @param sender
 */
- (void)waitSendBtn:(ZZOrderCustomBtn *)sender
{
    waitPaybtn.selected = NO;
    allBtn.selected = NO;
    waitRebtn.selected = NO;
    waitSayBtn.selected = NO;
    finishBtn.selected = NO;
    [sender setSelected:YES];
    self.orderType = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
    [self refreshTable];
}
/**
 *  @brief  待收货
 *  @param sender
 */
- (void)waitRebtn:(ZZOrderCustomBtn *)sender
{
    waitPaybtn.selected = NO;
    waitSendBtn.selected = NO;
    allBtn.selected = NO;
    waitSayBtn.selected = NO;
    finishBtn.selected = NO;
    [sender setSelected:YES];
    self.orderType = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
    [self refreshTable];
}
/**
 *  @brief  待评价
 *  @param sender
 */
- (void)waitSayBtn:(ZZOrderCustomBtn *)sender
{
    waitPaybtn.selected = NO;
    waitSendBtn.selected = NO;
    waitRebtn.selected = NO;
    allBtn.selected = NO;
    finishBtn.selected = NO;
    [sender setSelected:YES];
    self.orderType = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
    [self refreshTable];
}

/**
 *  @brief  完成
 *  @param sender
 */
- (void)finishBtn:(ZZOrderCustomBtn *)sender
{
    waitPaybtn.selected = NO;
    waitSendBtn.selected = NO;
    waitRebtn.selected = NO;
    allBtn.selected = NO;
    waitSayBtn.selected = NO;
    [sender setSelected:YES];
    self.orderType = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
    [self refreshTable];

}

#pragma mark - uialertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //删除订单
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"处理中,请稍后";
        hud.dimBackground = YES;
        [hud show:YES];
        SellerManagementModel * sellerModel = dataArray[tempIndex.row];
        NSDictionary * dic = [self parametersForDic:@"sellerSetOrderDelete" parameters:@{ACCOUNT_PASSWORD,@"orderId":sellerModel.orderId}];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [dataArray removeObjectAtIndex:tempIndex.row];
//                [tableview deleteRowsAtIndexPaths:@[tempIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self urlRequest];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                [hud removeFromSuperview];
            }
        } andFailureBlock:^{
            [hud removeFromSuperview];
        }];
    }
}

- (void)operationBtn:(ZZGoPayBtn *)sender
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除该订单?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    tempIndex = sender.indexpath;
    alert.delegate = self;
    [alert show];
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
