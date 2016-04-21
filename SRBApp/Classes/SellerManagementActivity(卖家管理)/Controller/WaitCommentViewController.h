//
//  WaitCommentViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "TosellerModel.h"
#import "WaitCommentCell.h"
#import "MJRefresh.h"
#import "ZZGoPayBtn.h"
#import "SellerEvaluateListActivityViewController.h"

@interface WaitCommentViewController : ZZViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * dataArray;
    NoDataView * noData;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)SellerEvaluateListActivityViewController * sellerEvaluateListVC;
- (void)urlRequestPost;
@end
