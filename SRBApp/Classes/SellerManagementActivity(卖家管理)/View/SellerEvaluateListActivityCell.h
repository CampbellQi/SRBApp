//
//  SellerEvaluateListActivityCell.h
//  SRBApp
//
//  Created by zxk on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZGoPayBtn.h"
#import "TosellerModel.h"

@interface SellerEvaluateListActivityCell : ZZTableViewCell

@property (nonatomic,strong)UIImageView * logoImg;  //头像
@property (nonatomic,strong)UILabel * nameLabel;    //姓名
@property (nonatomic, strong)UILabel * buyerLabel;// 买家姓名
@property (nonatomic,strong)UILabel * titleLabel;   //标题
@property (nonatomic,strong)MyImgView * goodsImg; //商品图片
@property (nonatomic,strong)UILabel * descriptionLabel; //商品描述
@property (nonatomic,strong)UILabel * priceLabel;   //商品价格

@property (nonatomic,strong)UILabel * timeLabel;    //评价时间
@property (nonatomic,strong)UIImageView * commentImg;//评论三角图
@property (nonatomic,strong)UILabel * goodComment;  //评价程度
@property (nonatomic,strong)UIImageView * commentForImg;    //好评图片
@property (nonatomic,strong)UILabel * commentLabel; //评价
@property (nonatomic,strong)ZZGoPayBtn * goComentBtn;   //去评价按钮
@property (nonatomic,strong)UILabel * noBuyerCommentLabel;  //买家还未评价
@property (nonatomic,strong)UIView * commentBgview;     //评价背景图

@property (nonatomic, strong)UIImageView * imageView1;
@property (nonatomic, strong)UIImageView * imageView2;
@property (nonatomic, strong)UIImageView * imageView3;
@property (nonatomic, strong)UIImageView * imageView4;
@property (nonatomic, strong)UIImageView * imageView5;
@property (nonatomic, strong)UIImageView * imageView6;


@property (nonatomic,strong)TosellerModel * toSellerModel;
@property (nonatomic,copy)NSString * commentType;

+ (id)sellerCellWithTableView:(UITableView *)tableView;
- (void)setToSellerModel:(TosellerModel *)toSellerModel;
@end
