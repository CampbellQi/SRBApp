//
//  PersonalInfoController.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/25.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface PersonalInfoController : SRBBaseViewController
- (IBAction)avaterTap:(id)sender;
- (IBAction)birthdayTap:(id)sender;
- (IBAction)skinTap:(id)sender;
- (IBAction)statureTap:(id)sender;
- (IBAction)signTap:(id)sender;


- (IBAction)nicknameTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
- (IBAction)maleBtnClicked:(id)sender;
- (IBAction)femaleBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLbl;
@property (weak, nonatomic) IBOutlet UILabel *skinLbl;
@property (weak, nonatomic) IBOutlet UILabel *statureLbl;
@property (weak, nonatomic) IBOutlet UILabel *reliableRateLbl;
@property (weak, nonatomic) IBOutlet UITextView *signTV;

@end
