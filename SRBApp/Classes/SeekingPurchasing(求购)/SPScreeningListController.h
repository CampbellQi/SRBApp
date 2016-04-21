//
//  SPScreeningCollectionController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
typedef void (^CompleteBlock) (NSString *minMoney, NSString *maxMoney, NSString *shopLand);
#import "SPScreeningListController.h"
#import "SRBBaseViewController.h"

@interface SPScreeningListController : SRBBaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
- (IBAction)resetBtnClicked:(id)sender;
- (IBAction)ensureBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, copy)CompleteBlock completeBlock;
@end
