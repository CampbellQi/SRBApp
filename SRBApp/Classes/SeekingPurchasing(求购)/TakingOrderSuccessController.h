//
//  TakingOrderSuccessController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/22.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface TakingOrderSuccessController : SRBBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
- (IBAction)scanBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *spBtn;
- (IBAction)spBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *topicBtn;
- (IBAction)topicBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *superSV;
@property (weak, nonatomic) IBOutlet UIView *itemSuperView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *brand;
@end
