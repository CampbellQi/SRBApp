//
//  SPListCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/19.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"

enum ActionBtnType  {
    PostionBtn,
    OriginalTextBtn,
    ShareBtn,
    GrassBtn,
    ConsultBtn,
    SameBtn,
    TakingOrderBtn,
    DeleteOrderBtn,
    AvaterIV,
    SpreadBtn,
    CoverIV
};

typedef void (^ActionBlock) (enum ActionBtnType ActionBtnType, BussinessModel *model);
@interface BaseSPListCell : UITableViewCell

@property (nonatomic, strong)BussinessModel *sourceModel;

@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLbl;
@property (weak, nonatomic) IBOutlet UIButton *ordersBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UIButton *positionBtn;
@property (weak, nonatomic) IBOutlet UIButton *originalTextBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
//希望代购地点
@property (weak, nonatomic) IBOutlet UILabel *shoplandLbl;
@property (weak, nonatomic) IBOutlet UILabel *memoLbl;
@property (weak, nonatomic) IBOutlet UIButton *spreadMemoBtn;
@property (weak, nonatomic) IBOutlet UIButton *grassBtn;
@property (weak, nonatomic) IBOutlet UIButton *consultBtn;
@property (weak, nonatomic) IBOutlet UILabel *consultLbl;

@property (weak, nonatomic) IBOutlet UIButton *sameBtn;
@property (weak, nonatomic) IBOutlet UILabel *sameLbl;

@property (weak, nonatomic) IBOutlet UILabel *unselPointLbl;
@property (weak, nonatomic) IBOutlet UILabel *selPointLbl;
@property (weak, nonatomic) IBOutlet UIView *daysBgView;
@property (weak, nonatomic) IBOutlet UILabel *daysLbl;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UIButton *takingOrderBtn;
- (IBAction)spreadBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *spreadBtn;

@property (weak, nonatomic) IBOutlet UIView *coverSuperView;
@property (nonatomic, copy)ActionBlock actionBlock;

-(void)showMarksView;
@end
