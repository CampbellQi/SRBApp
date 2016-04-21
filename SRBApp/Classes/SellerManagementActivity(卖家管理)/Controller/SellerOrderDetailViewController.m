//
//  SellerOrderDetailViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SellerOrderDetailViewController.h"
#import <UIImageView+WebCache.h>
#import "SellerCancelOrderViewController.h"
#import "WaittingSendViewController.h"
#import "WaitCommentViewController.h"
#import "SecondSubclassDetailViewController.h"
#import "SubViewController.h"
#import "UITextField+MyText.h"

@interface SellerOrderDetailViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>

@end

@implementation SellerOrderDetailViewController
{
    NSDictionary * dataDic;
    UIButton * orderBtn;     //右上角button
    UIScrollView * mainScroll;
    UIView * orderInfoView;
    UIButton * confirmBtn;
    UIView * confirmView;
    UIImageView * confirmImg;
    UILabel * totalPrice;   //总价(运费)
    NSString * goodsAmountPrice;
    BOOL isClick;
    NSDictionary * goodsDic;
    UIView * addressView;
    UIView * postMethodView;
    UIView * topBGView;
    UILabel * buyerSayLabel;
    UILabel * sellerSayLabel;
    UILabel * sellerLabel;
    MyLabel * addressLB2;  //地址
    UILabel * buyerLabel;
    UILabel * textTempLabel;
    BOOL _canedit;
    BOOL isOrderDied;           //订单是否失效
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer * viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnkey)];
    [self.view addGestureRecognizer:viewTap];
    self.title = @"订单详情";
    //初始化控件
    [self customInit];
    //网络请求
//    [self urlRequest];
}

