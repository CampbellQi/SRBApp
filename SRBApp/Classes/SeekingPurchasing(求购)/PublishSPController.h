//
//  PublishSPurchasingController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BussinessModel.h"
#import "ZYQAssetPickerController.h"
#import "TPMarkModel.h"
#import "TopicDetailModel.h"

typedef void (^BackBlock) (void);

@interface PublishSPController : ZZViewController<ZYQAssetPickerControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
//规格
@property (weak, nonatomic) IBOutlet UITextField *specificationsTF;
//数量
@property (weak, nonatomic) IBOutlet UITextField *numbersTF;

//期望到手价格
@property (weak, nonatomic) IBOutlet UITextField *expectedPriceTF;
@property (weak, nonatomic) IBOutlet UIScrollView *superSV;
@property (weak, nonatomic) IBOutlet UITextField *expectedSiteTF;
@property (weak, nonatomic) IBOutlet UITextView *leaveMsgTV;
@property (weak, nonatomic) IBOutlet UITextField *locationTF;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendsBtn;

@property (nonatomic, strong)TPMarkModel *soureMarkModel;
@property (nonatomic, strong)BussinessModel *sourceBussinessModel;

@property (nonatomic, strong)NSString *coverImageUrl;
//话题来源id
@property (nonatomic, strong)NSString *parentId;
//求购单id
@property (nonatomic, strong)NSString *causeId;

@property (nonatomic, assign)BOOL isFromPublish;

@property (nonatomic, copy)BackBlock backBlock;
- (IBAction)openUpClicked:(id)sender;

@end
