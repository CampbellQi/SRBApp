//
//  PersonalViewController2.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/21.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface MineFragmentViewController2 : SRBBaseViewController
@property (weak, nonatomic) IBOutlet UIView *mineSuperView;
- (IBAction)settingBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *signLbl;
@property (weak, nonatomic) IBOutlet UILabel *newsLbl;
@property (weak, nonatomic) IBOutlet UILabel *collectLbl;
@property (weak, nonatomic) IBOutlet UIImageView *newsRedPointIV;
@property (weak, nonatomic) IBOutlet UIImageView *SPRedPointIV;
@property (weak, nonatomic) IBOutlet UIImageView *HSPRedPointIV;

@property (weak, nonatomic) IBOutlet UILabel *attentionLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userBgIV;
//星座
@property (weak, nonatomic) IBOutlet UILabel *constellationLbl;
//性别
@property (weak, nonatomic) IBOutlet UIImageView *sexIV;
@property (weak, nonatomic) IBOutlet UILabel *reliableLbl;
- (IBAction)spBtnClicked:(id)sender;
- (IBAction)takeOrderBtnClicked:(id)sender;
- (IBAction)goodsSpotBtnClicked:(id)sender;
- (IBAction)wallertBtnClicked:(id)sender;
- (IBAction)myNewsTap:(id)sender;
- (IBAction)myCollectionTap:(id)sender;
- (IBAction)myAttentionTap:(id)sender;
- (IBAction)userBgTap:(id)sender;

@end
