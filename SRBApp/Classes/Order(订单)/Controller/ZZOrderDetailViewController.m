//
//  ZZOrderDetailViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZOrderDetailViewController.h"
#import <UIImageView+WebCache.h>
#import "ZZCancelOrderViewController.h"
#import "ZZGoPayViewController.h"
#import "BuyerWaitCommentViewController.h"
#import "MineEvaluateViewController.h"
#import "SecondSubclassDetailViewController.h"
#import "SubViewController.h"
#import "ZZMyOrderViewController.h"

@interface ZZOrderDetailViewController ()<UIAlertViewDelegate>

@end

@implementation ZZOrderDetailViewController
{
    NSDictionary * dataDic;
    UIButton * orderBtn;        //右上角button
    UIScrollView * mainScroll;
    UIView * orderInfoView;     //商品详情所在view
    UILabel * totalPrice;       //总价(运费)
    NSDictionary * goodsDic;    //商品信息
    UIView * addressView;       //地址栏的view
    UIView * postMethodView;    //运费栏的view
    UIView * topBGView;
    UILabel * buyerSayLabel;
    UILabel * sellerSayLabel;
    UILabel * buyerLabel;       //买家留言
    UILabel * sellerLabel;      //卖家留言
    UIActivityIndicatorView * activity;
    BOOL isOrderDied;           //订单是否失效
    

}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    //初始化控件
    [self customInit];
    //[self urlRequest];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self urlRequest];
    //网络请求
}

