//
//  OrderCancelController.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/28.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define ORDERCANCEL_SP_TYPE 0
#define ORDERCANCEL_HSP_TYPE 1

#import <UIKit/UIKit.h>
#import "SRBBaseViewController.h"

typedef void (^CompletedBlock) (void);

@interface OrderCancelController : SRBBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *serviceTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *reasonTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextView *memoTV;
@property (weak, nonatomic) IBOutlet UILabel *alertMsgLbl;

@property (weak, nonatomic) IBOutlet UIScrollView *contentSV;
- (IBAction)serviceBtn:(id)sender;
- (IBAction)reasonBtn:(id)sender;

@property (nonatomic, assign)int type;
@property (nonatomic, strong)NSString *spOrderID;
@property (nonatomic, strong)NSString *alertMsg;
@property (nonatomic, strong)NSString *price;

@property (nonatomic, copy)CompletedBlock completedBlock;
@end
