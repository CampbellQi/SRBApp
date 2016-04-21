//
//  ZZMyOrderViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZMyOrderViewController.h"
#import "AppDelegate.h"

static int page = 0;
static int count = NumOfItemsForZuji;

@interface ZZMyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation ZZMyOrderViewController
{
    NSIndexPath * tempIndex;        //临时indexpath
    BOOL isBack;                    //是否返回上一级
    MBProgressHUD * hud;
    UIActivityIndicatorView * activity;
    UIActivityIndicatorView * orderActivity;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArr = [NSMutableArray array];
        self.dicArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isBack = NO;
    self.title = @"买家订单";
    //初始化控件
    [self customInit];
    
    NSLog(@"%@",USER_CONFIG_PATH);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"buyerOrder"];
    [self urlRequestPost];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"buyerOrder"];
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}

#pragma mark - 返回
- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 网络请求
- (void)urlRequestPost
{
    if ([_status isEqualToString:@""] || _status == nil || _status.length == 0 || [_status isEqualToString:@"6"]) {
        _status = @"";
    }
    NSDictionary * dic = [self parametersForDic:@"accountGetOrderRecords" parameters:@{ACCOUNT_PASSWORD,@"status":_status,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    allBtn.userInteractionEnabled = NO;
    waitPaybtn.userInteractionEnabled = NO;
    waitRebtn.userInteractionEnabled = NO;
    waitSayBtn.userInteractionEnabled = NO;
    waitSendBtn.userInteractionEnabled = NO;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [_dataArr removeAllObjects];
        [_dicArr removeAllObjects];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            self.dicArr = [NSMutableArray arrayWithArray:[[dic objectForKey:@"data"] objectForKey:@"list"]];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                ZZOrderModel * orderModel = [[ZZOrderModel alloc]init];
                [orderModel setValuesForKeysWithDictionary:tempdic];
                [_dataArr addObject:orderModel];
            }
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [tableview reloadData];

        allBtn.userInteractionEnabled = YES;
        waitPaybtn.userInteractionEnabled = YES;
        waitRebtn.userInteractionEnabled = YES;
        waitSayBtn.userInteractionEnabled = YES;
        waitSendBtn.userInteractionEnabled = YES;
        //page = 0;
        [hud removeFromSuperview];
        [orderActivity stopAnimating];
        [tableview headerEndRefreshing];
    } andFailureBlock:^{
        allBtn.userInteractionEnabled = YES;
        waitPaybtn.userInteractionEnabled = YES;
        waitRebtn.userInteractionEnabled = YES;
        waitSayBtn.userInteractionEnabled = YES;
        waitSendBtn.userInteractionEnabled = YES;
        //page = 0;
        noData.hidden = NO;
        [hud removeFromSuperview];
        [orderActivity stopAnimating];
        [self.dicArr removeAllObjects];
        [_dataArr removeAllObjects];
        [tableview reloadData];
        [tableview headerEndRefreshing];
    }];
    
}

//- (void)popSwipe:(UIScreenEdgePanGestureRecognizer *)swipe
//{
//    isBack = YES;
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)dealloc
{
    page = 0;
    count = NumOfItemsForZuji;
}

