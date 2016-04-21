//
//  DetailActivityViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "CDRTranslucentSideBar.h"
#import "BussinessModel.h"
#import "DetailModel.h"
/**
 *  @brief  商品详情
 */
@interface DetailActivityViewController : ZZViewController<UITableViewDataSource,UITableViewDelegate,CDRTranslucentSideBarDelegate, UITextViewDelegate>
{
    MBProgressHUD *HUD;
    LoadImg * loadImg;
    BOOL isBack;
    BOOL isCommentTextView;

}
//求购单id
@property (nonatomic, strong)NSString * spOrderID;
@property (nonatomic, strong)NSString * idNumber;

@property (nonatomic, assign)BOOL canBuy;
@property (nonatomic, strong)DetailModel * model;
@property (nonatomic, strong)UITableView * tableView;
- (void)pianyi;
@end
