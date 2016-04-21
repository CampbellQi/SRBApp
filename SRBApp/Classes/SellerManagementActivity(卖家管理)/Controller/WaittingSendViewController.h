//
//  WaittingSendViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "SellerOrderDetailViewController.h"

typedef void (^BackBlock) (void);

@interface WaittingSendViewController : ZZViewController<UITextFieldDelegate>
@property (nonatomic,strong)NSString * orderId;
@property (nonatomic,assign)BOOL isModify;
@property (nonatomic,strong)SellerOrderDetailViewController * sellerOrderVC;

@property (nonatomic, strong)NSString *invoiceName;
@property (nonatomic, strong)NSString *invoiceNo;

@property (nonatomic, copy)BackBlock backBlock;
@end
