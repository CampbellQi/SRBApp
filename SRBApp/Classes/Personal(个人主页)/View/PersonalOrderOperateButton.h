//
//  PersonalOrderOperateButton.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BussinessModel.h"

#define 求购单 操作状态定义
#define CANCEL @"10"
//取消求购-退款
//#define CANCEL_REFUND @"11"
#define REFRESH @"12"
#define DELETE @"13"
#define RESP @"14"
//发布商品催单
#define REMINDER_GOODS @"15"
//采购催单
#define REMINDER_PIC @"16"
//发货催单
#define REMINDER_TACK @"17"
//拒绝（接单）
#define REJECT @"18"
//查看
#define SCAN @"19"
//--待发货
//提醒发货
#define REMIND_DELIVERY @"20"
//--待收货
//查看物流
#define VIEW_LOGISTICS @"21"
//确认收货
#define CONFIRM_RECEIPT @"22"
//--待评价
//评价
#define EVALUATION @"23"
//查看(不可购买)
#define SCAN_CANNOTBUY @"24"
//取消求购(付完押金)
#define CANCEL_REFUND_PAYED_DEPOSIT @"25"
//取消求购(付完款)
#define CANCEL_REFUND_PAYED_PRICE @"26"
//申诉(已取消)
#define APPEAL @"27"
//拒绝(已取消)
#define REJECT_CANCEL @"28"
//同意(已取消)
#define AGREE @"29"
//改价(代付款)
#define CHANGETHEPRICE @"30"
//付款(待付款)
#define PAY @"31"
//查看评价(已完成)
#define SCAN_EVALUATE @"32"

#define 代购单 操作状态定义
#define CANCEL_APPLY @"120"
//删除
#define HSP_DELETE @"121"
#define RE_TAKE_ORDER @"122"
//取消代购
#define HSP_CANCEL @"123"
#define QUOTE_PRICE @"124"
#define HSP_REMINDER_PAY @"125"
#define CHANGE_QUOTE @"126"
//采购成功
#define PURCHASE_SUCCESS @"127"
//采购失败
#define PURCHASE_FAILED @"128"
//--待收货
//发货
#define DELIVERY @"129"
//--待收货
//提醒收货
#define REMINDER_RECEIPT @"130"
//--待评价
//评价
#define HSPEVALUATION @"131"
//申诉(已取消)
//#define HSP_APPEAL @"132"
//同意(已取消)
#define HSP_AGREE @"133"

//查看评价(已完成)
#define HSP_SCAN_EVALUATE @"134"
//修改物流(待收货)
#define MODIFY_LOGISTICS @"135"
//删除(代购已取消)
#define HSP_CANCLE_DELETE @"136"

//申请求购单
#define RECEIVE @"230"
#define IGNORE @"231"

@protocol PersonalOrderOperateButtonDelegate <NSObject>
#pragma mark- 求购方
//删除
-(void)deleteWithBussinessModel:(BussinessModel *)bussinessModel;
//取消
-(void)cancelWithBussinessModel:(BussinessModel *)bussinessModel;
-(void)cancelPayedDepositWithBussinessModel:(BussinessModel *)bussinessModel AlertMsg:(NSString *)alertMsg;
-(void)cancelPayedPriceWithBussinessModel:(BussinessModel *)bussinessModel AlertMsg:(NSString *)alertMsg;
//再次求购
-(void)reSPWithBussinessModel:(BussinessModel *)bussinessModel;
//查看
-(void)scanWithBussinessModel:(BussinessModel *)bussinessModel;
//查看-不可购买
-(void)scanCanNotBuyWithBussinessModel:(BussinessModel *)bussinessModel;
//评价
-(void)commentWithBussinessModel:(BussinessModel *)bussinessModel;
//查看物流
-(void)viewLogistisWithBussinessModel:(BussinessModel *)bussinessModel;
//查看评价
-(void)scanEvaluateWithBussinessModel:(BussinessModel *)bussinessModel;
#pragma mark- 代购方
//商品报价
-(void)quotePriceWithBussinessModel:(BussinessModel *)bussinessModel;
//修改报价
-(void)changePriceWithBussinessModel:(BussinessModel *)bussinessModel;
//发货
-(void)deliveryWithBussinessModel:(BussinessModel *)bussinessModel;
//发货-自提
-(void)deliverySinceWithBussinessModel:(BussinessModel *)bussinessModel;
//评价
-(void)hspCommentWithBussinessModel:(BussinessModel *)bussinessModel;
//改价
-(void)changeThePriceWithBussinessModel:(BussinessModel *)bussinessModel;
//付款
-(void)payWithBussinessModel:(BussinessModel *)bussinessModel;
//查看评价
-(void)hspScanEvaluateWithBussinessModel:(BussinessModel *)bussinessModel;
#pragma mark- 代购申请
//接受
-(void)receiveWithBussinessModel:(BussinessModel *)bussinessModel;
//采购成功
-(void)purchaiseSuccessWithBussinessModel:(BussinessModel *)bussinessModel;
//刷新数据
-(void)reloadData;
//刷新数据
-(void)appealWithBussinessModel:(BussinessModel *)bussinessModel;
//取消代购
-(void)hspCancelWithBussinessModel:(BussinessModel *)bussinessModel  AlertMsg:(NSString *)alertMsg;
//余额不足
-(void)noMoneyWithBussinessModel;
-(void)modifyLogisticsWithBussinessModel:(BussinessModel *)bussinessModel;
-(void)modifyLogisticsNOWithBussinessModel:(BussinessModel *)bussinessModel;
@end


@interface PersonalOrderOperateButton : UIButton<UIAlertViewDelegate, UIActionSheetDelegate>

-(id)initWithFrame:(CGRect)frame TypeName:(NSString *)typeName BussinessModel:(BussinessModel *)bussinessModel;
//@property (nonatomic, strong)NSDictionary *typeDict;
@property (nonatomic, strong)UIViewController *currentVC;

@property (nonatomic, assign)id <PersonalOrderOperateButtonDelegate> delegate;

+(NSString *)getButtonName:(NSString *)type;
@end
