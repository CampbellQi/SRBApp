//
//  ChangePriceController.h
//  SRBApp
//
//  Created by fengwanqi on 15/12/1.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"
#import "SRBBaseViewController.h"

typedef void (^ReloadTableDataBlock) (void);
typedef void (^BackBlock) (void);
@interface ChangePriceController : SRBBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextField *freightTF;
@property (weak, nonatomic) IBOutlet UITextField *totalpriceTF;
@property (weak, nonatomic) IBOutlet UIView *totalView;

//@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
//- (IBAction)confirmBtnClicked:(id)sender;

@property (nonatomic, strong)BussinessModel *sourceModel;

@property (nonatomic, copy)ReloadTableDataBlock reloadTableDataBlock;
@property (nonatomic, copy)BackBlock backBlock;

@end