- (void)returnkey
{
    [self.view endEditing:YES];
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
    //获取用户名和密码
    //拼接post请求参数
    NSDictionary * dic = [self parametersForDic:@"sellerGetOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID}];
    //发送请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        //如果获取成功且有数据
        if ([result isEqualToString:@"0"]) {
            dataDic = [dic objectForKey:@"data"];
            [self makeDataToKongjian];
            isOrderDied = NO;
        }else{
            if (![result isEqualToString:@"4"]){
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

- (void)buyerTap:(UITapGestureRecognizer *)tap
{
    if (isOrderDied == NO) {
        SubViewController * personVC = [[SubViewController alloc]init];
        personVC.myRun = @"2";
        personVC.account = [dataDic objectForKey:@"buyername"];
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
    
    CGRect rect = [[dataDic objectForKey:@"address"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 85 - 15 -15, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
    CGRect addressLB2Fram = addressLB2.frame;
    addressLB2Fram.size.height = rect.size.height;
    addressLB2.frame = addressLB2Fram;
    
    CGRect buyerRect = [[dataDic objectForKey:@"postscript"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70 - 15 - 15 - 5, 40000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_12} context:nil];
    CGRect sellerRect = [[dataDic objectForKey:@"toBuyer"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70 - 15 - 15 - 5, 40000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_12} context:nil];
    
    
    if ([dataDic objectForKey:@"guarantorname"] != nil && ![[dataDic objectForKey:@"guarantorname"] isEqualToString:@""] && [[dataDic objectForKey:@"guarantorname"] length] != 0) {
        self.danBaoReason.hidden = NO;
        self.danBaoRen.hidden = NO;
        self.danBaoTime.hidden = NO;
        buyerLabel.frame = CGRectMake(15, self.danBaoTime.frame.size.height + self.danBaoTime.frame.origin.y + 8, 70, 14);
        buyerSayLabel.frame = CGRectMake(buyerLabel.frame.size.width + buyerLabel.frame.origin.x + 5, buyerLabel.frame.origin.y, SCREEN_WIDTH - 70 - 15 - 15 - 5, 14);
    }else{
        buyerLabel.frame = CGRectMake(15, self.createTimeLabel.frame.size.height + self.createTimeLabel.frame.origin.y + 8, 70, 12);
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

    addressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 82 + rect.size.height);
    topBGView.frame = CGRectMake(0, addressView.frame.size.height + addressView.frame.origin.y + 15, SCREEN_WIDTH, 90+30);
    postMethodView.frame = CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y + 15, SCREEN_WIDTH, 122);
    
    if ([dataDic objectForKey:@"guarantorname"] != nil && ![[dataDic objectForKey:@"guarantorname"] isEqualToString:@""] && [[dataDic objectForKey:@"guarantorname"] length] != 0) {
        orderInfoView.frame = CGRectMake(0, postMethodView.frame.size.height + postMethodView.frame.origin.y + 15, SCREEN_WIDTH, 116 + sellerSayLabel.frame.size.height + buyerSayLabel.frame.size.height);
    }else{
        orderInfoView.frame = CGRectMake(0, postMethodView.frame.size.height + postMethodView.frame.origin.y + 15, SCREEN_WIDTH, 56 + sellerSayLabel.frame.size.height + buyerSayLabel.frame.size.height);
    }
    
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 50, orderInfoView.frame.size.height + orderInfoView.frame.origin.y + 15, 50, 25);
    
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
//==============================================================================
    self.phoneLabel.contentLabel.text = [dataDic objectForKey:@"mobile"];
    addressLB2.text = [dataDic objectForKey:@"address"];
    self.reUserName.contentLabel.text = [dataDic objectForKey:@"contacterName"];
//==============================================================================
    //商品图片
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[tempdic objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    self.imageview.clipsToBounds = YES;
    //商品名称
    self.orderTitleLabel.text = [tempdic objectForKey:@"title"];
    //卖家名字
    self.sellerNameLabel.text = [NSString stringWithFormat:@"买家:%@",[dataDic objectForKey:@"buyernick"]];
    //商品价格
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[tempdic objectForKey:@"price"]];
    //商品数量
    self.goodsNumLabel.text = [NSString stringWithFormat:@"x%@",[tempdic objectForKey:@"num"]];
    //商品id
    self.idNumber = [tempdic objectForKey:@"id"];
    
//==============================================================================
    //运费
    self.sendPostText.text = [NSString stringWithFormat:@"¥ %@",[dataDic objectForKey:@"transportPrice"]];
    //配送方式
    self.sendMethodLabel.text = [dataDic objectForKey:@"shippingName"];
    //商品金额
    self.priceText.text = [NSString stringWithFormat:@"¥ %@",[dataDic objectForKey:@"orderAmount"]];
    goodsAmountPrice = [dataDic objectForKey:@"goodsAmount"];
//==============================================================================
    
    
//==============================================================================
   
//==============================================================================
    //买家留言
    NSString * buyerStr = [dataDic objectForKey:@"postscript"];
    if ([buyerStr isEqualToString:@"0"] || buyerStr == nil || buyerStr.length == 0) {
        buyerStr = @"无";
    }
    buyerSayLabel.text = buyerStr;
    
    //卖家留言
    NSString * sellerStr = [dataDic objectForKey:@"toBuyer"];
    if ([sellerStr isEqualToString:@"0"] || [sellerStr isEqualToString:@""] || sellerStr == nil) {
        sellerStr = @"无";
    }else{
        self.sellerSayText.text = sellerStr;
        textTempLabel.hidden = YES;
    }
    sellerSayLabel.text = sellerStr;
        
    //订单号
    self.orderIDLabel.contentLabel.text = [dataDic objectForKey:@"orderNum"];
    //成交时间
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

    //合计
    totalPrice.text = [NSString stringWithFormat:@"合计:¥ %.2f",[[dataDic objectForKey:@"orderAmount"] floatValue]+[[dataDic objectForKey:@"transportPrice"] floatValue]];
    
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
    
    
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"5"] || [[dataDic objectForKey:@"status"] intValue]>= 51) {
        self.cancelReson.titleLabel.text = @"退款原因";
        self.cancelTime.titleLabel.text = @"退款时间";
    }
    
    if ([[dataDic objectForKey:@"status"]intValue] >= 2 && ![[dataDic objectForKey:@"status"] isEqualToString:@"60"])
    {
        self.sendCompany.hidden = NO;
        self.sendID.hidden = NO;
        self.payTimeLabel.hidden = NO;
        self.shippingTime.hidden = NO;
        self.receiveTime.hidden = NO;
        
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 108;
        orderInfoView.frame = rect;
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
    }
    
    if ([[dataDic objectForKey:@"status"] isEqualToString:@
         "1"])
    {
        self.statusBtn.hidden = NO;
        [self.statusBtn setTitle:@"去发货" forState:UIControlStateNormal];
        self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, 50);
        
        self.payTimeLabel.hidden = NO;
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 28;
        orderInfoView.frame = rect;
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
    }else if ([[dataDic objectForKey:@"status"]isEqualToString:@
               "3"]){
        //待评价
        self.statusBtn.hidden = NO;
        [self.statusBtn setTitle:@"去评价" forState:UIControlStateNormal];
        self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, 50);
    }else if ([[dataDic objectForKey:@"status"] isEqualToString:@"60"]){
        self.payTimeLabel.hidden = NO;
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 28;
        orderInfoView.frame = rect;
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
        self.statusBtn.hidden = YES;
        self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    }else if ([[dataDic objectForKey:@"status"]intValue] >= 4) {
        self.statusBtn.hidden = YES;
        self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    }else if ([[dataDic objectForKey:@"status"]isEqualToString:@
               "-100"]){
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 48;
        orderInfoView.frame = rect;
        self.cancelReson.hidden = NO;
        self.cancelTime.hidden = NO;
        
        self.cancelReson.frame = CGRectMake(0, sellerSayLabel.frame.size.height + sellerSayLabel.frame.origin.y + 5, SCREEN_WIDTH, 12);
        self.cancelTime.frame = CGRectMake(0, self.cancelReson.frame.size.height + self.cancelReson.frame.origin.y + 8, SCREEN_WIDTH, 12);
        
        NSString * cancelStr = [dataDic objectForKey:@"cancelnote"];
        NSString * cancelTime = [dataDic objectForKey:@"canceltime"];
        if (cancelStr.length == 0 || [cancelStr isEqualToString:@""] || cancelStr == nil || [cancelStr isEqualToString:@"0"]) {
            cancelStr = @"无";
        }
        if (cancelTime.length == 0 || [cancelTime isEqualToString:@""] || cancelTime == nil) {
            cancelTime = @"无";
        }
        
        self.cancelReson.contentLabel.text = cancelStr;
        self.cancelTime.contentLabel.text = cancelTime;
        
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
        self.statusBtn.hidden = YES;
        self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    }else{
        self.statusBtn.hidden = YES;
        self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    }
    //设置状态
    self.statusLabel.text = [NSString stringWithFormat:@"当前状态：%@",[dataDic objectForKey:@"statusName"]];
    
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"5"]||[[dataDic objectForKey:@"status"] isEqualToString:@"51"]) {
        CGRect rect = orderInfoView.frame;
        rect.size.height = orderInfoView.frame.size.height + 48;
        orderInfoView.frame = rect;
        self.cancelReson.hidden = NO;
        self.cancelTime.hidden = NO;
        NSString * cancelStr = [dataDic objectForKey:@"backnote"];
        NSString * cancelTime = [dataDic objectForKey:@"backtime"];
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
    
    [self.statusBtn setTitle:[dataDic objectForKey:@"statusName"] forState:UIControlStateNormal];
    
    //如果状态是待付款,重置控件状态
    if ([[dataDic objectForKey:@"status"]isEqualToString:@"0"]) {
        
        CGRect rect = orderInfoView.frame;
        
//        if ([[dataDic objectForKey:@"confirm"] isEqualToString:@"1"]) {
//            self.sendPostText.enabled = NO;
//            //运费
//            self.sendPostText.text = [NSString stringWithFormat:@"¥ %@",[dataDic objectForKey:@"transportPrice"]];
//            self.sellerSayView.hidden = YES;
//            sellerSayLabel.hidden = NO;
//            sellerLabel.hidden = NO;
//        }else{
            self.statusBtn.hidden = NO;
            self.statusBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.statusBtn setTitle:@"修改运费" forState:UIControlStateNormal];
            self.statusLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, 50);
            self.sendPostText.enabled = YES;
            self.sendPostText.borderStyle = UITextBorderStyleRoundedRect;
            //运费
            self.sendPostText.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"transportPrice"]];
            self.sellerSayView.hidden = NO;
            sellerSayLabel.hidden = NO;
            sellerLabel.hidden = NO;
            self.sellerSayView.frame = CGRectMake(0, postMethodView.frame.size.height + postMethodView.frame.origin.y + 15, SCREEN_WIDTH, 60);
            rect.origin.y = self.sellerSayView.frame.size.height + self.sellerSayView.frame.origin.y + 15;
