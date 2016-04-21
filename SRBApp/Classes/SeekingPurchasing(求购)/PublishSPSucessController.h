//
//  PublishSPSucessController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface PublishSPSucessController : ZZViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *msgIV;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
- (IBAction)scanBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;
- (IBAction)goodsBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *topicBtn;
- (IBAction)topicBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *superSV;
@property (weak, nonatomic) IBOutlet UIView *itemSuperView;
@property (weak, nonatomic) IBOutlet UIView *topView;


@property (nonatomic, assign)BOOL isFromPublish;
@property (nonatomic, strong)NSString *name;
@end
