//
//  BuildNewReceiveViewController.h
//  SRBApp
//
//  Created by lizhen on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BackBlock) (void);
@class ReceiveModel;


@interface BuildNewReceiveViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong)ReceiveModel *sourceModel;
@property (nonatomic, copy)BackBlock backBlock;
@property (nonatomic, strong)NSString *navTitle;
@end
