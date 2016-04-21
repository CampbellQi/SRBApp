//
//  AccountCommentViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/1/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
 typedef void(^MyBlock)(id result);
@interface AccountCommentViewController : ZZViewController<UITextFieldDelegate>
@property (nonatomic, retain)UITextView * textField;
@property (nonatomic, retain)NSString * idNumber;

@property (nonatomic ,copy)MyBlock block;

- (void)sendMessage:(MyBlock)jgx;
@end