#pragma mark - 发送请求
- (void)urlRequest
{
    if (self.orderID == nil || [self.orderID isEqualToString:@"0"] || [self.orderID isEqualToString:@""]) {
        [AutoDismissAlert autoDismissAlert:@"订单失效"];
        isOrderDied = YES;
        return;
    }
    isOrderDied = NO;
    [loadImg removeFromSuperview];
    loadImg = [[LoadImg alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    loadImg.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [self.view addSubview:loadImg];
    [loadImg imgStart];
    //拼接post请求参数
    NSDictionary * dic = [self parametersForDic:@"accountGetOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID}];
    
    //发送请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        //如果获取成功且有数据
        if ([result isEqualToString:@"0"]) {
            dataDic = [dic objectForKey:@"data"];
            isOrderDied = NO;
            [self makeDataToKongjian];
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
            isOrderDied = YES;
        }
        [loadImg imgStop];
        [loadImg removeFromSuperview];
        [mainScroll headerEndRefreshing];
    } andFailureBlock:^{
        isOrderDied = YES;
        [loadImg imgStop];
        [loadImg removeFromSuperview];
        [mainScroll headerEndRefreshing];
    }];
    
}

- (void)sellerPersonTap:(UITapGestureRecognizer *)tap
{
    if (isOrderDied == NO) {
        SubViewController * personVC = [[SubViewController alloc]init];
        personVC.myRun = @"2";
        personVC.account = [goodsDic objectForKey:@"account"];
        [self.navigationController pushViewController:personVC animated:YES];
    }
}

#pragma mark - 控件赋值
- (void)makeDataToKongjian
{
    NSArray * temparr = [dataDic objectForKey:@"goods"];
    NSDictionary * tempdic = temparr[0];
    goodsDic = tempdic;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:orderBtn];
    
    CGRect rect = [[dataDic objectForKey:@"address"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 77 - 20 - 15, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
    CGRect addressLB2Fram = self.addressLB2.frame;
    addressLB2Fram.size.height = rect.size.height + 2;
    self.addressLB2.frame = addressLB2Fram;
    
    
    CGRect sellerRect = [[dataDic objectForKey:@"toBuyer"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70 - 15 - 15 - 5, 40000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_12} context:nil];
    
    CGRect buyerRect = [[dataDic objectForKey:@"postscript"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70 - 15 - 15 - 5, 40000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_12} context:nil];
    
    if ([dataDic objectForKey:@"guarantorname"] != nil && ![[dataDic objectForKey:@"guarantorname"] isEqualToString:@""] && [[dataDic objectForKey:@"guarantorname"] length] != 0) {
        self.danBaoReason.hidden = NO;
        self.danBaoRen.hidden = NO;
        self.danBaoTime.hidden = NO;
        buyerLabel.frame = CGRectMake(15, self.danBaoTime.frame.size.height + self.danBaoTime.frame.origin.y + 8, 70, 14);
        buyerSayLabel.frame = CGRectMake(buyerLabel.frame.size.width + buyerLabel.frame.origin.x + 5, buyerLabel.frame.origin.y, SCREEN_WIDTH - 70 - 15 - 15 - 5, 14);
    }else{
        buyerLabel.frame = CGRectMake(15, self.createTimeLabel.frame.size.height + self.createTimeLabel.frame.origin.y + 8, 70, 14);
        buyerSayLabel.frame = CGRectMake(buyerLabel.frame.size.width + buyerLabel.frame.origin.x + 5, buyerLabel.frame.origin.y, SCREEN_WIDTH - 70 - 15 - 15 - 5, 14);
    }
    
    CGRect buyerSayRect = buyerSayLabel.frame;
    buyerSayRect.size.height = buyerRect.size.height;
    buyerSayLabel.frame = buyerSayRect;
    
    sellerLabel.frame = CGRectMake(15, buyerSayLabel.frame.size.height + buyerSayLabel.frame.origin.y + 5, 70, 14);
    sellerSayLabel.frame = CGRectMake(sellerLabel.frame.size.width + sellerLabel.frame.origin.x + 5, sellerLabel.frame.origin.y, SCREEN_WIDTH - 70 - 15 - 15 - 5, 14);
    
    CGRect sellerSayRect = sellerSayLabel.frame;
    sellerSayRect.size.height = sellerRect.size.height;
    sellerSayLabel.frame = sellerSayRect;
    
    self.payTimeLabel.frame = CGRectMake(0, sellerSayLabel.frame.size.height + sellerSayLabel.frame.origin.y + 5, SCREEN_WIDTH, 12);
    self.shippingTime.frame = CGRectMake(0, self.payTimeLabel.frame.size.height + self.payTimeLabel.frame.origin.y + 8, SCREEN_WIDTH, 12);
    self.sendCompany.frame = CGRectMake(0, self.shippingTime.frame.size.height + self.shippingTime.frame.origin.y + 8, SCREEN_WIDTH, 12);
    self.sendID.frame = CGRectMake(0, self.sendCompany.frame.size.height + self.sendCompany.frame.origin.y + 8, SCREEN_WIDTH, 12);
    self.receiveTime.frame = CGRectMake(0, self.sendID.frame.size.height + self.sendID.frame.origin.y + 8, SCREEN_WIDTH, 12);
    self.cancelReson.frame = CGRectMake(0, self.receiveTime.frame.size.height + self.receiveTime.frame.origin.y + 8, SCREEN_WIDTH, 12);
    self.cancelTime.frame = CGRectMake(0, self.cancelReson.frame.size.height + self.cancelReson.frame.origin.y + 8, SCREEN_WIDTH, 12);
    
    addressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 85 + rect.size.height);
    
    topBGView.frame = CGRectMake(0, addressView.frame.size.height + addressView.frame.origin.y + 15, SCREEN_WIDTH, 90+30);
    
    postMethodView.frame = CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y + 15, SCREEN_WIDTH, 122);
    
    if ([dataDic objectForKey:@"guarantorname"] != nil && ![[dataDic objectForKey:@"guarantorname"] isEqualToString:@""] && [[dataDic objectForKey:@"guarantorname"] length] != 0) {
        orderInfoView.frame = CGRectMake(0, postMethodView.frame.size.height + postMethodView.frame.origin.y + 15, SCREEN_WIDTH, 116 + sellerSayLabel.frame.size.height + buyerSayLabel.frame.size.height);
    }else{
        orderInfoView.frame = CGRectMake(0, postMethodView.frame.size.height + postMethodView.frame.origin.y + 15, SCREEN_WIDTH, 56 + sellerSayLabel.frame.size.height + buyerSayLabel.frame.size.height);
    }
    
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
    
    [mainScroll addHeaderWithTarget:self action:@selector(urlRequest)];
    
//==============================================================================
    self.phoneLabel.contentLabel.text = [dataDic objectForKey:@"mobile"];
    self.addressLB2.text = [dataDic objectForKey:@"address"];
    self.reUserName.contentLabel.text = [dataDic objectForKey:@"contacterName"];
//==============================================================================
    //商品图片
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[tempdic objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    self.imageview.clipsToBounds = YES;
    //商品名称
    self.orderTitleLabel.text = [tempdic objectForKey:@"title"];
    //卖家名字
    self.sellerNameLabel.text = [NSString stringWithFormat:@"卖家:%@",[dataDic objectForKey:@"sellernick"]];
    //商品价格
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[tempdic objectForKey:@"price"]];
    //商品数量
    self.goodsNumLabel.text = [NSString stringWithFormat:@"x%@",[tempdic objectForKey:@"num"]];
    //商品id
    self.idNumber = [tempdic objectForKey:@"id"];
//===================================================================================
    //运费
    self.sendPostText.text = [NSString stringWithFormat:@"¥ %@",[dataDic objectForKey:@"transportPrice"]];
    //配送方式
    self.sendMethodLabel.text = [dataDic objectForKey:@"shippingName"];
    //商品金额
    self.priceText.text = [NSString stringWithFormat:@"¥ %@",[dataDic objectForKey:@"orderAmount"]];
//===================================================================================
    //卖家留言
    NSString * sellerStr = [dataDic objectForKey:@"toBuyer"];
    if ([sellerStr isEqualToString:@"0"] || [sellerStr isEqualToString:@""] || sellerStr == nil) {
        sellerStr = @"无";
    }
    sellerSayLabel.text = sellerStr;
    
    //买家留言
    NSString * buyerStr = [dataDic objectForKey:@"postscript"];
    if ([buyerStr isEqualToString:@"0"] || [buyerStr isEqualToString:@""] || buyerStr == nil) {
        buyerStr = @"无";
    }
    buyerSayLabel.text = buyerStr;
    
    //订单号
    self.orderIDLabel.contentLabel.text = [dataDic objectForKey:@"orderNum"];
    //创建时间
    NSString * confirmTimeStr = [dataDic objectForKey:@"updatetime"];
    if ([confirmTimeStr isEqualToString:@""]||confirmTimeStr == nil || confirmTimeStr.length == 0) {
        confirmTimeStr = @"无";
    }
    self.createTimeLabel.contentLabel.text = confirmTimeStr;

    //担保人
    if ([[dataDic objectForKey:@"guarantorname"] isEqualToString:@""]||[dataDic objectForKey:@"guarantorname"] == nil ) {
        self.danBaoRen.contentLabel.text = @"无";
    }else{
        self.danBaoRen.contentLabel.text = [dataDic objectForKey:@"guarantornick"];
    }
    //担保理由
    if ([[dataDic objectForKey:@"guaranteeNote"] isEqualToString:@""]||[dataDic objectForKey:@"guaranteeNote"] == nil ) {
        self.danBaoReason.contentLabel.text = @"无";
    }else{
        self.danBaoReason.contentLabel.text = [dataDic objectForKey:@"guaranteeNote"];
    }
    //担保时间
    if ([[dataDic objectForKey:@"guaranteeTime"] isEqualToString:@""]||[dataDic objectForKey:@"guaranteeTime"] == nil ) {
        self.danBaoTime.contentLabel.text = @"无";
    }else{
        self.danBaoTime.contentLabel.text = [dataDic objectForKey:@"guaranteeTime"];
    }
    
    
    //快递公司,快递单号,支付时间
    self.payTimeLabel.contentLabel.text = [dataDic objectForKey:@"paytime"];
    //快递公司
    if ([[dataDic objectForKey:@"invoiceName"] isEqualToString:@""]||[dataDic objectForKey:@"invoiceName"] == nil ) {
        self.sendCompany.contentLabel.text = @"无";
    }else{
        self.sendCompany.contentLabel.text = [dataDic objectForKey:@"invoiceName"];
    }
    //快递单号
    if ([[dataDic objectForKey:@"invoiceNo"] isEqualToString:@""]||[dataDic objectForKey:@"invoiceNo"] == nil ) {
        self.sendID.contentLabel.text = @"无";
    }else{
        self.sendID.contentLabel.text = [dataDic objectForKey:@"invoiceNo"];
    }
    
    //发货时间
    if ([[dataDic objectForKey:@"shippingTime"] isEqualToString:@""] || [dataDic objectForKey:@"shippingTime"] == nil) {
        self.shippingTime.contentLabel.text = @"无";
    }else{
        self.shippingTime.contentLabel.text = [dataDic objectForKey:@"shippingTime"];
    }
    //收货时间
    if ([[dataDic objectForKey:@"receiveTime"] isEqualToString:@""] || [dataDic objectForKey:@"receiveTime"] == nil) {
        self.receiveTime.contentLabel.text = @"无";
    }else{
        self.receiveTime.contentLabel.text = [dataDic objectForKey:@"receiveTime"];
    }
    
    //合计
    totalPrice.text = [NSString stringWithFormat:@"合计:¥%.2f",[[dataDic objectForKey:@"orderAmount"] floatValue]+[[dataDic objectForKey:@"transportPrice"] floatValue]];

    if ([[dataDic objectForKey:@"status"] isEqualToString:@"5"] || [[dataDic objectForKey:@"status"] intValue]>= 51) {
        self.cancelReson.titleLabel.text = @"退款原因";
        self.cancelTime.titleLabel.text = @"退款时间";
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"当前状态：%@",[dataDic objectForKey:@"statusName"]];
    
    
    if ([[dataDic objectForKey:@"status"]intValue] >= 4) {
        self.statusBtn.hidden = YES;
        self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    }else if([[dataDic objectForKey:@"status"]isEqualToString:@"0"]){
        //待付款
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 8;
        orderInfoView.frame = rect;
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
        //卖家未确认
        if ([[dataDic objectForKey:@"confirm"] isEqualToString:@"1"]) {
            [self.statusBtn setTitle:@"去付款" forState:UIControlStateNormal];
            self.statusBtn.hidden = NO;
            self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, 50);
        }
    }else if ([[dataDic objectForKey:@"status"]intValue] == 2){
        //待收货
        self.statusBtn.hidden = NO;
        [self.statusBtn setTitle:@"确定收货" forState:UIControlStateNormal];
        self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, 50);
    }else if ([[dataDic objectForKey:@"status"]intValue] == 3){
        //待评价
        self.statusBtn.hidden = NO;
        [self.statusBtn setTitle:@"去评价" forState:UIControlStateNormal];
        self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, 50);
    }else{
        self.statusBtn.hidden = YES;
        self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    }
    
    if ([[dataDic objectForKey:@"status"]isEqualToString:@"60"]) {
        self.payTimeLabel.hidden = NO;
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 28;
        orderInfoView.frame = rect;
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
    }
    
    //待发货
    if ([[dataDic objectForKey:@"status"]isEqualToString:@"1"])
    {
        self.payTimeLabel.hidden = NO;
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 28;
        orderInfoView.frame = rect;
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
    }
    
    //设置右上角button
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"-100"]) {
        orderBtn.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [orderBtn setTitle:@"删 除" forState:UIControlStateNormal];
    }else if ([[dataDic objectForKey:@"status"] isEqualToString:@"0"]){
        orderBtn.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [orderBtn setTitle:@"取 消" forState:UIControlStateNormal];
    }else if ([[dataDic objectForKey:@"status"] isEqualToString:@"5"]){
        orderBtn.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [orderBtn setTitle:@"同 意" forState:UIControlStateNormal];
    }else{
        orderBtn.backgroundColor = [UIColor clearColor];
        [orderBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    
    if ([[dataDic objectForKey:@"status"]intValue] >= 2 && ![[dataDic objectForKey:@"status"] isEqualToString:@"60"])
    {
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 108;
        orderInfoView.frame = rect;
        self.sendCompany.hidden = NO;
        self.sendID.hidden = NO;
        self.payTimeLabel.hidden = NO;
        self.shippingTime.hidden = NO;
        self.receiveTime.hidden = NO;
        
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
    }

    //取消状态
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"-100"]) {
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 48;
        orderInfoView.frame = rect;
        self.cancelReson.hidden = NO;
        self.cancelTime.hidden = NO;
        

        self.cancelReson.frame = CGRectMake(0, sellerSayLabel.frame.size.height + sellerSayLabel.frame.origin.y + 5, SCREEN_WIDTH, 12);
        self.cancelTime.frame = CGRectMake(0, self.cancelReson.frame.size.height + self.cancelReson.frame.origin.y + 8, SCREEN_WIDTH, 12);
        
        NSString * cancelStr = [dataDic objectForKey:@"cancelnote"];
        NSString * cancelTime = [dataDic objectForKey:@"canceltime"];
        if (cancelStr.length == 0 || [cancelStr isEqualToString:@""] || cancelStr == nil|| [cancelStr isEqualToString:@"0"]) {
            cancelStr = @"无";
        }
        if (cancelTime.length == 0 || [cancelTime isEqualToString:@""] || cancelTime == nil) {
            cancelTime = @"无";
        }
        
        self.cancelReson.contentLabel.text = cancelStr;
        self.cancelTime.contentLabel.text = cancelTime;
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
    }
    
    
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"5"]||[[dataDic objectForKey:@"status"] isEqualToString:@"51"])
    {
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 48;
        orderInfoView.frame = rect;
        self.cancelReson.hidden = NO;
        self.cancelTime.hidden = NO;
        
        
        totalPrice.frame = CGRectMake(SCREEN_WIDTH - 15 - 150, orderInfoView.frame.origin.y + orderInfoView.frame.size.height + 30, 150, 18);
        NSString * cancelStr = [dataDic objectForKey:@"backnote"];
        if (cancelStr.length == 0 || [cancelStr isEqualToString:@""] || cancelStr == nil|| [cancelStr isEqualToString:@"0"]) {
            cancelStr = @"无";
        }
        self.cancelReson.contentLabel.text = cancelStr;
        NSString * cancelTimeStr = [dataDic objectForKey:@"backtime"];
        if (cancelTimeStr.length == 0 || [cancelTimeStr isEqualToString:@""] || cancelTimeStr == nil) {
            cancelTimeStr = @"无";
        }
        self.cancelTime.contentLabel.text = cancelTimeStr;
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
    }
}
- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)popSwipe:(UIScreenEdgePanGestureRecognizer *)swipe
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

