//
//  ShopRelationViewController.h
//  SRBApp
//
//  Created by lizhen on 15/2/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "BuyCell.h"
#import "SellCell.h"
#import "BussinessModel.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "DetailActivityViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "XLCycleScrollView.h"
#import "SquareCell.h"
#import "GroupModel.h"
#import "SquareModel.h"
#import "CarouselDiagram.h"
#import "SquareMoreViewController.h"

@class ShoppingViewController;

@interface ShopRelationViewController : ZZViewController
//<squareCellDelegate>
{
    UIActivityIndicatorView * activity;
}
@property (nonatomic,strong)UITableView *tabelView;
@property (nonatomic,strong)UIButton * toTopBtn;
/**
 *  @brief  类型,买和卖
 */
@property (nonatomic,strong)NSString * saleAndBuyType;
/**
 *  @brief  分类ID
 */
@property (nonatomic,strong)NSString * categoryID;
/**
 *  @brief  分组ID
 */
@property (nonatomic,copy)NSString * groupID;
/**
 *  @brief  排序方式
 */
@property (nonatomic,strong)NSString * order;
@property (nonatomic,strong)LoginViewController *loginVC;
@property (nonatomic,strong)ZZNavigationController *nav;
@property (nonatomic,strong)ShoppingViewController * shoppingVC;
/**
 *  @brief  table样式,list和square
 */
//@property (nonatomic,strong)NSString * tableState;
//@property (nonatomic,strong)NSMutableArray * groupArray;    //分组数组
//@property (nonatomic,strong)NSDictionary * addDic;      //广告
/**
 *  @brief  header的两张图片
 */
//@property (nonatomic,strong)UIImageView * imgView1;
//@property (nonatomic,strong)UIImageView * imgView2;
/**
 *  @brief  放header的view,list状态下是空
 */
//@property (nonatomic,strong)UIView * topBGView;
/**
 *  @brief  list模式的时候没有数据
 */
//@property (nonatomic,assign)BOOL isNoDataHidden;
/**
 *  @brief  square模式的时候没有数据
 */
//@property (nonatomic,assign)BOOL isSquareNoDataHidden;
@property (nonatomic,strong)NoDataView * noData;
@property (nonatomic,strong)NSMutableArray * dataArray;
/**
 *  @brief  数据为空
 */
//@property (nonatomic,assign)BOOL isNoData;

@property (nonatomic,strong)UIView * listNoDataView;

- (void)start;
- (void)urlRequestPost;
- (void)headerRefresh;
- (void)footerRefresh;
//- (void)setHeader;
- (void)huanYuan;
//- (void)adUrlPostRequest;
@end
