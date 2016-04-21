//
//  ZZMyOrderViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "UIButton+ZZImgAndText.h"
#import "ZZOrderModel.h"
#import "ZZOrderCustomCell.h"
#import "ZZOrderGoodsModel.h"
#import "MJRefresh.h"
#import "ZZOrderCustomBtn.h"
#import "ZZOrderDetailViewController.h"
#import "ZZGoPayViewController.h"
//#import "GUAAlertView.h"
/**
 *  @brief  买家订单列表
 */
@interface ZZMyOrderViewController : ZZViewController
{
    ZZOrderCustomBtn * allBtn;          //全部
    ZZOrderCustomBtn * waitPaybtn;      //待付款
    ZZOrderCustomBtn * waitSendBtn;     //待发货
    ZZOrderCustomBtn * waitRebtn;       //待收货
    ZZOrderCustomBtn * waitSayBtn;      //待评论
    UITableView * tableview;            //
    NoDataView * noData;
    
}
@property (nonatomic, strong)NSString * status;         //订单类型
@property (nonatomic,strong)NSMutableArray * dataArr;   //数据数组
@property (nonatomic,strong)NSMutableArray * dicArr;

- (void)backBtn:(UIButton *)sender;
@end
