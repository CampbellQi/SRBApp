//
//  ToSellerCommentTable.h
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "TosellerModel.h"
#import "MyEvaluateListCell.h"
#import "NoDataView.h"
#import "SecondSubclassDetailViewController.h"

@interface ToSellerCommentTable : UITableViewController
{
    NSMutableArray * dataArray;
    NSMutableArray * TotalArray;
    NoDataView * noData;
}
- (void)urlRequestPost;
@end