//        }
        
        if ([dataDic objectForKey:@"guarantorname"] != nil && ![[dataDic objectForKey:@"guarantorname"] isEqualToString:@""] && [[dataDic objectForKey:@"guarantorname"] length] != 0) {
//            if ([[dataDic objectForKey:@"confirm"]isEqualToString:@"1"]) {
                rect.size.height = 120 + buyerSayLabel.frame.size.height + sellerSayLabel.frame.size.height;
//            }else{
//                rect.size.height = 120 + buyerSayLabel.frame.size.height;
//            }
        }else{
//            if ([[dataDic objectForKey:@"confirm"]isEqualToString:@"1"]) {
                rect.size.height = 60 + buyerSayLabel.frame.size.height + sellerSayLabel.frame.size.height;
//            }else{
//                rect.size.height = 60 + buyerSayLabel.frame.size.height;
//            }
        }
        orderInfoView.frame = rect;
        
//        if ([[dataDic objectForKey:@"confirm"] isEqualToString:@"1"]) {
//            mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + 65);
//        }else{
            mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressView.frame.size.height + topBGView.frame.size.height + postMethodView.frame.size.height + orderInfoView.frame.size.height + self.sellerSayView.frame.size.height + 75);
//        }
        
        [self.sendPostText addTarget:self action:@selector(sendDidChange:) forControlEvents:UIControlEventEditingChanged];
    }else{
        self.sendPostText.enabled = NO;
        self.sendPostText.borderStyle = UITextBorderStyleNone;
    }
    
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"-100"]) {
        orderBtn.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [orderBtn setTitle:@"删 除" forState:UIControlStateNormal];
    }else if ([[dataDic objectForKey:@"status"] isEqualToString:@"2"] || [[dataDic objectForKey:@"status"] isEqualToString:@"3"] || [[dataDic objectForKey:@"status"] isEqualToString:@"1"] || [[dataDic objectForKey:@"status"] isEqualToString:@"60"]){
        [orderBtn setTitle:@"退 款" forState:UIControlStateNormal];
        orderBtn.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    }else{
        [orderBtn setTitle:@"" forState:UIControlStateNormal];
        orderBtn.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - 监听验证码输入框键盘
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self moveView:-110];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self moveView:110];
}

