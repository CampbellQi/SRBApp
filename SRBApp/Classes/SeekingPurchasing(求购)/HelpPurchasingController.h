//
//  HelpPurchasingController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "BussinessModel.h"
#import <CoreLocation/CoreLocation.h>
#import "SRBBaseViewController.h"
#import "ZYQAssetPickerController.h"

@interface HelpPurchasingController : SRBBaseViewController<UITextFieldDelegate, UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate,UIActionSheetDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *superSV;
//报价
@property (weak, nonatomic) IBOutlet UITextField *priceTF;

//押金
@property (weak, nonatomic) IBOutlet UITextField *depositTF;
@property (weak, nonatomic) IBOutlet UITextField *shoplandTF;
//预计发货时间
@property (weak, nonatomic) IBOutlet UITextField *deliveryTimeTF;
@property (weak, nonatomic) IBOutlet UITextView *memoTV;
@property (weak, nonatomic) IBOutlet UIScrollView *photosScrollView;
@property (weak, nonatomic) IBOutlet UIButton *postitionBtn;
- (IBAction)positionBtnClicked:(id)sender;
@property (nonatomic, strong)BussinessModel *sourceModel;
@end
