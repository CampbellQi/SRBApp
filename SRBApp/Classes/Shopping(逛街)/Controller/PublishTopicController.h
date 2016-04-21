//
//  PublishTopicController.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "CTAssetsPickerController.h"
#import <CoreLocation/CoreLocation.h>

@interface PublishTopicController : ZZViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, CTAssetsPickerControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerTopView;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextField *markTF;
@property (weak, nonatomic) IBOutlet UITextView *descTV;
@property (weak, nonatomic) IBOutlet UITextView *locationTV;
@property (weak, nonatomic) IBOutlet UIImageView *locationSelectedIV;
@property (weak, nonatomic) IBOutlet UIButton *locationHideBtn;
@property (weak, nonatomic) IBOutlet UIView *locationSuperView;

@property (strong, nonatomic) IBOutlet UIView *footerTopView;
@property (weak, nonatomic) IBOutlet UIButton *addMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareToWeiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareToWeiXinBtn;

@property (nonatomic, strong) CLLocationManager *locMgr;
- (IBAction)hideLocationBtnClicked:(id)sender;
- (IBAction)addMoreBtnClicked:(id)sender;
- (IBAction)shareWeiXinBtnClicked:(id)sender;
- (IBAction)addMarkBtnClicked:(id)sender;
- (IBAction)shareWeiboBtnClicked:(id)sender;


@end
