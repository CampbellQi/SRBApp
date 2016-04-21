//
//  PersonalBaseHelpSPListCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"

typedef void (^ChatBlock) (BussinessModel *chatModel);
typedef void (^AvaterIVBlock) (NSString *account);
typedef void (^GoodsSuperViewTapBlock) (BussinessModel *goodsModel);

@interface PersonalBaseSPListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *rolLbl;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *brandLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIView *operateSuperView;
@property (weak, nonatomic) IBOutlet UIView *ContentBgView;

@property (nonatomic, strong)BussinessModel *sourceModel;

@property (weak, nonatomic) IBOutlet UILabel *roleLbl;
- (IBAction)chatBtnClicked:(id)sender;
@property (nonatomic, strong)UIViewController *currentVC;

@property (nonatomic, copy)ChatBlock chatBlock;

@property (nonatomic, copy)AvaterIVBlock avaterIVBlock;
@property (nonatomic, copy)GoodsSuperViewTapBlock goodsSuperViewTapBlock;
@property (weak, nonatomic) IBOutlet UIView *goodsSuperView;
@end
