//
//  PersonalHelpSpApplyCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"

typedef void (^SpreadBlock) (UIButton *sender,BussinessModel *spreadModel);
typedef void (^ChatBlock) (BussinessModel *chatModel);
typedef void (^AvaterIVBlock) (NSString *account);
typedef void (^PhotoIVBlock) (long tapTag,BussinessModel *photosModel);

@interface PersonalHelpSpApplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLbl;
@property (weak, nonatomic) IBOutlet UILabel *roleLbl;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *coverSV;
//押金
@property (weak, nonatomic) IBOutlet UILabel *depositLbl;
//报价
@property (weak, nonatomic) IBOutlet UILabel *quotePriceLbl;
//预计代购地点
@property (weak, nonatomic) IBOutlet UILabel *shoplandLbl;
//预计发货时间
@property (weak, nonatomic) IBOutlet UILabel *deliverGoodstimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *memoLbl;
@property (weak, nonatomic) IBOutlet UIButton *memoSpreadBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIView *contentSuperView;
@property (weak, nonatomic) IBOutlet UIView *operateSuperView;

@property (nonatomic, strong)BussinessModel *sourceModel;

- (IBAction)spreadBtnClicked:(id)sender;
@property (nonatomic, strong)UIViewController *currentVC;
@property (weak, nonatomic) IBOutlet UIButton *spreadBtn;

- (IBAction)chatBtnClicked:(id)sender;
@property (nonatomic, copy)SpreadBlock spreadBlock;
@property (nonatomic, copy)ChatBlock chatBlock;

@property (nonatomic, copy)AvaterIVBlock avaterIVBlock;
@property (nonatomic, copy)PhotoIVBlock photoIVBlock;

-(void)resetCoversFrame;
-(void)hideOperateView;
@end
