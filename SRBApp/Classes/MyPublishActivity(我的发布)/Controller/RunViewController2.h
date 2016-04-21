//
//  RunViewController2.h
//  tusstar
//
//  Created by fengwanqi on 15/7/1.
//  Copyright (c) 2015年 zxk. All rights reserved.
//

#import "ZZViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ZYQAssetPickerController.h"

@interface RunViewController2 : ZZViewController<UITextFieldDelegate, UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate,UIActionSheetDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *contentNumLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *photosScrollView;
@property (weak, nonatomic) IBOutlet UIView *markBgView;
@property (weak, nonatomic) IBOutlet UITextField *markTextField;
@property (nonatomic, strong) NSString * catagoryID;

@property (nonatomic,strong)NSMutableDictionary * titleDic; //标签

@property (nonatomic, strong) NSString *city;//城市

@property (nonatomic, strong) CLLocationManager *locMgr;

@property (weak, nonatomic) IBOutlet UITextField *markTF;
@property (weak, nonatomic) IBOutlet UITextView *locationTV;
@property (weak, nonatomic) IBOutlet UIImageView *locationSelectedIV;
@property (weak, nonatomic) IBOutlet UIButton *locationHideBtn;
@property (weak, nonatomic) IBOutlet UIView *locationSuperView;
- (IBAction)hideLocationBtnClicked:(id)sender;
- (IBAction)addTagsBtnClicked:(id)sender;


@end