#pragma mark - 初始化控件
- (void)customInit
{
    
//    if (is_IOS_7) {
//        UIScreenEdgePanGestureRecognizer * popSwipe = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(popSwipe:)];
//        popSwipe.delegate = self;
//        [popSwipe setEdges:UIRectEdgeLeft];
//        [self.view addGestureRecognizer:popSwipe];
//    }
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //创建顶部view
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59)];
    topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    topBGView.layer.shadowOffset = CGSizeMake(4, 3);
    topBGView.layer.shadowOpacity = 0.8;
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    
    
    NSArray * tempArr = @[@"  全部",@"待付款",@"待发货",@"待收货",@"待退款"];
    
    //1.全部
    allBtn = [ZZOrderCustomBtn buttonWithType:UIButtonTypeCustom];
    [allBtn setTitle:tempArr[0] forState:UIControlStateNormal];
    [allBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dd_b_1.png"]] forState:UIControlStateNormal];
    [allBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dd_r_1.png"]] forState:UIControlStateSelected];
//    allBtn.selected = YES;

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
    
//    CGPoint allCenter = allBtn.center;
//    allCenter.x = SCREEN_WIDTH/5 - 20;
//    allBtn.center = allCenter;
//    waitPaybtn.center = CGPointMake(SCREEN_WIDTH/5 * 2 - 20, allCenter.y);
//    waitSendBtn.center = CGPointMake(SCREEN_WIDTH/5 * 3 - 20, allCenter.y);
//    waitRebtn.center = CGPointMake(SCREEN_WIDTH/5 * 4 - 20, allCenter.y);
//    waitSayBtn.center = CGPointMake(SCREEN_WIDTH/5 * 5 - 20, allCenter.y);

    
    
    //设置初始status
//    _status = @"";
    //创建tableview
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 59) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.rowHeight = 139;
    tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableview];
    [self.view addSubview:topBGView];
    tableview.backgroundColor = [UIColor clearColor];

    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    
    tableview.delaysContentTouches = NO;
    
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60)];
    noData.hidden = YES;
    noData.imageV.image = [UIImage imageNamed:@"noOrder"];
    noData.imageV.frame = CGRectMake((SCREEN_WIDTH - 65)/2, 75, 65, 75);
    noData.label.frame = CGRectMake(0, CGRectGetMaxY(noData.imageV.frame) + 10, SCREEN_WIDTH, 16);
    noData.label.textAlignment = NSTextAlignmentCenter;
    noData.label.text = @"您还没有相关订单";
    [tableview addSubview:noData];
    
    if ([self.status isEqualToString:@"6"]) {
        allBtn.selected = YES;
    }else if ([self.status isEqualToString:@"0"]){
        waitPaybtn.selected = YES;
    }else if ([self.status isEqualToString:@"1"]){
        waitSendBtn.selected = YES;
    }else if ([self.status isEqualToString:@"2"]){
        waitRebtn.selected = YES;
    }else if ([self.status isEqualToString:@"5"]){
        waitSayBtn.selected = YES;
    }else if (self.status == nil || self.status.length == 0){
        allBtn.selected = YES;
    }
    
    orderActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    orderActivity.center = self.view.center;
    [orderActivity setHidesWhenStopped:YES];
    [self.view addSubview:orderActivity];
    
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = self.view.center;
    [activity setHidesWhenStopped:YES];
    [self.view addSubview:activity];
    
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
    if (_status == nil) {
        _status = @"";
    }
//    int tempCount = NumOfItemsForZuji;
//    if (_dataArr.count < 10) {
//        tempCount = (int)_dataArr.count;
//    }else{
//        tempCount = NumOfItemsForZuji;
//    }
    page += NumOfItemsForZuji;
    count += NumOfItemsForZuji;
    NSDictionary * dic = [self parametersForDic:@"accountGetOrderRecords" parameters:@{ACCOUNT_PASSWORD,@"status":_status,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++){
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                [self.dicArr addObject:tempdic];
                ZZOrderModel * orderModel = [[ZZOrderModel alloc]init];
                [orderModel setValuesForKeysWithDictionary:tempdic];
                [_dataArr addObject:orderModel];
                if (_dataArr.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [self.dicArr removeLastObject];
                    [_dataArr removeLastObject];
                    page -= NumOfItemsForZuji;
                    count -= NumOfItemsForZuji;
                    break;
                }
            }
            noData.hidden = YES;
            [tableview reloadData];
        }else if([result isEqualToString:@"4"]){
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

#pragma mark - tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建一个cell
    ZZOrderCustomCell * cell = [ZZOrderCustomCell settingCellWithTaableView:tableView];
    //2.取出对应的模型
    ZZOrderModel * orderModel = [_dataArr objectAtIndex:indexPath.row];
    [cell.delBtn addTarget:self action:@selector(delBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.goPayBtn addTarget:self action:@selector(goPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.delBtn.indexpath = indexPath;
//    NSDictionary * tempdic = orderModel.goods[0];
//    if (tableview.dragging == NO && tableview.decelerating == NO) {
//        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:[tempdic objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//    }
    cell.goPayBtn.indexpath = indexPath;
    cell.orderModel = orderModel;
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ZZOrderModel * orderModel = [self.dataArr objectAtIndex:indexPath.row];
//    NSDictionary * tempdic = orderModel.goods[0];
//    ZZOrderCustomCell * cells = (ZZOrderCustomCell *)cell;
//    [cells.imageview sd_setImageWithURL:[tempdic objectForKey:@"cover"] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//    
//}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (!decelerate) {
//        [self loadImage];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self loadImage];
//}
//
//- (void)loadImage
//{
//    NSArray * visibleCells = [tableview visibleCells];
//    for (ZZOrderCustomCell * tempCell in visibleCells) {
//        ZZOrderModel * orderModel = [self.dataArr objectAtIndex:tempCell.goPayBtn.indexpath.row];
//        //ZZOrderCustomCell * cell = (ZZOrderCustomCell *)[tableview cellForRowAtIndexPath:indexpath];
//        NSDictionary * tempdic = orderModel.goods[0];
//        if (tempCell.imageview.image == nil) {
//            [tempCell.imageview sd_setImageWithURL:[NSURL URLWithString:[tempdic objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZZOrderDetailViewController * orderDetailVC = [[ZZOrderDetailViewController alloc]init];
    ZZOrderModel * orderModel = _dataArr[indexPath.row];
    orderDetailVC.orderID = orderModel.orderId;
    orderDetailVC.orderVC = self;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - 删除按钮
- (void)delBtn:(ZZOrderCustomBtn *)sender
{
//    GUAAlertView * alerts = [GUAAlertView alertViewWithTitle:@"确定删除该订单?" message:nil buttonTitle:@"确定" buttonTouchedAction:^{
//        
//    } dismissAction:^{
//        
//    }];
//    [alerts show];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除该订单?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    tempIndex = sender.indexpath;
    alert.delegate = self;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"处理中,请稍后";
        hud.dimBackground = YES;
        [hud show:YES];
        ZZOrderModel * orderModel = _dataArr[tempIndex.row];
        NSDictionary * dic = [self parametersForDic:@"accountSetOrderDelete" parameters:@{ACCOUNT_PASSWORD,@"orderId":orderModel.orderId}];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [_dataArr removeObjectAtIndex:tempIndex.row];
                [self.dicArr removeObjectAtIndex:tempIndex.row];
                //count -= 1;
//                [tableview deleteRowsAtIndexPaths:@[tempIndex] withRowAnimation:NO];
                [self urlRequestPost];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                [hud removeFromSuperview];
            }
        } andFailureBlock:^{
            [hud removeFromSuperview];
        }];
    }
}

