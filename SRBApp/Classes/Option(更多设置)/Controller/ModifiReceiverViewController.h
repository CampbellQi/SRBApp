//
//  ModifiReceiverViewController.h
//  SRBApp
//
//  Created by lizhen on 14/12/31.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifiReceiverViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *receiveGoodsTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextView *addressTV;         //地址框

@property (nonatomic, strong) NSString *receiver;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *iD;
@property (nonatomic, strong) NSString *isdefault;  //判断是否是默认地址


@end