//- (void)pushViewController:(UIViewController *)controller
//{
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        
//    }
//}

#pragma mark - 初始化控件
- (void)customInit
{
//    if (is_IOS_7) {
//        UIScreenEdgePanGestureRecognizer * popSwipe = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(popSwipe:)];
//        [popSwipe setEdges:UIRectEdgeLeft];
//        [self.view addGestureRecognizer:popSwipe];
//    }
    

    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    mainScroll = [[UIScrollView alloc]init];
    mainScroll.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    [self.view addSubview:mainScroll];
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, 310+40+90 +79);
    
    UIFont * fonts = SIZE_FOR_12;
    //UIScreenEdgePanGestureRecognizer
//=================================地址背景view=====================================
    addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 94)];
    addressView.backgroundColor = [GetColor16 hexStringToColor:@"#888888"];
    [mainScroll addSubview:addressView];
    //收件人
    ZZOrderCustomView * reUserName = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 21)];
    
    reUserName.titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    reUserName.contentLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    CGRect frame = reUserName.titleLabel.frame;
    frame.size.width = 75;
    frame.size.height = 21;
    reUserName.titleLabel.frame = frame;
    
    CGRect contFrame = reUserName.contentLabel.frame;
    contFrame.size.height = 21;
    reUserName.contentLabel.frame = contFrame;
    
    reUserName.titleLabel.text = @"收货人:";
    reUserName.titleLabel.font = [UIFont systemFontOfSize:18];
    reUserName.contentLabel.font = [UIFont systemFontOfSize:18];
    self.reUserName = reUserName;
    [addressView addSubview:reUserName];
    
    //买家手机号
    ZZOrderCustomView * phoneLabel = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, reUserName.frame.size.height + reUserName.frame.origin.y + 9, SCREEN_WIDTH, 16)];
    phoneLabel.titleLabel.font = SIZE_FOR_14;
    phoneLabel.contentLabel.font = SIZE_FOR_14;
    phoneLabel.titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    phoneLabel.contentLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    self.phoneLabel = phoneLabel;
    phoneLabel.titleLabel.text = @"联系电话:";
    [addressView addSubview:phoneLabel];
    
    //买家地址
    UILabel *addressLB1 = [[UILabel alloc] initWithFrame:CGRectMake(15, phoneLabel.frame.size.height + phoneLabel.frame.origin.y + 10, 70, 14)];
    addressLB1.text = @"收货地址:";
    addressLB1.font = SIZE_FOR_14;
    addressLB1.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [addressView addSubview:addressLB1];
    
    self.addressLB2 = [[MyLabel alloc] initWithFrame:CGRectMake( addressLB1.frame.size.width + 20, addressLB1.frame.origin.y, SCREEN_WIDTH - 70 - 20 - 15, 16)];
    self.addressLB2.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    self.addressLB2.font = SIZE_FOR_14;
    self.addressLB2.numberOfLines = 0;
    self.addressLB2.verticalAlignment = VerticalAlignmentTop;
