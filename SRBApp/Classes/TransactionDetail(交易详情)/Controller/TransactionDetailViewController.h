//
//  TransactionDetailViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "GuaranteeNumImageView.h"

@interface TransactionDetailViewController : ZZViewController
{
    MBProgressHUD * HUD;
    LoadImg * loadImg;
}
@property (nonatomic,strong)NSString * goodsID;
//求购单id
@property (nonatomic,strong)NSString * spOrderID;
@property (nonatomic,copy)NSString * goodsNum;  //库存
@property (nonatomic, strong)NSString * postSign;
@property (nonatomic, strong)NSString * shurenNum;
@property (nonatomic ,strong)NSString * danbaoNum;
@property (nonatomic, strong)NSString * account;
@property (nonatomic, strong)NSString * friendsign;
@property (nonatomic,strong)GuaranteeNumImageView * guaranTeeView;  //担保人;
- (void)getAddressUrlRequest;
@end
