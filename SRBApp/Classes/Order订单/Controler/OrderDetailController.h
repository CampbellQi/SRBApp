//
//  OrderDetailController.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"
#import "BussinessModel.h"

typedef void (^ReloadDataBlock) (void);
typedef void (^DeleteBlock) (BussinessModel *deleteModel);
@interface OrderDetailController : SRBBaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *contentSV;
@property (weak, nonatomic) IBOutlet UIView *operateBtnSuperView;

@property (nonatomic, strong)NSString *orderID;
//@property (nonatomic, strong)NSString *status;

@property (nonatomic, copy)ReloadDataBlock reloadDataBlock;
@property (nonatomic, copy)DeleteBlock deleteBlock;

-(void)loadSPOrderDetail;
@end