//    self.addressLB2.lineBreakMode = NSLineBreakByWordWrapping;
    [addressView addSubview:self.addressLB2];
//==================================================================================
    
//================================商品背景view=======================================
    
    topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, addressView.frame.size.height + addressView.frame.origin.y + 15, SCREEN_WIDTH, 120)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [mainScroll addSubview:topBGView];
    
    //----
    UIView * sellerPersonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    sellerPersonView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [topBGView addSubview:sellerPersonView];
    
    UILabel * sellerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 6, SCREEN_WIDTH - 15 - 22, 17)];
    self.sellerNameLabel = sellerNameLabel;
    sellerNameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    sellerNameLabel.font = SIZE_FOR_14;
    [sellerPersonView addSubview:sellerNameLabel];
    
    UITapGestureRecognizer * sellerPersonTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sellerPersonTap:)];
    [sellerPersonView addGestureRecognizer:sellerPersonTap];
    
    UIImageView * detailImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 7, 12, 7, 7)];
    detailImg.image = [UIImage imageNamed:@"detail_jt"];
    [sellerPersonView addSubview:detailImg];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sellerNameLabel.frame.size.height + sellerNameLabel.frame.origin.y + 7, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [sellerPersonView addSubview:lineView];
    
    //----商品图片
    UIView * goodsView = [[UIView alloc]initWithFrame:CGRectMake(0, lineView.frame.size.height + lineView.frame.origin.y, SCREEN_WIDTH, 90)];
    [topBGView addSubview:goodsView];
    
    UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
    imgview.userInteractionEnabled = YES;
    imgview.contentMode = UIViewContentModeScaleAspectFill;
    imgview.clipsToBounds = YES;
    self.imageview = imgview;
    [goodsView addSubview:imgview];
    //----
    MyLabel * goodsNameLabel = [[MyLabel alloc]initWithFrame:CGRectMake(imgview.frame.size.width + imgview.frame.origin.x + 12, imgview.frame.origin.y, topBGView.frame.size.width - 15 - 60 - 12 - 15 - 76, 60)];
    self.orderTitleLabel = goodsNameLabel;
    goodsNameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    goodsNameLabel.verticalAlignment = VerticalAlignmentTop;
    goodsNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    goodsNameLabel.numberOfLines = 0;
    goodsNameLabel.font = fonts;
    [goodsView addSubview:goodsNameLabel];
    //----
    UILabel * goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 76, goodsNameLabel.frame.origin.y , 76, 14)];
    goodsPriceLabel.font = SIZE_FOR_14;
    self.goodsPriceLabel = goodsPriceLabel;
    goodsPriceLabel.textAlignment = NSTextAlignmentRight;
    goodsPriceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [goodsView addSubview:goodsPriceLabel];

    //----商品数量
    UILabel * goodsNum = [[UILabel alloc]initWithFrame:CGRectMake(topBGView.frame.size.width - 55, imgview.frame.origin.y + imgview.frame.size.height - 12, 40, 12)];
    self.goodsNumLabel = goodsNum;
    goodsNum.textColor = [GetColor16 hexStringToColor:@"#959595"];
    goodsNum.textAlignment = NSTextAlignmentRight;
    goodsNum.font = SIZE_FOR_12;
    [goodsView addSubview:goodsNum];
    
    UITapGestureRecognizer *tapToDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDetail:)];
    [imgview addGestureRecognizer:tapToDetail];
