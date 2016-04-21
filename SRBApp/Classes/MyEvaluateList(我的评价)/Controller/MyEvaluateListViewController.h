//
//  MyEvaluateListViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "ToSellerCommentTable.h"
#import "FromSellerViewController.h"
#import "TosellerModel.h"
/**
 *  @brief  买家评价列表
 */
@interface MyEvaluateListViewController : ZZViewController
{
    UITableView * tableview;
    NSMutableArray * dataArray;
    NSMutableArray * imgArr;
    UIButton * toBuyerBtn;
    UIButton * toSellerBtn;
    UIView * lineView;
}
@property (nonatomic, strong) UIScrollView *sv;
@property (nonatomic,strong)ToSellerCommentTable * toSellerVC;
@property (nonatomic,strong)FromSellerViewController * fromSellerVC;
- (void)backBtn:(UIButton *)sender;


@end
