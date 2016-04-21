//
//  FeedbackController.h
//  tusstar
//
//  Created by fengwanqi on 15/7/15.
//  Copyright (c) 2015年 zxk. All rights reserved.
//

#import "ZZViewController.h"
#import "CTAssetsPickerController.h"

@interface ReportViewController :ZZViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,CTAssetsPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *photoSV;
//@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
//- (IBAction)typeBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *typeTF;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UIView *mobileBgView;
- (IBAction)lakaiBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *typeView;

@property (nonatomic, strong)NSString * idNumber;
@end