//====================================================================================


//=================================订单金额,运费,配送方式================================
    postMethodView = [[UIView alloc]initWithFrame:CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y + 15, SCREEN_WIDTH, 81)];
    postMethodView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [mainScroll addSubview:postMethodView];
    
    //配送方式
    UILabel * sendMethod = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 100, 15)];
    sendMethod.text = @"配送方式:";
    sendMethod.textColor = [GetColor16 hexStringToColor:@"#434343"];
    sendMethod.font = [UIFont systemFontOfSize:15];
    [postMethodView addSubview:sendMethod];
    
    UILabel * sendMethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 120, sendMethod.frame.origin.y, 120, 15)];
    self.sendMethodLabel = sendMethodLabel;
    sendMethodLabel.textAlignment = NSTextAlignmentRight;
    sendMethodLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    sendMethodLabel.font = [UIFont systemFontOfSize:15];
    [postMethodView addSubview:sendMethodLabel];
    
    //分割线
    UIView * methodLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    methodLineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [postMethodView addSubview:methodLineView];
    
    //运费
    UILabel * sendPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, methodLineView.frame.size.height + methodLineView.frame.origin.y + 12, 100, 14)];
    sendPriceLabel.text = @"运费:";
    sendPriceLabel.font = SIZE_FOR_14;
    sendPriceLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [postMethodView addSubview:sendPriceLabel];
    
    UITextField * sendPostText = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, sendPriceLabel.frame.origin.y, 100, 14)];
    sendPostText.font = SIZE_FOR_14;
    sendPostText.enabled = NO;
    sendPostText.textColor = [GetColor16 hexStringToColor:@"#434343"];
    sendPostText.textAlignment = NSTextAlignmentRight;
    self.sendPostText = sendPostText;
    [postMethodView addSubview:sendPostText];
    
    //分割线1
    UIView * amountLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, SCREEN_WIDTH, 1)];
    amountLineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [postMethodView addSubview:amountLineView];
    
    UILabel * topTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, amountLineView.frame.size.height + amountLineView.frame.origin.y + 12.5, 170, 15)];
    topTitleLabel.font = [UIFont systemFontOfSize:15];
    topTitleLabel.text = @"实付款（含运费）:";
    topTitleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [postMethodView addSubview:topTitleLabel];
    //成交金额
    UITextField * priceLabel = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 135, topTitleLabel.frame.origin.y - 1, 120, 18)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceText = priceLabel;
    priceLabel.enabled = NO;
    priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    priceLabel.font = [UIFont systemFontOfSize:18];
    [postMethodView addSubview:priceLabel];
    
    
    UIView * sendLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 80.5, SCREEN_WIDTH, 0.5)];
    sendLineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [postMethodView addSubview:sendLineView];
    
    
    
