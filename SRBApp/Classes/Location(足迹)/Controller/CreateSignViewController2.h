//
//  CreateSignViewController2.h
//  SRBApp
//
//  Created by fengwanqi on 15/12/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"



typedef void (^SignCompleteBlock) (NSMutableArray *signArray);

@interface CreateSignViewController2 : SRBBaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *selectedSignArray;
@property (weak, nonatomic) IBOutlet UILabel *msgLbl;
- (IBAction)addBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *signTF;

@property (nonatomic, copy)SignCompleteBlock completeBlock;
-(id)initWithFooterPrint;
-(id)initWithTopic;
@end
