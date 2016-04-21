//
//  OrderDetailController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define V_SPACE 10

#import "OrderDetailController.h"
#import "OrderStatusView.h"
#import "OrderImageStatusView.h"
#import "OrderLogisticsView.h"
#import "OrderSerialView.h"
#import "OrderGoodsView.h"
#import "OrderSPView.h"
#import "AppDelegate.h"
#import "CommonView.h"
#import "PersonalOrderOperateView.h"
#import "CommonView.h"
#import "MyChatViewController.h"
#import "RCUserInfo.h"
#import "PersonalViewController.h"
#import "PublishSPController.h"
#import "ChangeSaleViewController2.h"
#import "DetailActivityViewController.h"
#import "OrderImageAddController.h"
#import "WaittingSendViewController.h"
#import "MineEvaluateViewController.h"
#import "LogisticsController.h"
#import "OrderCancelController.h"
#import "AppealController.h"
#import "LayoutFrame.h"
#import "ChangePriceController.h"
#import "ZZGoPayViewController.h"
#import "RechargeViewController.h"
#import "MyEvaluateListViewController.h"
#import "SellerEvaluateListActivityViewController.h"
#import "PersonalHelpSpApplyListController.h"
#import "SPDetailListController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshHeaderView.h"

@interface OrderDetailController ()
{
    NSArray *_logisticsArray;
    NSDictionary *_orderDetailDict;
    //MBProgressHUD *_hud;
    PersonalOrderOperateView *_operateView;
}
@property (nonatomic, strong)BussinessModel *bussinessModel;
@end

