//
//  InputController.h
//  testMark
//
//  Created by fengwanqi on 15/10/14.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TPMarkModel.h"
#import "WQMarkView.h"

typedef void (^CompleteBlock) (TPMarkModel *model);

@interface InputMarkController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *countryTF;
@property (weak, nonatomic) IBOutlet UITextField *brandTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *currencyTF;
@property (weak, nonatomic) IBOutlet UIScrollView *superSV;
- (IBAction)comleteClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;

- (IBAction)deleteBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, copy)CompleteBlock completeBlock;

@property (nonatomic, strong)WQMarkView *sourceMarkView;

@end