#pragma mark - textview 代理
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        textTempLabel.hidden = YES;
    }else{
        textTempLabel.hidden = NO;
    }
    NSString * toBeString = textView.text;
    
    NSString * lang = [[UITextInputMode currentInputMode]primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [textView markedTextRange];
        UITextPosition * position = [textView positionFromPosition:selectedRange.start offset:0];
        __block int chNum = 0;
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            
            NSData * tempData = [substring dataUsingEncoding:NSUTF8StringEncoding];
            if ([tempData length] == 3) {
                chNum ++;
            }
        }];
        if (chNum >= 100) {
            _canedit = NO;
        }
        if (!position) {
            if (toBeString.length > 100) {
                textView.text = [toBeString substringToIndex:100];
                _canedit = YES;
            }
        }
    }
    else{
        if (toBeString.length > 100) {
            textView.text = [toBeString substringToIndex:100];
            _canedit = NO;
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    const char * ch=[text cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        _canedit = YES;
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (toBeString.length <= 100) {
        _canedit = YES;
    }
    if (_canedit == NO) {
        return NO;
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.sellerSayText];
    [self urlRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}


#pragma mark - textField 代理
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveView:-80];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self moveView:80];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)moveView:(float)move
{
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.view.frame;
    frame.origin.y += move;//view的x轴上移
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - 监听输入框
- (void)priceDidChange:(id)sender
{
    UITextField * text = (UITextField *)sender;
    totalPrice.text = [NSString stringWithFormat:@"合计¥%.2f",[text.text floatValue]+ [self.sendPostText.text floatValue]];
}
- (void)sendDidChange:(id)sender
{
    UITextField * text = (UITextField *)sender;
//    totalPrice.text = [NSString stringWithFormat:@"合计¥%.2f",[text.text floatValue]+ [self.priceText.text floatValue]];
    //priceTotal
    CGFloat  priceTotal = [[goodsDic objectForKey:@"priceTotal"] floatValue];
    self.priceText.text = [NSString stringWithFormat:@"¥%.2f",[text.text floatValue]+ priceTotal];
}
- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapToDetail:(UITapGestureRecognizer *)tap
{
    if (isOrderDied == NO) {
        SecondSubclassDetailViewController *subDetailVC = [[SecondSubclassDetailViewController alloc] init];
        subDetailVC.idNumber = self.idNumber;
        [self.navigationController pushViewController:subDetailVC animated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSRange tempRange = [textField selectedRange];
    
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    
    if(*ch == 0)
        return YES;
    if( *ch != 46 && ( *ch<48 || *ch>57) )
        return NO;
    
    if([textField.text rangeOfString:@"."].length==1)
    {
        if(*ch == 0)
            return YES;
        NSUInteger length=[textField.text rangeOfString:@"."].location;
        
        
        //小数点后面两位小数 且不能再是小数点
        
        if([[textField.text substringFromIndex:length] length]>2 || *ch ==46){   //3表示后面小数位的个数。。
            if (tempRange.location <= length) {
                if ([[textField.text substringToIndex:length] length] < 4 && (*ch >= 48 && *ch <= 57) && *ch != 46) {
                    return YES;
                }else{
                    return NO;
                }
            }else{
                return NO;
            }
        }else{
            if (tempRange.location > length) {
                return YES;
            }else{
                if ([[textField.text substringToIndex:length] length] < 4 && (*ch >= 48 && *ch <= 57) && *ch != 46) {
                    return YES;
                }else{
                    return NO;
                }
            }
        }
    }
    
    if(range.location>3){
        if ([string isEqualToString:@"."]) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)sender
{
//    UITextField * field = (UITextField *)sender;
//    const char * ch = [[field.text substringWithRange:NSMakeRange(field.text.length - 1, 1)] cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    if ([[field.text substringWithRange:NSMakeRange(field.text.length - 1, 1)]isEqualToString:@" "] || ((*ch < 48) && *ch != 46) || ((*ch > 57) && *ch != 46)) {
//        if (field.text.length > 0) {
//            field.text = [field.text substringToIndex:field.text.length - 1];
//        }
//    }
//    if (field.text.length > 4 && [field.text rangeOfString:@"."].location==NSNotFound) {
//        field.text = [field.text substringToIndex:field.text.length - 1];
//    }
}

#pragma mark - 初始化控件
- (void)customInit
{
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    mainScroll.delegate = self;
    [self.view addSubview: mainScroll];
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, 526);
    
    [mainScroll addHeaderWithTarget:self action:@selector(urlRequest)];
    
    UIFont * fonts = SIZE_FOR_12;
    
//===============================地址背景view====================================
    addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 94)];
    addressView.backgroundColor = [GetColor16 hexStringToColor:@"#888888"];
    [mainScroll addSubview:addressView];
    //收件人
    ZZOrderCustomView * reUserName = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 18)];
    reUserName.titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    reUserName.contentLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    CGRect frame = reUserName.titleLabel.frame;
    frame.size.width = 75;
    frame.size.height = 18;
    reUserName.titleLabel.frame = frame;
    CGRect contFrame = reUserName.contentLabel.frame;
    contFrame.size.height = 18;
    reUserName.contentLabel.frame = contFrame;
    
    reUserName.titleLabel.text = @"收货人:";
    reUserName.titleLabel.font = [UIFont systemFontOfSize:17];
    reUserName.contentLabel.font = [UIFont systemFontOfSize:17];
    self.reUserName = reUserName;
    [addressView addSubview:reUserName];
    
    //买家手机号
    ZZOrderCustomView * phoneLabel = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, reUserName.frame.size.height + reUserName.frame.origin.y + 12, SCREEN_WIDTH, 16)];
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
    
    addressLB2 = [[MyLabel alloc] initWithFrame:CGRectMake(addressLB1.frame.size.width + 20, addressLB1.frame.origin.y, SCREEN_WIDTH - 70 - 20 -15, 16)];
    addressLB2.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    addressLB2.font = SIZE_FOR_14;
    addressLB2.numberOfLines = 0;
    [addressLB2 setVerticalAlignment:VerticalAlignmentTop];
