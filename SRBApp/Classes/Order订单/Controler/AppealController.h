//
//  FeedbackController.h
//  tusstar
//
//  Created by fengwanqi on 15/7/15.
//  Copyright (c) 2015年 zxk. All rights reserved.
//

#import "ZZViewController.h"
#import "CTAssetsPickerController.h"

typedef void (^BackBlock) (void);

@interface AppealController :ZZViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,CTAssetsPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *photoSV;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UIView *mobileBgView;
@property (weak, nonatomic) IBOutlet UITextField *reasonTF;
@property (weak, nonatomic) IBOutlet UIView *reasonSuperView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentSV;

@property (nonatomic, copy)BackBlock backBlock;

@property (nonatomic, strong)NSString * spOrderID;
@end
