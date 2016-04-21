//
//  WQPasswordInput.h
//  testPwdInput
//
//  Created by fengwanqi on 16/1/20.
//  Copyright © 2016年 fengwanqi. All rights reserved.
//
#define PWDI_HEIGHT 132
#import <UIKit/UIKit.h>

@interface WQPasswordInput : UIView
- (IBAction)confirmClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *inputPwdTF;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lineLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end