//    self.addressLB2.lineBreakMode = NSLineBreakByWordWrapping;
    [addressView addSubview:addressLB2];

//======================================================================

//===========================商品背景view=================================
    topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, addressView.frame.size.height + addressView.frame.origin.y + 15, SCREEN_WIDTH, 90+30)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [mainScroll addSubview:topBGView];
    
    //----
    UIView * sellerPersonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    sellerPersonView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [topBGView addSubview:sellerPersonView];
    
    //----
    UILabel * sellerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 6, SCREEN_WIDTH - 15 - 22, 17)];
    self.sellerNameLabel = sellerNameLabel;
    sellerNameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    sellerNameLabel.font = SIZE_FOR_14;
    [sellerPersonView addSubview:sellerNameLabel];
    
    UITapGestureRecognizer * buyerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyerTap:)];
    [sellerPersonView addGestureRecognizer:buyerTap];
    
    
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
    
    //--
    MyLabel * goodsNameLabel = [[MyLabel alloc]initWithFrame:CGRectMake(imgview.frame.size.width + imgview.frame.origin.x + 12, imgview.frame.origin.y, topBGView.frame.size.width - 15 - 60 - 12 - 15 - 76, 60)];
    self.orderTitleLabel = goodsNameLabel;
    goodsNameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    goodsNameLabel.verticalAlignment = VerticalAlignmentTop;
    goodsNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    goodsNameLabel.numberOfLines = 0;
    goodsNameLabel.font = fonts;
    [goodsView addSubview:goodsNameLabel];
    
    //----价格
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
    
