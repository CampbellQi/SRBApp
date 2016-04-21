//
//  TakingOrdersController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BussinessModel.h"

enum StyleType{
    HelpPurchasing,
    SpotGoods
};

typedef void (^TakingTypeBlock) (enum StyleType styleType);
@interface TakingOrdersController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnPurchasing;
@property (weak, nonatomic) IBOutlet UIButton *btnGoods;

@property (nonatomic, strong)BussinessModel *sourceModel;
- (IBAction)helpPurchasingBtnClicked:(id)sender;
- (IBAction)spotGoodsBtnClicked:(id)sender;

@property (nonatomic, copy)TakingTypeBlock takingTypeBlock;
@end
