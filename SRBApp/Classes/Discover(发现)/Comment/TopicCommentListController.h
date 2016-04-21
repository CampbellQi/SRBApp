//
//  TopicCommentListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZViewController.h"
#import "BussinessModel.h"

typedef void (^BackBlock) (void);

@interface TopicCommentListController : ZZViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)BussinessModel *sourceModel;
@property (nonatomic, strong)NSString *modelID;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIImageView *nodataIV;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong)NSString *navTitle;

@property (assign, nonatomic)BOOL isCommon;
@property (nonatomic, copy)BackBlock backBlock;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)sendClicked:(id)sender;
@end
