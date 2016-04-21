//
//  PersonalBaseSPListCell.h
//  SRBApp
//  申请中
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"
#import "PersonalOrderOperateView.h"

typedef void (^HelpSpApplyTapBlock) (BussinessModel *model);
typedef void (^SpotGoodsGroomTapBlock) (BussinessModel *model);
typedef void (^GoodsTapBlock) (BussinessModel *model);

@interface PersonalBaseSPFilingsListCell : UITableViewCell
@property (nonatomic, weak)IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UIButton *grayBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinkBtn;
//代购申请头像
@property (weak, nonatomic) IBOutlet UIImageView *spAvaterIV1;
@property (weak, nonatomic) IBOutlet UIImageView *spAvaterIV2;
@property (weak, nonatomic) IBOutlet UIImageView *spAvaterIV3;
//现货推荐头像
@property (weak, nonatomic) IBOutlet UIImageView *spotGoodsAvaterIV1;
@property (weak, nonatomic) IBOutlet UIImageView *spotGoodsAvaterIV2;
@property (weak, nonatomic) IBOutlet UIImageView *spotGoodsAvaterIV3;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *brandLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
//代购申请
@property (weak, nonatomic) IBOutlet UIView *helpSPApplySuperView;
//现货推荐
@property (weak, nonatomic) IBOutlet UIView *spotGoodsGroomSuperView;
@property (nonatomic, strong)BussinessModel *sourceModel;
//代购申请数量
@property (weak, nonatomic) IBOutlet UIView *goodsSuperView;
@property (weak, nonatomic) IBOutlet UILabel *spApplyCountLbl;
//现货推荐数量
@property (weak, nonatomic) IBOutlet UILabel *spotGoodsGroomLbl;

@property (nonatomic, strong)UIViewController *currentVC;
@property (nonatomic, copy)HelpSpApplyTapBlock helpSpApplyTapBlock;
@property (nonatomic, copy)SpotGoodsGroomTapBlock spotGoodsGroomTapBlock;
@property (nonatomic, copy)GoodsTapBlock goodsTapBlock;
@property (weak, nonatomic) IBOutlet UIView *operateSuperView;

@end
