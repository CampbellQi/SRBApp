//
//  PersonalBaseSPListController.h
//  SRBApp
//  我的求购基类
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
typedef void (^ReloadNavTitle) (void);

#import "SRBBaseViewController.h"
#import "PersonalOrderOperateButton.h"

@interface PersonalBaseSPListController : SRBBaseViewController<UITableViewDataSource, UITableViewDelegate, PersonalOrderOperateButtonDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UINavigationController *currentNC;
@property (nonatomic, strong)NSString *orderStatus;
@property (nonatomic, assign)BOOL isFillings;
-(void)loadNewDataListRequest;
-(void)loadMoreDataListRequest;

-(id)initBySP;
-(id)initByHelpSP;

@property (nonatomic, copy)ReloadNavTitle reloadNavTitle;
@end