@implementation OrderDetailController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backClicked)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSPOrderDetail) name:@"SPOrderContirmReceiptNF" object:nil];
    
    [self.contentSV addHeaderWithTarget:self action:@selector(loadSPOrderDetail)];
    [self.contentSV headerBeginRefreshing];
}
#pragma mark- 页面
-(void)setUpPersonalOrderOperateView {
    if (_operateView) {
        [_operateView removeFromSuperview];
        _operateView = nil;
    }
    
    PersonalOrderOperateView *operateView = [[PersonalOrderOperateView alloc] initWithFrame:self.operateBtnSuperView.bounds OrderStatus:self.bussinessModel.taskStatus CurrentViewController:self BussinessModel:self.bussinessModel];
    [self.operateBtnSuperView addSubview:operateView];
    _operateView = operateView;
    
    if (operateView.subviews.count == 0) {
        self.operateBtnSuperView.hidden = YES;
        [LayoutFrame showViewConstraint:self.operateBtnSuperView AttributeHeight:1];
    }
}
-(void)fillWithData{
    float y = 0.0;
    //先移除
    for (UIView *view in self.contentSV.subviews) {
        if (![view isKindOfClass:[MJRefreshHeaderView class]]) {
            [view removeFromSuperview];
        }
        
    }
   
    NSDictionary *order = _orderDetailDict[@"order"];
    NSDictionary *bid = _orderDetailDict[@"bid"];
    
    if ([_orderDetailDict[@"sellStatus"] intValue] != 0) {
        //订单图片指示状态
        OrderImageStatusView *imageStatus = [[OrderImageStatusView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 104.0)];
        imageStatus.statusIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"order_status%d", [_orderDetailDict[@"sellStatus"] intValue]]];
        [self.contentSV addSubview:imageStatus];
        y += CGRectGetHeight(imageStatus.frame);
    }
    
    
    //代购状态
    OrderStatusView *status = [[OrderStatusView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 92)];
    status.statusMsgLbl.text = _orderDetailDict[@"taskStatusNote"];
    status.statusLbl.text = _orderDetailDict[@"taskStatusName"];
    status.timeLbl.text = _orderDetailDict[@"updatetime"];
    [self.contentSV addSubview:status];
    y += CGRectGetHeight(status.frame) + V_SPACE;
    
    if (_logisticsArray && _logisticsArray.count != 0) {
        //物流信息
        OrderLogisticsView *logistics = [[OrderLogisticsView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 208)];
        [self.contentSV addSubview:logistics];
        y += CGRectGetHeight(logistics.frame) + V_SPACE;
        
        logistics.nameLbl.text = order[@"contacterName"];
        logistics.addressLbl.text = order[@"address"];
        logistics.mobileLbl.text = order[@"mobile"];
        logistics.logisticsLbl.text = [_logisticsArray lastObject][@"remark"];
        logistics.timeLbl.text = [_logisticsArray lastObject][@"datetime"];
        
        [logistics.logisticsSuperView addTapAction:@selector(goLogisticsVC) forTarget:self];
    }
    
    NSDictionary *goodsData = order[@"goods"][0];
    if (goodsData) {
        //商品
        OrderGoodsView *goods = [[OrderGoodsView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 270)];
        [self.contentSV addSubview:goods];
        y += CGRectGetHeight(goods.frame) + V_SPACE;
        [goods.goodsSuperView addTapAction:@selector(goGoodsDetailVC) forTarget:self];
        
        goods.brandLbl.text = goodsData[@"brand"];
        goods.titleLbl.text = goodsData[@"title"];
        [goods.coverIV sd_setImageWithURL:[NSURL URLWithString:goodsData[@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image.size.height > image.size.width) {
                goods.coverIV.contentMode = UIViewContentModeScaleToFill;
            }else{
                goods.coverIV.contentMode = UIViewContentModeScaleAspectFit;
            }
        }];
        if ([_orderDetailDict[@"account"] isEqualToString:ACCOUNT_SELF]) {
            //求购方
            goods.roleLbl.text = @"代购";
            [goods.avaterIV sd_setImageWithURL:[NSURL URLWithString:order[@"selleravatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            goods.nicknameLbl.text = order[@"sellernick"];

            
        }else {
            
            goods.roleLbl.text = @"求购";
            
            goods.nicknameLbl.text = order[@"buyernick"];
            
            [goods.avaterIV sd_setImageWithURL:[NSURL URLWithString:order[@"buyeravatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        }
        
        //运费
        goods.freightLbl.text = [NSString stringWithFormat:@"¥ %@",order[@"transportPrice"]];
        
        //实付款
        goods.realPayment.text = [NSString stringWithFormat:@"¥ %@",order[@"orderAmount"]];
        goods.priceLbl.text = [NSString stringWithFormat:@"¥ %@",order[@"goodsAmount"]];
        
        //押金
        //goods.depositLbl.text = _orderDetailDict[@"taskCash"];
        
        
        goods.sizeLbl.text = goodsData[@"size"];
        goods.amountLbl.text = [NSString stringWithFormat:@"x%@", order[@"goods"][0][@"num"]];
        
        [goods.chatBtn addTarget:self action:@selector(chatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [goods.avaterIV addTapAction:@selector(goodsAvatarClicked) forTarget:self];

    }
    
    //求购单
    OrderSPView *sp = [[OrderSPView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 258)];
    [sp.coverIV1 addTapAction:@selector(spTap) forTarget:self];
    [sp.coverIV2 addTapAction:@selector(hspTap) forTarget:self];
    //求购单
    [sp.avater1 sd_setImageWithURL:[NSURL URLWithString:_orderDetailDict[@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    sp.nicknameLbl1.text = _orderDetailDict[@"nickname"];
    sp.brandLbl1.text = _orderDetailDict[@"brand"];
    sp.nameLbl1.text = _orderDetailDict[@"title"];
    [sp.coverIV1 sd_setImageWithURL:[NSURL URLWithString:_orderDetailDict[@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image.size.height > image.size.width) {
            sp.coverIV1.contentMode = UIViewContentModeScaleToFill;
        }else{
            sp.coverIV1.contentMode = UIViewContentModeScaleAspectFit;
        }
    }];
    sp.sizeLbl1.text = _orderDetailDict[@"size"];
    sp.amountLbl1.text = [NSString stringWithFormat:@"x%@", _orderDetailDict[@"storage"]];
    [sp.avater1 addTapAction:@selector(spAvatarClicked) forTarget:self];
    [sp.avater2 addTapAction:@selector(hspAvatarClicked) forTarget:self];
    
    
    if (bid) {
        [sp.avater2 sd_setImageWithURL:[NSURL URLWithString:bid[@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        sp.nicknameLbl2.text = bid[@"nickname"];
        sp.purchasingTimeLbl.text = bid[@"sendtime"];
        //sp.purchasingPlaceLbl.text = [NSString stringWithFormat:@"预计：%@", bid[@"area"]];
        sp.purchasingPlaceLbl.text = bid[@"area"];
        sp.quotePriceLbl.text = [NSString stringWithFormat:@"报价：￥ %@", bid[@"quote"]];
        sp.depositeLbl.text = [NSString stringWithFormat:@"押金：￥ %@", bid[@"money"]];;
        [sp.coverIV2 sd_setImageWithURL:[NSURL URLWithString:bid[@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image.size.height > image.size.width) {
                sp.coverIV2.contentMode = UIViewContentModeScaleToFill;
            }else{
                sp.coverIV2.contentMode = UIViewContentModeScaleAspectFit;
            }
        }];
    }else {
        sp.superView2.hidden = YES;
    }
    
    
    [self.contentSV addSubview:sp];
    y += CGRectGetHeight(sp.frame) + V_SPACE;
    
    if (_orderDetailDict[@"time"] && ((NSArray *)_orderDetailDict[@"time"]).count != 0) {
        //订单流水
        OrderSerialView *serial = [[OrderSerialView alloc] initWithData:_orderDetailDict[@"time"] Frame:CGRectMake(0, y, SCREEN_WIDTH, 670)];
        [self.contentSV addSubview:serial];
        y += CGRectGetHeight(serial.frame);
        
        self.contentSV.contentSize = CGSizeMake(0, y);
    }
    
}
#pragma mark- 事件
-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
//求购者头像点击
-(void)spAvatarClicked {
    [self goPersonalVC:_orderDetailDict[@"account"]];
}
//代购者头像点击
-(void)hspAvatarClicked {
    NSDictionary *bid = _orderDetailDict[@"bid"];
    [self goPersonalVC:bid[@"account"]];
}
//商品用户头像点击
-(void)goodsAvatarClicked {
    NSString *account = @"";
    NSDictionary *order= _orderDetailDict[@"order"];
    if ([_orderDetailDict[@"account"] isEqualToString:ACCOUNT_SELF]) {
        //求购方
        account = order[@"sellername"];
    }else {
        account = order[@"buyername"];
    }
    [self goPersonalVC:account];
}
-(void)goPersonalVC:(NSString *)account {
    PersonalViewController * personVC = [[PersonalViewController alloc]init];
    personVC.account = account;
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}

-(void)chatBtnClicked:(UIButton *)sender {
    NSString *nickname = @"";
    NSString *avatar = @"";
    NSString *account = @"";
    NSDictionary *order= _orderDetailDict[@"order"];
    if ([_orderDetailDict[@"account"] isEqualToString:ACCOUNT_SELF]) {
        //求购方
        account = order[@"sellername"];
        avatar = order[@"selleravatar"];
        nickname = order[@"sellernick"];
    }else {
        account = order[@"buyername"];
        avatar = order[@"buyeravatar"];
        nickname = order[@"buyernick"];
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
}
//点击物流区域-查看物流
-(void)goLogisticsVC {
    [self viewLogistisWithBussinessModel:self.bussinessModel];
}
//点击商品区域-查看商品
-(void)goGoodsDetailVC {
    [self scanWithBussinessModel:self.bussinessModel];
}
//求购单点击
-(void)spTap {
    SPDetailListController *vc = [[SPDetailListController alloc] init];
    vc.modelId = self.bussinessModel.model_id;
    vc.hiddenSPBtn = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//代购单点击
-(void)hspTap {
    PersonalHelpSpApplyListController *vc = [[PersonalHelpSpApplyListController alloc] init];
    vc.hiddenOperation = YES;
    vc.modelID = self.bussinessModel.model_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- PersonalOrderOperateButtonDelegate mehod
//删除
-(void)deleteWithBussinessModel:(BussinessModel *)bussinessModel {
    if (self.deleteBlock) {
        self.deleteBlock(bussinessModel);
    }
    [self backClicked];
}
-(void)cancelWithBussinessModel:(BussinessModel *)bussinessModel {
    if (self.deleteBlock) {
        self.deleteBlock(bussinessModel);
    }
    [self backClicked];
}
//再次求购
-(void)reSPWithBussinessModel:(BussinessModel *)bussinessModel {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
    PublishSPController * vc = sb.instantiateInitialViewController;
    //        vc.theSign = @"2";
    vc.isFromPublish = NO;
    vc.sourceBussinessModel = bussinessModel;
    [self.navigationController pushViewController:vc animated:YES];
}
//商品报价
-(void)quotePriceWithBussinessModel:(BussinessModel *)bussinessModel {
    ChangeSaleViewController2 *vc = [[ChangeSaleViewController2 alloc] init];
    vc.title = @"商品报价";
    vc.spOrderID = bussinessModel.model_id;
    [self.navigationController pushViewController:vc animated:YES];
    vc.backBlock = ^(void){
        [self loadSPOrderDetail];
    };
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
    vc.backBlock = ^(void){
        [self loadSPOrderDetail];
    };
}
//采购成功
-(void)purchaiseSuccessWithBussinessModel:(BussinessModel *)bussinessModel {
    OrderImageAddController *vc = [[OrderImageAddController alloc] init];
    vc.spOrderID = bussinessModel.model_id;
    vc.goodsID = bussinessModel.taskDealPostId;
    [self.navigationController pushViewController:vc animated:YES];
    vc.backBlock = ^(void){
        [self loadSPOrderDetail];
    };
}
//发货
-(void)deliveryWithBussinessModel:(BussinessModel *)bussinessModel {
    WaittingSendViewController *vc = [[WaittingSendViewController alloc] init];
    vc.orderId = bussinessModel.taskOrderFormId;
    [self.navigationController pushViewController:vc animated:YES];
    vc.backBlock = ^(void){
        [self loadSPOrderDetail];
    };
}
//我的求购-评价
-(void)commentWithBussinessModel:(BussinessModel *)bussinessModel {
    MineEvaluateViewController *vc = [[MineEvaluateViewController alloc] init];
    vc.orderID = bussinessModel.taskOrderFormId;
    vc.orderType = BUYER_TYPE;
    vc.backBlock = ^(void){
        [self loadSPOrderDetail];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//我的代购-评价
-(void)hspCommentWithBussinessModel:(BussinessModel *)bussinessModel {
    MineEvaluateViewController *vc = [[MineEvaluateViewController alloc] init];
    vc.orderID = bussinessModel.taskOrderFormId;
    vc.orderType = SELLER_TYPE;
    vc.backBlock = ^(void){
        [self loadSPOrderDetail];
    };
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
        if (self.reloadDataBlock) {
            self.reloadDataBlock();
            [self loadSPOrderDetail];
        }
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
        if (self.reloadDataBlock) {
            self.reloadDataBlock();
            [self loadSPOrderDetail];
        }
    };
    vc.alertMsg = alertMsg;
    vc.type = ORDERCANCEL_SP_TYPE;
    [self.navigationController pushViewController:vc animated:YES];
}
//刷新数据
-(void) reloadData{
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}
//申诉
-(void)appealWithBussinessModel:(BussinessModel *)bussinessModel {
    AppealController *vc = [[AppealController alloc] init];
    vc.spOrderID = bussinessModel.model_id;
    vc.backBlock = ^(void){
        [self loadSPOrderDetail];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//取消代购
-(void)hspCancelWithBussinessModel:(BussinessModel *)bussinessModel AlertMsg:(NSString *)alertMsg{
    OrderCancelController *vc = [[OrderCancelController alloc] init];
    vc.spOrderID = bussinessModel.model_id;
    vc.alertMsg = alertMsg;
    vc.completedBlock = ^(void){
        [self reloadData];
        [self loadSPOrderDetail];
    };
    vc.type = ORDERCANCEL_HSP_TYPE;
    [self.navigationController pushViewController:vc animated:YES];
}
//付款
-(void)payWithBussinessModel:(BussinessModel *)bussinessModel {
    ZZGoPayViewController * goPayVC = [[ZZGoPayViewController alloc]init];
    goPayVC.orderID = bussinessModel.taskOrderFormId;
    [self.navigationController pushViewController:goPayVC animated:YES];
    
    //[self loadOrderDetail:bussinessModel.taskOrderFormId Title:bussinessModel.title];
    //验证是否可以支付
    
    //        if ([[dataDict objectForKey:@"orderAmount"] isEqualToString:@"0.00"]) {
    //            SubZZMyOrderViewController * orderVC = [SubZZMyOrderViewController new];
    //            [self.navigationController pushViewController:orderVC animated:YES];
    //            return;
    //        }
    
//    NSDictionary * param = [self parametersForDic:@"accountCheckPayOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":bussinessModel.taskOrderFormId}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        if ([result isEqualToString:@"0"]) {
//            
//            [self loadOrderDetail:bussinessModel.taskOrderFormId Title:bussinessModel.title];
//        }else{
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//        }
//    } andFailureBlock:^{
//        
//    }];
    
    
}
//改价
-(void)changeThePriceWithBussinessModel:(BussinessModel *)bussinessModel {
    ChangePriceController *vc = [[ChangePriceController alloc] init];
    vc.sourceModel = bussinessModel;
    vc.reloadTableDataBlock = ^(void) {
        [self reloadData];
    };
    vc.backBlock = ^(void){
        [self loadSPOrderDetail];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
//发货-自提
//-(void)deliverySinceWithBussinessModel:(BussinessModel *)bussinessModel {
//    [self loadSPOrderDetail];
//}

//代购方-修改物流
//-(void)modifyLogisticsWithBussinessModel:(BussinessModel *)bussinessModel {
//    NSDictionary * param = [self parametersForDic:@"sellerModifyOrderTake" parameters:@{ACCOUNT_PASSWORD,@"orderId":bussinessModel.taskOrderFormId, @"invoiceName": bussinessModel.invoiceName, @"invoiceNo": bussinessModel.invoiceNo}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        if ([result isEqualToString:@"0"]) {
//            [self loadSPOrderDetail];
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
    vc.backBlock = ^(void){
        [self loadSPOrderDetail];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- 网络请求
//获取订单详情
-(void)loadOrderDetail:(NSString *)orderId Title:(NSString *)title {
    NSDictionary * param = [self parametersForDic:@"accountGetOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":orderId}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            BussinessModel *model = [[BussinessModel alloc] init];
            [model setValuesForKeysWithDictionary:dic[@"data"]];
            
            ZZGoPayViewController * goPayVC = [[ZZGoPayViewController alloc]init];
            goPayVC.orderID = model.orderId;
            goPayVC.orderTitle = title;
            NSDictionary *dataDict = [NSDictionary dictionaryWithObjects:@[model.orderNum, model.goods, model.orderAmount] forKeys:@[@"orderNum", @"goods", @"orderAmount"]];
            //goPayVC.orderDataDic = dataDict;
            [self.navigationController pushViewController:goPayVC animated:YES];
        }else{
            if (![result isEqualToString:@"4"]){
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
    } andFailureBlock:^{
        
    }];
}

#pragma mark- 网络请求
#pragma mark- 获取订单详情
-(void)loadOrderDetailRequest {
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountGetTaskOrder" parameters:@{ACCOUNT_PASSWORD, @"id": self.orderID}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [self.contentSV headerEndRefreshing];
        if ([result isEqualToString:@"0"]) {
            _orderDetailDict = dic[@"data"];
            self.bussinessModel.invoiceName = _orderDetailDict[@"invoiceName"];
            self.bussinessModel.invoiceNo= _orderDetailDict[@"invoiceNo"];
            self.bussinessModel.taskCashCost = _orderDetailDict[@"taskCashCost"];
            [self setUpPersonalOrderOperateView];
            if (_orderDetailDict[@"invoiceNo"] && _orderDetailDict[@"invoiceName"] && ((NSString *)_orderDetailDict[@"invoiceName"]).length != 0 && ((NSString *)_orderDetailDict[@"invoiceNo"]).length != 0) {
                [self loadLogisticsRequest];
                
            }else {
                //[_hud removeFromSuperview];
                [self fillWithData];
            }
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[_hud removeFromSuperview];
            
        }
    } andFailureBlock:^{
        //[_hud removeFromSuperview];
    }];
}
//获取物流详细
-(void)loadLogisticsRequest {
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"getExpressState" parameters:@{ACCOUNT_PASSWORD, @"name": _orderDetailDict[@"invoiceName"], @"number": _orderDetailDict[@"invoiceNo"]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        //[_hud removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (dic[@"data"][@"list"]) {
                _logisticsArray = dic[@"data"][@"list"];
                //[self fillWithData];
            }
            [self fillWithData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            
            
        }
    } andFailureBlock:^{
        //[_hud removeFromSuperview];
    }];
}
-(void)loadSPOrderDetail {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"获取中,请稍后";
//    hud.dimBackground = YES;
    //[hud show:YES];
    //_hud = hud;
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"getPostDetail" parameters:@{ACCOUNT_PASSWORD, @"id": self.orderID}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            BussinessModel *model = [[BussinessModel alloc] init];
            [model setValuesForKeysWithDictionary:dic[@"data"]];
             self.bussinessModel = model;
            [self loadOrderDetailRequest];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[_hud removeFromSuperview];
            [self.contentSV headerEndRefreshing];
        }
    } andFailureBlock:^{
        //[hud removeFromSuperview];
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