//====================================================================================
    
//====================================订单信息=========================================
    //订单信息背景
    orderInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, postMethodView.frame.size.height + postMethodView.frame.origin.y + 15, SCREEN_WIDTH, 88)];
    orderInfoView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [mainScroll addSubview:orderInfoView];

    
    //订单号
    ZZOrderCustomView * orderNum = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 12)];
    orderNum.titleLabel.text = @"订单号:";
    self.orderIDLabel = orderNum;
    [orderInfoView addSubview:orderNum];
    
    //创建时间
    ZZOrderCustomView * createTimeLabel = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, orderNum.frame.size.height + orderNum.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    createTimeLabel.titleLabel.text = @"创建时间:";
    self.createTimeLabel = createTimeLabel;
    [orderInfoView addSubview:createTimeLabel];
    
    //担保人
    ZZOrderCustomView * danBaoRen = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, createTimeLabel.frame.size.height + createTimeLabel.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    danBaoRen.hidden = YES;
    danBaoRen.titleLabel.text = @"担保人:";
    self.danBaoRen = danBaoRen;
    [orderInfoView addSubview:danBaoRen];
    
    //担保理由
    ZZOrderCustomView * danBaoReason = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, danBaoRen.frame.size.height + danBaoRen.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    danBaoReason.hidden = YES;
    danBaoReason.titleLabel.text = @"担保理由:";
    self.danBaoReason = danBaoReason;
    [orderInfoView addSubview:danBaoReason];
    
    //担保时间
    ZZOrderCustomView * danBaoTime = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, danBaoReason.frame.size.height + danBaoReason.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    danBaoTime.hidden = YES;
    danBaoTime.titleLabel.text = @"担保时间:";
    self.danBaoTime = danBaoTime;
    [orderInfoView addSubview:danBaoTime];

    //买家留言
    //    ZZOrderCustomView * buyerSay = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, sellerSay.frame.size.height + sellerSay.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    //    buyerSay.titleLabel.text = @"买家留言:";
    //    self.buyerSay = buyerSay;
    //    [orderInfoView addSubview:buyerSay];
    
    buyerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, createTimeLabel.frame.size.height + createTimeLabel.frame.origin.y + 8, 70, 12)];
    buyerLabel.text = @"买家留言:";
    buyerLabel.font = SIZE_FOR_12;
    buyerLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [orderInfoView addSubview:buyerLabel];
    
    buyerSayLabel = [[UILabel alloc]initWithFrame:CGRectMake(buyerLabel.frame.size.width + buyerLabel.frame.origin.x + 5, buyerLabel.frame.origin.y, SCREEN_WIDTH - 70 - 15 - 15 - 5, 12)];
    buyerSayLabel.font = SIZE_FOR_12;
    buyerSayLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    buyerSayLabel.numberOfLines = 0;
    [orderInfoView addSubview:buyerSayLabel];
    
    
    //订单附言