//======================================================================
    
//=============================订单金额,运费,配送方式=======================
    postMethodView = [[UIView alloc]initWithFrame:CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y + 15, SCREEN_WIDTH, 122)];
    postMethodView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [mainScroll addSubview:postMethodView];
    
    //配送方式
    UILabel * sendMethod = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 80, 15)];
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
    UILabel * sendPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, methodLineView.frame.size.height + methodLineView.frame.origin.y + 12, 60, 15)];
    sendPriceLabel.text = @"运费:";
    sendPriceLabel.font = [UIFont systemFontOfSize:15];
    sendPriceLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [postMethodView addSubview:sendPriceLabel];
    
    UITextField * sendPostText = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, methodLineView.frame.size.height + methodLineView.frame.origin.y + 5, 100, 30)];
    sendPostText.font = SIZE_FOR_IPHONE;
    sendPostText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    sendPostText.delegate = self;
    sendPostText.enabled = NO;
    sendPostText.returnKeyType = UIReturnKeyDone;
    sendPostText.textColor = [GetColor16 hexStringToColor:@"#434343"];
    sendPostText.textAlignment = NSTextAlignmentRight;
    [sendPostText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.sendPostText = sendPostText;
    [postMethodView addSubview:sendPostText];
    
    UIView * sendLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 80.5, SCREEN_WIDTH, 0.5)];
    sendLineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [postMethodView addSubview:sendLineView];
    
    //分割线1
    UIView * amountLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, SCREEN_WIDTH, 1)];
    amountLineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [postMethodView addSubview:amountLineView];
    
    
    UILabel * topTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, amountLineView.frame.size.height + amountLineView.frame.origin.y + 13, 170, 15)];
    topTitleLabel.font = [UIFont systemFontOfSize:15];
    topTitleLabel.text = @"实付款（含运费）:";
    topTitleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [postMethodView addSubview:topTitleLabel];
    //成交金额
    UITextField * priceLabel = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 135, topTitleLabel.frame.origin.y - 2, 120, 20)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceText = priceLabel;
    priceLabel.enabled = NO;
    priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    priceLabel.font = [UIFont systemFontOfSize:18];
    [postMethodView addSubview:priceLabel];
    
    //卖家留言
    UIView * sellerSayView = [[UIView alloc]initWithFrame:CGRectMake(0, postMethodView.frame.size.height + postMethodView.frame.origin.y + 15, SCREEN_WIDTH, 60)];
    sellerSayView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    self.sellerSayView = sellerSayView;
    sellerSayView.hidden = YES;
    [mainScroll addSubview:sellerSayView];
    
    UITextView * sellerSayText = [[UITextView alloc]initWithFrame:CGRectMake(10 ,0, SCREEN_WIDTH - 20, 60)];
    sellerSayText.font = SIZE_FOR_14;
    sellerSayText.returnKeyType = UIReturnKeyDone;
    self.sellerSayText = sellerSayText;
    sellerSayText.delegate = self;
    [sellerSayView addSubview:sellerSayText];
    
    textTempLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 200, 14)];
    textTempLabel.text = @"对买家说点什么吧";
    textTempLabel.font = SIZE_FOR_14;
    textTempLabel.textColor = [GetColor16 hexStringToColor:@"#c9c9c9"];
    [sellerSayText addSubview:textTempLabel];

