//
//  OrderImageAddController.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"
#import "ZYQAssetPickerController.h"

typedef void (^BackBlock) (void);

@interface OrderImageAddController : SRBBaseViewController<UITextFieldDelegate, UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentSV;

@property (nonatomic, strong)NSString *spOrderID;
@property (nonatomic, strong)NSString *goodsID;

@property (nonatomic, copy)BackBlock backBlock;
@end
