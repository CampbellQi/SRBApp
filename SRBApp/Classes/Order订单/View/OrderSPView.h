//
//  OrderSPView.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSPView : UIView
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *avater1;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLbl1;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV1;
@property (weak, nonatomic) IBOutlet UILabel *brandLbl1;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl1;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl1;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl1;

@property (weak, nonatomic) IBOutlet UIImageView *avater2;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLbl2;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV2;
@property (weak, nonatomic) IBOutlet UILabel *purchasingPlaceLbl;
@property (weak, nonatomic) IBOutlet UILabel *purchasingTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *quotePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *depositeLbl;
@property (weak, nonatomic) IBOutlet UIView *superView1;
@property (weak, nonatomic) IBOutlet UIView *superView2;
@end
