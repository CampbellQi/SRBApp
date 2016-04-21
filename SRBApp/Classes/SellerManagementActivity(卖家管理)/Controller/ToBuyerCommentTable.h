//
//  ToBuyerCommentTable.h
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "TosellerModel.h"
#import "SellerEvaluateListActivityCell.h"
#import "NoDataView.h"

@interface ToBuyerCommentTable : UITableViewController
{
    NSMutableArray * dataArray;
    NSMutableArray * TotalArray;
    NoDataView * noData;
}
- (void)urlRequestPost;
@end
