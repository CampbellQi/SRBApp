//
//  PersonalBaseSPListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define CELL_HEIGHT 280
#define FILLING_CELL_HEIGHT 260

//页面类型-我的代购
#define HELP_SP_TYPE 1
//页面类型-我的求购
#define SP_TYPE 2

#import "PersonalBaseSPListController.h"
#import "PersonalBaseSPFilingsListCell.h"
#import "PersonalBaseSPListCell.h"
#import "MJRefresh.h"
#import "BussinessModel.h"
#import "DetailActivityViewController.h"
#import "PersonalHelpSpApplyListController.h"
#import "PersonalSpotGoodsGroomCollectionController.h"
#import "NoDataView.h"
#import "OrderDetailController.h"
#import "PublishSPController.h"
#import "ChangeSaleViewController2.h"
#import "OrderImageAddController.h"
#import "WaittingSendViewController.h"
#import "MineEvaluateViewController.h"
#import "LogisticsController.h"
#import "MyChatViewController.h"
#import "RCUserInfo.h"
#import "PersonalViewController.h"
#import "OrderCancelController.h"
#import "AppealController.h"
#import "ChangePriceController.h"
#import "ZZGoPayViewController.h"
#import "RechargeViewController.h"
#import "MyEvaluateListViewController.h"
#import "SellerEvaluateListActivityViewController.h"
#import "ZZGoPayViewController.h"

static int page = 0;
static int count = NumOfItemsForZuji;

@interface PersonalBaseSPListController ()
{
    NSString *_cellID;

    NoDataView *_noDataView;
    
    int _type;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation PersonalBaseSPListController

-(id)init {
    if (self = [super init]) {
        _isFillings = NO;
    }
    return self;
}
-(id)initBySP {
    if (self = [super init]) {
        _type = SP_TYPE;
    }
    return self;
}

-(id)initByHelpSP {
    if (self = [super init]) {
        _type = HELP_SP_TYPE;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_isFillings) {
        _cellID = @"PersonalBaseSPFilingsListCell";
    }else {
        _cellID = @"PersonalBaseSPListCell";
    }
    
    self.dataArray = [NSMutableArray new];
    [self setUpBaseView];
 
    [self.tableView headerBeginRefreshing];
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _noDataView.frame = self.tableView.bounds;
}
#pragma mark- 页面
-(void)setUpBaseView {
    //注册cell
    UINib *nib = [UINib nibWithNibName:_cellID bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:_cellID];
    self.tableView.tableFooterView = [UIView new];
    //self.view.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    //上下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    //无数据图
    _noDataView = [[NoDataView alloc]initWithFrame:self.tableView.bounds];
    _noDataView.width = SCREEN_WIDTH;
    _noDataView.center = CGPointMake(SCREEN_WIDTH/2, self.tableView.height/2);
    _noDataView.hidden = YES;
    [self.tableView addSubview:_noDataView];
    
}
#pragma mark- tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isFillings) {
        PersonalBaseSPFilingsListCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.currentVC = self;
        cell.sourceModel = _dataArray[indexPath.row];
        //代购申请block
        cell.helpSpApplyTapBlock = ^(BussinessModel *model) {
            PersonalHelpSpApplyListController *vc = [[PersonalHelpSpApplyListController alloc] init];
            vc.modelID = model.model_id;
            [self.navigationController pushViewController:vc animated:YES];
        };
        //现货推荐block
        cell.spotGoodsGroomTapBlock = ^(BussinessModel *model) {
            PersonalSpotGoodsGroomCollectionController *vc = [[PersonalSpotGoodsGroomCollectionController alloc] init];
            vc.modelID = model.model_id;
            [self.navigationController pushViewController:vc animated:YES];
        };
        //商品
        cell.goodsTapBlock = ^(BussinessModel *goodsModel) {
            OrderDetailController *vc = [[OrderDetailController alloc] init];
            vc.reloadDataBlock = ^(void) {
                [self reloadData];
            };
            vc.deleteBlock = ^(BussinessModel *deleteModel){
                [self deleteWithBussinessModel:deleteModel];
            };
            vc.orderID = goodsModel.model_id;
            [self.navigationController pushViewController:vc animated:YES];
        };

