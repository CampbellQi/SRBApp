//
//  NewShoppingViewController.h
//  SRBApp
//
//  Created by zxk on 15/6/23.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"


typedef void (^showBlock) (NSString * saleOrBuy,NSString * gooodsType,NSString * groupType);

@interface NewShoppingViewController : ZZViewController

@property (nonatomic,strong)NSString * saleOrBuy;   //买卖类型
@property (nonatomic,strong)NSString * goodsType;   //商品类型
@property (nonatomic,strong)NSString * groupType;   //分组名称

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

@property (nonatomic,strong)NoDataView * noData;
@property (nonatomic,strong)UIView * listNoDataView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,copy)showBlock isShowBlock;

- (void)huanYuan;
- (void)start;
- (void)urlRequestPost;
@end
