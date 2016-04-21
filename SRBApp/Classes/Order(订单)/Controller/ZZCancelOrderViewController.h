//
//  ZZCancelOrderViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/20.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZOrderModel.h"

@interface ZZCancelOrderViewController : ZZViewController
{
    UIButton * cancelBtn;
    MBProgressHUD * HUD;
}
//@property (nonatomic,strong)ZZOrderModel * orderModel;
@property (nonatomic,strong)NSString * orderID;
@property (nonatomic,strong)UILabel * resonLabel;
@property (nonatomic,strong)UIImageView * imgView;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong)UILabel * otherResonLabel;
@property (nonatomic,strong)UILabel * orderIDLabel;
@property (nonatomic,strong)UILabel * priceLabel;
@property (nonatomic,strong)UIView * textBGView;
@property (nonatomic,strong)UILabel * cancelLabel;
@property (nonatomic,strong)NSDictionary * dataDic;
- (void)customInit;
@end
