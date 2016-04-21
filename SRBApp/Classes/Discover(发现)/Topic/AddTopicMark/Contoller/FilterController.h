//
//  FilterController.h
//  testImageEdit
//
//  Created by fengwanqi on 15/10/30.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "WQMarkImageView.h"

typedef void (^ComleteBlock) (UIImage *image, NSArray *marksArray);

@interface FilterController : UIViewController<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet WQMarkImageView *sourceIV;
@property (weak, nonatomic) IBOutlet UIScrollView *filterSV;
@property (weak, nonatomic) IBOutlet UILabel *markMsgLbl;
@property (weak, nonatomic) IBOutlet UIImageView *animationIV;


@property (weak, nonatomic) IBOutlet UIView *filtersSuperView;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
- (IBAction)filterBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *markBtn;
- (IBAction)markBtnClicked:(id)sender;

- (IBAction)okBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
@property (nonatomic, strong)UIImage *originalImage;

@property (nonatomic, copy)ComleteBlock comleteBlock;

@property (nonatomic, assign)int marksCount;
@end
