//
//  ZZGoPayViewController2.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/19.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface ZZGoPayViewController : SRBBaseViewController
//地址
@property (strong, nonatomic) IBOutlet UIView *logisticsView;
@property (weak, nonatomic) IBOutlet UILabel *userLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
//订单
@property (strong, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *brandLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *transPriceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLbl;
//付款方式
@property (strong, nonatomic) IBOutlet UIView *payStyleView;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;
- (IBAction)payselBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *contentSV;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (nonatomic,strong)NSString * orderID;
@property (nonatomic,strong)NSString * orderTitle;
- (IBAction)payLaterBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *blackView;
- (IBAction)confirmPayClicked:(id)sender;
@end
