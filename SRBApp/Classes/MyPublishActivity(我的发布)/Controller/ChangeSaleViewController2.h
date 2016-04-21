//
//  ChangeSaleViewController2.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"
#import "ZYQAssetPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import "BussinessModel.h"

typedef void (^BackBlock) (void);

@interface ChangeSaleViewController2 : SRBBaseViewController<UITextFieldDelegate, UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate,UIActionSheetDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *photosScrollView;
@property (weak, nonatomic) IBOutlet UITextField *brandTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *sizeTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextView *leaveMsgTV;

//库存
@property (weak, nonatomic) IBOutlet UITextField *stockTF;
//运费
@property (weak, nonatomic) IBOutlet UITextField *freightTF;
@property (weak, nonatomic) IBOutlet UITextField *locationTF;
@property (weak, nonatomic) IBOutlet UIScrollView *superSV;
@property (weak, nonatomic) IBOutlet UILabel *noticeLbl;
@property (weak, nonatomic) IBOutlet UILabel *noticetitleLbl;
//@property (weak, nonatomic) IBOutlet UIView *noticeBgView;
@property (weak, nonatomic) IBOutlet UIImageView *noticeBgView;

//报价的求购单id
@property (nonatomic, strong)NSString *spOrderID;
@property (nonatomic, strong)NSString *goodsID;

@property (nonatomic, assign)BOOL isFromPublish;

@property (nonatomic, copy)BackBlock backBlock;

@end
