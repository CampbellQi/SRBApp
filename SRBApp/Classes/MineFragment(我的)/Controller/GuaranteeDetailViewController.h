//
//  GuaranteeDetailViewController.h
//  SRBApp
//
//  Created by zxk on 15/3/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "CopyLabel.h"
/**
 *  @brief  邀请担保详情
 */
@interface GuaranteeDetailViewController : ZZViewController
{
    UILabel * publishiMan;          //买家
    UILabel * bussinessInformation; //商品标题
    UITextView * detailTV;          //担保理由
    UIImageView * image;            //商品图片
    UILabel * priceLabel;           //商品价格
    UILabel * labeltext;
    UILabel * sendLabel;            //卖家
    UILabel * moneyLabel;
    UILabel * assureLabel;          //担保赏金
    NSString * xinxinnumber;
    NSString * guaranteePrice;      //担保赏金
    NSDictionary * dataDic;
    LoadImg * loadImg;              //加载
    UIView * backGViwe;
    UIImageView * smallV;
    UIView * bigV;                  //提示文字所在view
    UIView * view;
    UILabel * stateLabel;           //订单状态
}
@property (nonatomic, strong)NSString * account;
@property (nonatomic, strong)NSString * orderID;            //商品id
@property (nonatomic, strong)UIImageView * sanjiaoImageV;   //三角形
@property (nonatomic, strong)UIView * assureReasonView; //担保理由所在view
@property (nonatomic, strong)UILabel * reasonContentLabel;  //担保理由
@property (nonatomic, strong)UILabel * dateLabel;           //担保时间
@property (nonatomic, strong)UILabel * assureLable;
@end
