//
//  SellerEvaluateListActivityViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "TosellerModel.h"
#import "ToBuyerCommentTable.h"
#import "FromBuyerCommentTable.h"
/**
 *  @brief  卖家评价列表
 */
@interface SellerEvaluateListActivityViewController : ZZViewController
{ 
    UITableView * tableview;
    NSMutableArray * dataArray;
    NSMutableArray * imgArr;
    UIButton * toBuyerBtn;
    UIButton * toSellerBtn;
    UIView * lineView;
    MBProgressHUD * HUD;
}
@property (nonatomic,copy)NSString * commentType;
@property (nonatomic, strong) ToBuyerCommentTable *toBuyerTVC;
@property (nonatomic, strong) FromBuyerCommentTable *fromBuyerTVC;
@property (nonatomic, strong) UIScrollView *sv;
- (void)toBuyerBtn:(UIButton *)sender;
- (void)toSellerBtn:(UIButton *)sender;
- (void)backBtn:(UIButton *)sender;

@end
