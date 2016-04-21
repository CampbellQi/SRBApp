//
//  ShoppingViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "RelationTable.h"
#import "CircleTable.h"
#import "ShopTotalViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "ShopRelationViewController.h"
#import "ShopCircleFromRelationViewController.h"

typedef void (^showBlock) (NSString * saleOrBuy,NSString * gooodsType,NSString * groupType);
/**
 *  逛街界面,包含熟人和关系两个分类(暂时不用此类)
 */
@interface ShoppingViewController : ZZViewController<UIScrollViewDelegate>
{
    UIView * lineView;
    UIButton * relationBtn;
    UIButton * circleBtn;
    UIButton * totalBtn;
    BOOL secondVC;
    BOOL thirdVC;
    NSString * searchState;
}
@property (nonatomic, strong) ShopRelationViewController *shopRelationTVC;
@property (nonatomic, strong) ShopCircleFromRelationViewController *shopCircleTVC;
@property (nonatomic, strong) ShopTotalViewController *shopTotalVC;
@property (nonatomic, strong) UIScrollView *sv;
@property (nonatomic, strong) NSString * type;  //第三方登录类型
@property (nonatomic, assign) int resultTP;       //返回结果
@property (nonatomic, strong) NSString *token;  //第三方token
@property (nonatomic, strong) NSString *uid;
@property (nonatomic,assign)BOOL isClick;
@property (nonatomic,copy)showBlock isShowBlock;

@property (nonatomic,strong)NSString * saleOrBuy;   //买卖类型
@property (nonatomic,strong)NSString * goodsType;   //商品类型
@property (nonatomic,strong)NSString * groupType;   //分组名称

@property (nonatomic,strong)NSArray * orderArr;
@property (nonatomic,strong)UIView * shaixuanView;
@property (nonatomic,strong)UIView * topBGView;
@property (nonatomic,strong)UIView * typeView;
@property (nonatomic,assign)BOOL isTypeShow;
@property (nonatomic,assign)BOOL isSquareShow;

- (void)relationBtn:(UIButton *)sender;
- (void)circleBtn:(UIButton *)sender;
//- (void)totalBtn:(UIButton *)sender;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)customInit;
@end
