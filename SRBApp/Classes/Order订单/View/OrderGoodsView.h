//
//  OrderGoodsView.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderGoodsView : UIView
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLbl;
@property (weak, nonatomic) IBOutlet UILabel *roleLbl;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *brandLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
//押金
@property (weak, nonatomic) IBOutlet UILabel *depositLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *freightLbl;
@property (weak, nonatomic) IBOutlet UILabel *realPayment;
@property (weak, nonatomic) IBOutlet UIView *goodsSuperView;

@end