//==============================================================================
    
//=================================订单信息======================================
    //订单信息背景
    orderInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, postMethodView.frame.size.height + postMethodView.frame.origin.y + 15, SCREEN_WIDTH, 90)];
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
    danBaoRen.titleLabel.text = @"担保人:";
    danBaoRen.hidden = YES;
    self.danBaoRen = danBaoRen;
    [orderInfoView addSubview:danBaoRen];
    
    //担保理由
    ZZOrderCustomView * danBaoReason = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, danBaoRen.frame.size.height + danBaoRen.frame.origin.y + 8, SCREEN_WIDTH, 14)];
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
    
    
    //订单附言
//    ZZOrderCustomView * buyerSay = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 12)];
//    buyerSay.contentLabel.numberOfLines = 0;
//    buyerSay.titleLabel.text = @"买家留言：";
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
    
    //卖家留言
//    ZZOrderCustomView * sellerSay = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, buyerSayLabel.frame.size.height + buyerSayLabel.frame.origin.y + 8, SCREEN_WIDTH, 12)];
//    sellerSay.contentLabel.numberOfLines = 0;
//    sellerSay.titleLabel.text = @"卖家留言：";
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
    
    //快递公司
    ZZOrderCustomView * sendCompany = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, payTimeLabel.frame.size.height + payTimeLabel.frame.origin.y + 8, SCREEN_WIDTH, 12)];
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
    
//    //支付宝单号
//    ZZOrderCustomView * alipayNum = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, createTimeLabel.frame.size.height + createTimeLabel.frame.origin.y + 8, SCREEN_WIDTH, 12)];
//    alipayNum.hidden = YES;
//    alipayNum.titleLabel.text = @"支付保单号：";
//    self.alipayNum = alipayNum;
//    [orderInfoView addSubview:alipayNum];
    
    //退款原因
    ZZOrderCustomView * cancelReson = [[ZZOrderCustomView alloc]initWithFrame:CGRectMake(0, receiveTime.frame.size.height + receiveTime.frame.origin.y + 8, SCREEN_WIDTH, 12)];
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
//==============================================================================