//    ZZOrderCustomView * sellerSay = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 12)];
//    sellerSay.titleLabel.text = @"卖家留言:";
//    self.sellerSay = sellerSay;
//    [orderInfoView addSubview:sellerSay];

    
    sellerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, buyerSayLabel.frame.size.height + buyerSayLabel.frame.origin.y + 8, 70, 12)];
    sellerLabel.text = @"卖家留言:";
    sellerLabel.font = SIZE_FOR_12;
    sellerLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [orderInfoView addSubview:sellerLabel];
    
    sellerSayLabel = [[UILabel alloc]initWithFrame:CGRectMake(sellerLabel.frame.size.width + sellerLabel.frame.origin.x + 5, sellerLabel.frame.origin.y, SCREEN_WIDTH - 70 - 15 - 15 - 5, 12)];
    sellerSayLabel.font = SIZE_FOR_12;
    sellerSayLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    sellerSayLabel.numberOfLines = 0;
    [orderInfoView addSubview:sellerSayLabel];
    
    
    //支付时间
    ZZOrderCustomView * payTimeLabel = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, sellerSayLabel.frame.size.height + sellerSayLabel.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    payTimeLabel.titleLabel.text = @"支付时间:";
    payTimeLabel.hidden = YES;
    self.payTimeLabel = payTimeLabel;
    [orderInfoView addSubview:payTimeLabel];
    
    //发货时间
    ZZOrderCustomView * shippingTime = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, payTimeLabel.frame.size.height + payTimeLabel.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    shippingTime.titleLabel.text = @"发货时间:";
    shippingTime.hidden = YES;
    self.shippingTime = shippingTime;
    [orderInfoView addSubview:shippingTime];
    
//    //支付宝单号
//    ZZOrderCustomView * alipayNum = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, createTimeLabel.frame.size.height + createTimeLabel.frame.origin.y + 8, SCREEN_WIDTH, 12)];
//    alipayNum.hidden = YES;
//    alipayNum.titleLabel.text = @"支付保单号:";
//    self.alipayNum = alipayNum;
//    [orderInfoView addSubview:alipayNum];
    
    //快递公司
    ZZOrderCustomView * sendCompany = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, shippingTime.frame.size.height + shippingTime.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    sendCompany.titleLabel.text = @"配送公司:";
    sendCompany.hidden = YES;
    self.sendCompany = sendCompany;
    [orderInfoView addSubview:sendCompany];
    
    //快递单号
    ZZOrderCustomView * sendID = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, sendCompany.frame.size.height + sendCompany.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    sendID.titleLabel.text = @"配送单号:";
    sendID.hidden = YES;
    self.sendID = sendID;
    [orderInfoView addSubview:sendID];
    
    //收货时间
    ZZOrderCustomView * receiveTime = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, sendID.frame.size.height + sendID.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    receiveTime.titleLabel.text = @"收货时间:";
    receiveTime.hidden = YES;
    self.receiveTime = receiveTime;
    [orderInfoView addSubview:receiveTime];
    
    //退款原因
    ZZOrderCustomView * cancelReson = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, sendID.frame.size.height + sendID.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    cancelReson.titleLabel.text = @"取消原因:";
    cancelReson.hidden = YES;
    self.cancelReson = cancelReson;
    [orderInfoView addSubview:cancelReson];
    
    //退款时间
    ZZOrderCustomView * cancelTime = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, cancelReson.frame.size.height + cancelReson.frame.origin.y + 8, SCREEN_WIDTH, 12)];
    cancelTime.titleLabel.text = @"取消时间:";
    cancelTime.hidden = YES;
    self.cancelTime = cancelTime;
    [orderInfoView addSubview:cancelTime];
    
    //总价
    totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 150, orderInfoView.frame.origin.y + orderInfoView.frame.size.height + 30, 150, 18)];
    totalPrice.textAlignment = NSTextAlignmentRight;
    totalPrice.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    totalPrice.font = [UIFont systemFontOfSize:18];
