//
//  LogisticsHeaderView.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/26.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogisticsHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *companyLbl;
@property (weak, nonatomic) IBOutlet UILabel *codeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIImageView *noLogisticsIV;

@end