        return cell;
    }else {
        PersonalBaseSPListCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.currentVC = self;
        cell.sourceModel = _dataArray[indexPath.row];
        //聊天
        cell.chatBlock = ^(BussinessModel *chatModel) {
            NSString *avatar = @"";
            NSString *nickname = @"";
            NSString *account = @"";
            if (![chatModel.account isEqualToString:ACCOUNT_SELF]) {
                avatar = chatModel.avatar;
                nickname = chatModel.nickname;
                account = chatModel.account;
            }else {
                NSDictionary *seller = chatModel.seller;
                avatar = seller[@"avatar"];
                nickname = seller[@"nickname"];
                account = seller[@"account"];
            }
            MyChatViewController * myChatVC = [[MyChatViewController alloc]init];
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = account;
            user.name = nickname;
            user.portraitUri = avatar;
            myChatVC.portraitStyle = RCUserAvatarCycle;
            myChatVC.currentTarget = user.userId;
            myChatVC.currentTargetName = user.name;
            myChatVC.type = @"personal";
            myChatVC.conversationType = ConversationType_PRIVATE;
            myChatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myChatVC animated:YES];
        };
        //个人中心
        cell.avaterIVBlock = ^(NSString *account) {
            PersonalViewController * personVC = [[PersonalViewController alloc]init];
            personVC.account = account;
            personVC.myRun = @"2";
            [self.navigationController pushViewController:personVC animated:YES];
        };
        cell.goodsSuperViewTapBlock = ^(BussinessModel *goodsModel) {
            OrderDetailController *vc = [[OrderDetailController alloc] init];
            vc.reloadDataBlock = ^(void) {
                [self reloadData];
            };
            vc.deleteBlock = ^(BussinessModel *deleteModel){
                [self deleteWithBussinessModel:deleteModel];
            };
            vc.orderID = goodsModel.model_id;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isFillings) {
        return FILLING_CELL_HEIGHT;
    }else {
        return CELL_HEIGHT;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- PersonalOrderOperateButtonDelegate mehod
//删除
-(void)deleteWithBussinessModel:(BussinessModel *)bussinessModel {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataArray indexOfObject:bussinessModel] inSection:0];
    [_dataArray removeObject:bussinessModel];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    if (self.reloadNavTitle) {
        self.reloadNavTitle();
    }
}
//取消求购
-(void)cancelWithBussinessModel:(BussinessModel *)bussinessModel {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataArray indexOfObject:bussinessModel] inSection:0];
    [_dataArray removeObject:bussinessModel];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    if (self.reloadNavTitle) {
        self.reloadNavTitle();
    }
}
//再次求购
-(void)reSPWithBussinessModel:(BussinessModel *)bussinessModel {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
    PublishSPController * vc = sb.instantiateInitialViewController;
    //        vc.theSign = @"2";
    vc.isFromPublish = NO;
    vc.sourceBussinessModel = bussinessModel;
    TPMarkModel *markeModel = [[TPMarkModel alloc] init];
    [markeModel setValuesForKeysWithDictionary:bussinessModel.labels[0]];
    vc.soureMarkModel = markeModel;
    vc.coverImageUrl = bussinessModel.cover;
    [self.navigationController pushViewController:vc animated:YES];
}
//商品报价
-(void)quotePriceWithBussinessModel:(BussinessModel *)bussinessModel {
    ChangeSaleViewController2 *vc = [[ChangeSaleViewController2 alloc] init];
    vc.spOrderID = bussinessModel.model_id;
    vc.title = @"商品报价";
    [self.navigationController pushViewController:vc animated:YES];
}
//查看-商品详情
-(void)scanWithBussinessModel:(BussinessModel *)bussinessModel {
    DetailActivityViewController *vc = [[DetailActivityViewController alloc] init];
    vc.idNumber = bussinessModel.taskDealPostId;
    vc.spOrderID = bussinessModel.model_id;
    [self.navigationController pushViewController:vc animated:YES];
}
//查看-商品详情(不可购买)
-(void)scanCanNotBuyWithBussinessModel:(BussinessModel *)bussinessModel {
    DetailActivityViewController *vc = [[DetailActivityViewController alloc] init];
    vc.idNumber = bussinessModel.taskDealPostId;
    vc.spOrderID = bussinessModel.model_id;
    vc.canBuy = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
//修改商品
-(void)changePriceWithBussinessModel:(BussinessModel *)bussinessModel {
    ChangeSaleViewController2 *vc = [[ChangeSaleViewController2 alloc] init];
    vc.spOrderID = bussinessModel.model_id;
    vc.goodsID = bussinessModel.taskDealPostId;
    vc.title = @"修改商品";
    [self.navigationController pushViewController:vc animated:YES];
}
//采购成功
-(void)purchaiseSuccessWithBussinessModel:(BussinessModel *)bussinessModel {
    OrderImageAddController *vc = [[OrderImageAddController alloc] init];
    vc.spOrderID = bussinessModel.model_id;
    vc.goodsID = bussinessModel.taskDealPostId;
    [self.navigationController pushViewController:vc animated:YES];
}
//发货
-(void)deliveryWithBussinessModel:(BussinessModel *)bussinessModel {
    WaittingSendViewController *vc = [[WaittingSendViewController alloc] init];
    vc.orderId = bussinessModel.taskOrderFormId;
    [self.navigationController pushViewController:vc animated:YES];
}
//我的求购-评价
-(void)commentWithBussinessModel:(BussinessModel *)bussinessModel {
    MineEvaluateViewController *vc = [[MineEvaluateViewController alloc] init];
    vc.orderID = bussinessModel.taskOrderFormId;
    vc.orderType = BUYER_TYPE;
    [self.navigationController pushViewController:vc animated:YES];
}
//我的代购-评价
-(void)hspCommentWithBussinessModel:(BussinessModel *)bussinessModel {
    MineEvaluateViewController *vc = [[MineEvaluateViewController alloc] init];
    vc.orderID = bussinessModel.taskOrderFormId;
    vc.orderType = SELLER_TYPE;
    [self.navigationController pushViewController:vc animated:YES];
}
//查看物流
-(void)viewLogistisWithBussinessModel:(BussinessModel *)bussinessModel {
    LogisticsController *vc = [[LogisticsController alloc] init];
    vc.invoiceName = bussinessModel.invoiceName;
    vc.invoiceNo = bussinessModel.invoiceNo;
    vc.coverUrl = bussinessModel.cover;
    [self.navigationController pushViewController:vc animated:YES];
}
//取消求购-付完押金
-(void)cancelPayedDepositWithBussinessModel:(BussinessModel *)bussinessModel AlertMsg:(NSString *)alertMsg {
    OrderCancelController *vc = [[OrderCancelController alloc] init];
    vc.completedBlock = ^(void){
        [self reloadData];
    };
    vc.spOrderID = bussinessModel.model_id;
    vc.alertMsg = alertMsg;
    vc.type = ORDERCANCEL_SP_TYPE;
    [self.navigationController pushViewController:vc animated:YES];
}
//取消求购-付完款
-(void)cancelPayedPriceWithBussinessModel:(BussinessModel *)bussinessModel AlertMsg:(NSString *)alertMsg {
    OrderCancelController *vc = [[OrderCancelController alloc] init];
    vc.spOrderID = bussinessModel.model_id;
    vc.completedBlock = ^(void){
        [self reloadData];
    };
    vc.alertMsg = alertMsg;
    vc.type = ORDERCANCEL_SP_TYPE;
    [self.navigationController pushViewController:vc animated:YES];
}
//刷新数据
-(void)reloadData {
    [self.tableView headerBeginRefreshing];
}
//申诉
-(void)appealWithBussinessModel:(BussinessModel *)bussinessModel {
    AppealController *vc = [[AppealController alloc] init];
    vc.spOrderID = bussinessModel.model_id;
    [self.navigationController pushViewController:vc animated:YES];
}
//取消代购
-(void)hspCancelWithBussinessModel:(BussinessModel *)bussinessModel AlertMsg:(NSString *)alertMsg{
    OrderCancelController *vc = [[OrderCancelController alloc] init];
    vc.spOrderID = bussinessModel.model_id;
    vc.type = ORDERCANCEL_HSP_TYPE;
    vc.alertMsg = alertMsg;
    vc.completedBlock = ^(void){
        [self reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//改价
-(void)changeThePriceWithBussinessModel:(BussinessModel *)bussinessModel {
    ChangePriceController *vc = [[ChangePriceController alloc] init];
    vc.sourceModel = bussinessModel;
    vc.reloadTableDataBlock = ^(void) {
        [self reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//付款
-(void)payWithBussinessModel:(BussinessModel *)bussinessModel {
    ZZGoPayViewController * goPayVC = [[ZZGoPayViewController alloc]init];
    goPayVC.orderID = bussinessModel.taskOrderFormId;
    [self.navigationController pushViewController:goPayVC animated:YES];
    //goPayVC.orderTitle = title;
    
    //[self loadOrderDetail:bussinessModel Title:bussinessModel.title];
    
//验证是否可以支付

//        if ([[dataDict objectForKey:@"orderAmount"] isEqualToString:@"0.00"]) {
//            SubZZMyOrderViewController * orderVC = [SubZZMyOrderViewController new];
//            [self.navigationController pushViewController:orderVC animated:YES];
//            return;
//        }
    
//        NSDictionary * param = [self parametersForDic:@"accountCheckPayOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":bussinessModel.taskOrderFormId}];
//        [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
//            NSString * result = [dic objectForKey:@"result"];
//            if ([result isEqualToString:@"0"]) {
//                [self loadOrderDetail:bussinessModel.taskOrderFormId Title:bussinessModel.title];
//            }else if ([result isEqualToString:@"200"]){
//                [self noMoneyWithBussinessModel];
//            }else{
//                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            }
//        } andFailureBlock:^{
//            
//        }];
    
    
}
//没钱，跳充值页面
-(void)noMoneyWithBussinessModel {
    RechargeViewController *vc = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//查看评价
-(void)scanEvaluateWithBussinessModel:(BussinessModel *)bussinessModel {
    MyEvaluateListViewController * myEvaluateVC = [[MyEvaluateListViewController alloc]init];
    [self.navigationController pushViewController:myEvaluateVC animated:YES];
}
//代购方-查看评价
-(void)hspScanEvaluateWithBussinessModel:(BussinessModel *)bussinessModel {
    SellerEvaluateListActivityViewController * sellerEvaluateVC = [[SellerEvaluateListActivityViewController alloc]init];
    [self.navigationController pushViewController:sellerEvaluateVC animated:YES];
}
//代购方-修改物流
//-(void)modifyLogisticsWithBussinessModel:(BussinessModel *)bussinessModel {
//    NSDictionary * param = [self parametersForDic:@"sellerModifyOrderTake" parameters:@{ACCOUNT_PASSWORD,@"orderId":bussinessModel.taskOrderFormId, @"invoiceName": bussinessModel.invoiceName, @"invoiceNo": bussinessModel.invoiceNo}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        if ([result isEqualToString:@"0"]) {
//            [self.tableView headerBeginRefreshing];
//        }else{
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//        }
//    } andFailureBlock:^{
//        
//    }];
//}
//代购方-修改物流-否
-(void)modifyLogisticsNOWithBussinessModel:(BussinessModel *)bussinessModel {
    WaittingSendViewController *vc = [[WaittingSendViewController alloc] init];
    vc.invoiceName = bussinessModel.invoiceName;
    vc.invoiceNo = bussinessModel.invoiceNo;
    vc.orderId = bussinessModel.taskOrderFormId;
    vc.isModify = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- 网络请求
//获取订单详情
//-(void)loadOrderDetail:(BussinessModel *)aModel Title:(NSString *)title {
//    NSDictionary * param = [self parametersForDic:@"accountGetOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":aModel.taskOrderFormId}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        if ([result isEqualToString:@"0"]) {
//            BussinessModel *model = [[BussinessModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic[@"data"]];
//            
//            ZZGoPayViewController2 * goPayVC = [[ZZGoPayViewController2 alloc]init];
//            goPayVC.orderID = model.orderId;
//            goPayVC.orderTitle = title;
//            //NSDictionary *dataDict = [NSDictionary dictionaryWithObjects:@[model.orderNum, model.goods, model.orderAmount,  aModel.taskCashCost] forKeys:@[@"orderNum", @"goods", @"orderAmount", @"price"]];
//            //goPayVC.orderDataDic = dataDict;
//            [self.navigationController pushViewController:goPayVC animated:YES];
//        }else{
//            if (![result isEqualToString:@"4"]){
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            }
//        }
//    } andFailureBlock:^{
//        
//    }];
//}
-(void)headerRefresh {
    [self loadNewDataListRequest];
}

-(void)footerRefresh {
    [self loadMoreDataListRequest];
}
-(NSString *)getRequestUrl {
    NSString *requestUrl = @"accountGetBuyPostList";
    if (_type == SP_TYPE) {
        requestUrl = @"accountGetBuyPostList";
    }else if (_type == HELP_SP_TYPE) {
        requestUrl = @"accountGetBidPostList";
    }
    return requestUrl;
}
//最新话题列表
- (void)loadNewDataListRequest
{
    if (self.reloadNavTitle) {
        self.reloadNavTitle();
    }
    page = 0;
    
    NSDictionary * param = [self parametersForDic:[self getRequestUrl] parameters:@{ACCOUNT_PASSWORD, @"code":_orderStatus, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
         _noDataView.hidden = YES;
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
            }
            
        }else if([result isEqualToString:@"4"]){
             _noDataView.hidden = NO;
        }else{
             _noDataView.hidden = NO;
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
    }];
    
}
//更多话题列表
- (void)loadMoreDataListRequest
{

    page += NumOfItemsForZuji;
    //    NSString *categoryID = @"250";
    //    if (_type == Users_Type) {
    //        categoryID = @"251";
    //    }
    
    NSDictionary * param = [self parametersForDic:[self getRequestUrl] parameters:@{ACCOUNT_PASSWORD, @"code":_orderStatus,@"start":[NSString stringWithFormat:@"%d", page], @"count":[NSString stringWithFormat:@"%d",count]}];
    
    //    NSDictionary * param = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":categoryID, @"order": @"postid", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [self.dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [self.tableView footerEndRefreshing];
    }];
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
