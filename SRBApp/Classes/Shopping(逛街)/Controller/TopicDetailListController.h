//
//  TopicDetailListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"
#import "ZZViewController.h"

typedef void (^BackBlock) (void);
typedef void (^DeleteBlock) (BussinessModel *model);

@interface TopicDetailListController : ZZViewController<UITextFieldDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)BussinessModel *sourceModal;
@property (nonatomic, strong)NSString *modelId;

@property (nonatomic, strong)BackBlock backBlock;
@property (nonatomic, strong)DeleteBlock deleteBlock;

- (IBAction)praiseBtnClicked:(id)sender;
- (IBAction)collectBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
- (IBAction)shareBtnClicked:(id)sender;

@end