//    //卖家确认按钮
//    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [confirmBtn setTitle:@"提 交" forState:UIControlStateNormal];
//    [confirmBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
//    confirmBtn.layer.cornerRadius = 2;
//    confirmBtn.layer.masksToBounds = YES;
//    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"qianfen"] forState:UIControlStateNormal];
//    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"fenhong"] forState:UIControlStateNormal];
//    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 50, orderInfoView.frame.size.height + orderInfoView.frame.origin.y + 15, 60, 25);
//    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];
//    confirmBtn.hidden = YES;
//    [mainScroll addSubview:confirmBtn];
    
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
    
    //提交按钮
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 0, 100, 50);
    [submitBtn addTarget:self action:@selector(operationForSeller:) forControlEvents:UIControlEventTouchUpInside];
    self.statusBtn = submitBtn;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [submitBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    [bottomView addSubview:submitBtn];
    
//    //卖家确认
//    confirmView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 114, SCREEN_WIDTH, 50)];
//    confirmView.hidden = YES;
//    confirmView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
//    [self.view addSubview:confirmView];
//    
//    UIImageView * noConfirmImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 17, 15, 15)];
//    noConfirmImg.image = [UIImage imageNamed:@"detail_checkbox_nor"];
//    [confirmView addSubview:noConfirmImg];
//    
//    confirmImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 17, 15, 15)];
//    confirmImg.hidden = YES;
//    confirmImg.image = [UIImage imageNamed:@"detail_checkbox_cehecked"];
//    [confirmView addSubview:confirmImg];
//    
//    UILabel * confirmLabel = [[UILabel alloc]initWithFrame:CGRectMake(confirmImg.frame.size.width + confirmImg.frame.origin.x + 5, 17, 130, 16)];
//    confirmLabel.font = SIZE_FOR_IPHONE;
//    confirmLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
//    confirmLabel.text = @"确定买家可以付款";
//    [confirmView addSubview:confirmLabel];
//    
//    UITapGestureRecognizer * confirmTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmTap:)];
//    [confirmView addGestureRecognizer:confirmTap];
    
    
    
//==============================================================================
    //右上角button
    orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    orderBtn.frame = CGRectMake(0, 15, 60, 25);
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    orderBtn.backgroundColor = WHITE;
    orderBtn.layer.cornerRadius = 2;
    orderBtn.layer.masksToBounds = YES;
    [orderBtn addTarget:self action:@selector(orderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [orderBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    
    
}

- (void)confirmTap:(UITapGestureRecognizer *)tap
{
    isClick = !isClick;
    if (isClick) {
        confirmImg.hidden = NO;
    }else{
        confirmImg.hidden = YES;
    }
}

#pragma mark - 卖家确认按钮
- (void)confirmBtn:(UIButton *)sender
{
//    if (!isClick) {
//        [AutoDismissAlert autoDismissAlert:@"还没勾选买家可付款呢~"];
//        return;
//    }
    
}

#pragma mark - 右上角button点击事件
- (void)orderBtn:(UIButton *)sender
{
    //判断状态
    //删除
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"-100"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除该订单?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 100;
        [alert show];
    }else{
        SellerCancelOrderViewController * sellerCancelVC = [[SellerCancelOrderViewController alloc]init];
        sellerCancelVC.dataDic = dataDic;
        sellerCancelVC.orderID = self.orderID;
        sellerCancelVC.sellerOrderVC = self;
        [self.navigationController pushViewController:sellerCancelVC animated:YES];
    }
}

#pragma mark - 删除订单
- (void)delOrderList
{
    NSDictionary * dic = [self parametersForDic:@"sellerSetOrderDelete" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID}];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 100) {
            [self delOrderList];
        }
    }
}

#pragma mark - 提交按钮对应的方法
- (void)operationForSeller:(UIButton *)sender
{
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"0"]) {
        

            [HUD removeFromSuperview];
      
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"提交中,请稍后";
            HUD.dimBackground = YES;
            [HUD show:YES];
            //运费和商品金额
            //NSString * goodsAmount = [self.priceText.text substringFromIndex:0];
            NSString * transportPrice = self.sendPostText.text;
            //过滤空格,以及判断留言是否为空
            NSString * sellerSay = [self.sellerSayText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (sellerSay == nil || sellerSay.length == 0) {
                sellerSay = @"";
            }
            sellerSay = [sellerSay stringByReplacingOccurrencesOfString:@"\n" withString:@""] == nil || [sellerSay stringByReplacingOccurrencesOfString:@"\n" withString:@""].length == 0? @"" : sellerSay;
            
        NSDictionary * dic = [self parametersForDic:@"sellerSetOrderModify" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID,@"remark":@"123@s.com",@"confirm":@"1",@"goodsAmount":goodsAmountPrice,@"transportPrice":transportPrice,@"toBuyer":sellerSay}];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
            [HUD hide:YES];
            [HUD removeFromSuperview];
        } andFailureBlock:^{
            [HUD hide:YES];
            [HUD removeFromSuperview];
        }];
        
    }else if ([[dataDic objectForKey:@"status"] isEqualToString:@"1"]){
        WaittingSendViewController * waitSendVC = [[WaittingSendViewController alloc]init];
        waitSendVC.orderId = [dataDic objectForKey:@"orderId"];
        [self.navigationController pushViewController:waitSendVC animated:YES];
    }else if ([[dataDic objectForKey:@"status"] isEqualToString:@"3"]){
        WaitCommentViewController * sellerEvaluateVC = [[WaitCommentViewController alloc]init];
        [self.navigationController pushViewController:sellerEvaluateVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