//    [mainScroll addSubview:totalPrice];
//====================================================================================
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 114, SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    bottomView.layer.masksToBounds = NO;
    bottomView.layer.shadowOpacity = 0.8;
    bottomView.layer.shadowOffset = CGSizeMake(4, -3);
    bottomView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    [self.view addSubview:bottomView];
    
    //订单状态
    UILabel * statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    statusLabel.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel = statusLabel;
    statusLabel.font = SIZE_FOR_IPHONE;
    statusLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [bottomView addSubview:statusLabel];
    
    //订单状态对应得操作
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 0, 100, 50);
    submitBtn.hidden = YES;
    [submitBtn addTarget:self action:@selector(operationFor:) forControlEvents:UIControlEventTouchUpInside];
    self.statusBtn = submitBtn;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [submitBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    [bottomView addSubview:submitBtn];
    
    //右上角button
    orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    orderBtn.frame = CGRectMake(0, 15, 60, 25);
    orderBtn.backgroundColor = WHITE;
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    orderBtn.layer.cornerRadius = 2;
    orderBtn.layer.masksToBounds = YES;
    [orderBtn addTarget:self action:@selector(orderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [orderBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = self.view.center;
    [activity setHidesWhenStopped:YES];
    [self.view addSubview:activity];
}

- (void)tapToDetail:(UITapGestureRecognizer *)tap
{
    if (isOrderDied == NO) {
        SecondSubclassDetailViewController *subDetailVC = [[SecondSubclassDetailViewController alloc] init];
        subDetailVC.idNumber = self.idNumber;
        [self.navigationController pushViewController:subDetailVC animated:YES];
    }
}

#pragma mark - 右上角button点击事件
- (void)orderBtn:(UIButton *)sender
{
    //判断状态
    //删除
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"-100"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除该订单?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        alert.tag = 100;
        [alert show];
    }else if ([[dataDic objectForKey:@"status"] isEqualToString:@"0"]){
        [self cancelPay];
    }else if ([[dataDic objectForKey:@"status"] isEqualToString:@"5"]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定同意退款?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        alert.tag = 1000;
        [alert show];
    }
}

#pragma mark - 删除订单

- (void)delOrderList
{
    NSDictionary * dic = [self parametersForDic:@"accountSetOrderDelete" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        
    }];
}

#pragma mark - 确认收货
- (void)isAgreeReGoods
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请确认包装完好" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 101;
    alert.delegate = self;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 101) {
            [self sureReGoods];
        }else if (alertView.tag == 100){
            [self delOrderList];
        }else if (alertView.tag == 1000){
            [self agreeRefun];
        }
    }
}

#pragma mark - 同意退款
- (void)agreeRefun
{
    NSDictionary * dic = [self parametersForDic:@"accountSetOrderBackAgree" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID,@"isAgree":@"1"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
    } andFailureBlock:^{
        
    }];
    
}

#pragma mark - 取消付款
- (void)cancelPay
{
    ZZCancelOrderViewController * cancelOrderVC = [[ZZCancelOrderViewController alloc]init];
    cancelOrderVC.orderID = self.orderID;
    cancelOrderVC.dataDic = dataDic;
    [self.navigationController pushViewController:cancelOrderVC animated:YES];
}

#pragma mark - 确定收货
- (void)sureReGoods
{
    NSDictionary * dic = [self parametersForDic:@"accountSetOrderTake" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self urlRequest];
            //            [self.navigationController popViewControllerAnimated:YES];
        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        
    }];
}

#pragma mark - 提交按钮对应的方法
- (void)operationFor:(UIButton *)sender
{
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"0"]) {
        [self checkOrderWithID:self.orderID];
//        if ([[dataDic objectForKey:@"confirm"] isEqualToString:@"1"]) {
//            ZZGoPayViewController * goPayVC = [[ZZGoPayViewController alloc]init];
//            goPayVC.orderModel = self.orderModel;
//            [self.navigationController pushViewController:goPayVC animated:YES];
//        }
    }if ([[dataDic objectForKey:@"status"] isEqualToString:@"2"]) {
        [self isAgreeReGoods];
    }else if ([[dataDic objectForKey:@"status"] isEqualToString:@"3"]){
        MineEvaluateViewController *vc = [[MineEvaluateViewController alloc] init];
        TosellerModel *model = [TosellerModel new];
        [model setValuesForKeysWithDictionary:dataDic];
        BuyerWaitCommentViewController * myEvaluateVC = [[BuyerWaitCommentViewController alloc]init];
        [self.navigationController pushViewController:myEvaluateVC animated:YES];
    }
}

#pragma mark - 验证是否可以支付
- (void)checkOrderWithID:(NSString *)orderID
{
    [activity startAnimating];
    NSDictionary * dic = [self parametersForDic:@"accountCheckPayOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":orderID}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            ZZGoPayViewController * goPayVC = [[ZZGoPayViewController alloc]init];
            goPayVC.orderID = self.orderID;
            NSArray * goodsArr = [dataDic objectForKey:@"goods"];
            NSDictionary * goodsDict = goodsArr[0];
            goPayVC.orderTitle = [goodsDict objectForKey:@"title"];
            //goPayVC.orderDataDic = dataDic;
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
