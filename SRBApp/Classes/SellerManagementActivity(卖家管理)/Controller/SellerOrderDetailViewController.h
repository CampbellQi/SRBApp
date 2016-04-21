//
//  SellerOrderDetailViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "SellerManagementModel.h"
#import "ZZOrderCustomView.h"
#import "MyLabel.h"

@interface SellerOrderDetailViewController : ZZViewController
{
    MBProgressHUD * HUD;
    LoadImg * loadImg;
}
//@property (nonatomic,strong)SellerManagementModel * orderModel;
@property (nonatomic,strong)NSString * orderID;
@property (nonatomic,strong)UIImageView * imageview;
@property (nonatomic,strong)ZZOrderCustomView * orderIDLabel;   //订单ID
@property (nonatomic,strong)ZZOrderCustomView * createTimeLabel;//创建时间
@property (nonatomic,strong)ZZOrderCustomView * payTimeLabel;   //支付时间
@property (nonatomic,strong)ZZOrderCustomView * phoneLabel;     //买家手机号
@property (nonatomic,strong)ZZOrderCustomView * addressLabel;   //买家地址
@property (nonatomic,strong)ZZOrderCustomView * reUserName;     //收件人
@property (nonatomic,strong)ZZOrderCustomView * buyerSay;       //订单附言
@property (nonatomic,strong)ZZOrderCustomView * sellerSay;      //卖家留言
@property (nonatomic,strong)ZZOrderCustomView * goodsTotalPrice;//商品总额
@property (nonatomic,strong)ZZOrderCustomView * sendCompany;    //快递公司
@property (nonatomic,strong)ZZOrderCustomView * sendID;         //快递单号
@property (nonatomic,strong)ZZOrderCustomView * cancelReson;    //取消原因
@property (nonatomic,strong)ZZOrderCustomView * cancelTime;     //取消时间
@property (nonatomic,strong)ZZOrderCustomView * sellerBeizhu;   //卖家备注
@property (nonatomic,strong)ZZOrderCustomView * danBaoRen;      //担保人
@property (nonatomic,strong)ZZOrderCustomView * alipayNum;      //支付保单号
@property (nonatomic,strong)ZZOrderCustomView * danBaoTime;      //担保时间
@property (nonatomic,strong)ZZOrderCustomView * danBaoReason;      //担保理由
@property (nonatomic,strong)ZZOrderCustomView * shippingTime;      //发货时间
@property (nonatomic,strong)ZZOrderCustomView * receiveTime;      //收货时间


//------
@property (nonatomic,strong)MyLabel * orderTitleLabel;  //订单标题
@property (nonatomic,strong)UITextField * priceText;       //成交额
@property (nonatomic,strong)UILabel * goodsNumLabel;    //商品数量
@property (nonatomic,strong)UILabel * goodsPriceLabel;  //商品价格
@property (nonatomic,strong)UILabel * sellerNameLabel;  //卖家昵称
@property (nonatomic,strong)UILabel * timeLabel;        //成交时间
@property (nonatomic,strong)UITextField * sendPostText; //运费
@property (nonatomic,strong)UILabel * statusLabel;      //订单状态
@property (nonatomic,strong)UIButton * statusBtn;       //订单状态对应的操作
@property (nonatomic,strong)UILabel * sendMethodLabel;       //配送方式
@property (nonatomic,strong)UITextView * sellerSayText;    //卖家留言
@property (nonatomic,strong)UIView * sellerSayView;         //卖家留言背景

@property (nonatomic,strong)NSString *idNumber;    //商品id
//- (void)urlRequest;
@end