#pragma mark - 付款按钮
- (void)goPayBtn:(ZZGoPayBtn *)sender
{
    ZZOrderModel * orderModel = _dataArr[sender.indexpath.row];
    [self checkOrderWithID:orderModel withBtn:sender];
}

#pragma mark - 验证是否可以支付
- (void)checkOrderWithID:(ZZOrderModel *)orderModel withBtn:(ZZGoPayBtn *)sender
{
    [activity startAnimating];
    NSDictionary * dic = [self parametersForDic:@"accountCheckPayOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":orderModel.orderId}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            ZZGoPayViewController * goPayVC = [[ZZGoPayViewController alloc]init];
            goPayVC.orderID = orderModel.orderId;
            //goPayVC.orderDataDic = self.dicArr[sender.indexpath.row];
            NSArray * goodsArr = [self.dicArr[sender.indexpath.row] objectForKey:@"goods"];
            NSDictionary * goodsDict = goodsArr[0];
            goPayVC.orderTitle = [goodsDict objectForKey:@"title"];
            [self.navigationController pushViewController:goPayVC animated:YES];
        }else{
            if (![result isEqualToString:@"4"]){
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
        [activity stopAnimating];
    } andFailureBlock:^{
        [activity stopAnimating];
    }];
    
}

- (void)refreshTable
{
    [_dataArr removeAllObjects];
    [tableview reloadData];
    [orderActivity startAnimating];
    [self urlRequestPost];
}

#pragma mark - 切换订单状态
- (void)allBtn:(UIButton *)sender
{
    waitPaybtn.selected = NO;
    waitSendBtn.selected = NO;
    waitRebtn.selected = NO;
    waitSayBtn.selected = NO;
    [sender setSelected:YES];
    _status = @"";
    [self refreshTable];
}
- (void)waitPaybtn:(UIButton *)sender
{
    allBtn.selected = NO;
    waitSayBtn.selected = NO;
    waitRebtn.selected = NO;
    waitSendBtn.selected = NO;
    [sender setSelected:YES];
    _status = [NSString stringWithFormat:@"%lu",sender.tag - 1000];
    [self refreshTable];
}
- (void)waitSendBtn:(UIButton *)sender
{
    waitPaybtn.selected = NO;
    allBtn.selected = NO;
    waitRebtn.selected = NO;
    waitSayBtn.selected = NO;
    [sender setSelected:YES];
    _status = [NSString stringWithFormat:@"%lu",sender.tag - 1000];
    [self refreshTable];
}
- (void)waitRebtn:(UIButton *)sender
{
    waitPaybtn.selected = NO;
    waitSendBtn.selected = NO;
    allBtn.selected = NO;
    waitSayBtn.selected = NO;
    [sender setSelected:YES];
    _status = [NSString stringWithFormat:@"%lu",sender.tag - 1000];
    [self refreshTable];
}
- (void)waitSayBtn:(UIButton *)sender
{
    waitPaybtn.selected = NO;
    waitSendBtn.selected = NO;
    waitRebtn.selected = NO;
    allBtn.selected = NO;
    [sender setSelected:YES];
    _status = [NSString stringWithFormat:@"%lu",sender.tag - 1000];
    [self refreshTable];
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
