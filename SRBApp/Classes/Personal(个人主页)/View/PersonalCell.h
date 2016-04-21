//
//  PersonalCell.h
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "PersonalModel.h"
#import "LeftImgAndRightTitleBtn.h"
#import "ZZGoPayBtn.h"
#import "LocationModel.h"
#import "BussinessModel.h"

@protocol TableViewCellDelegate <NSObject>

- (void)viewreloadData;

@end

@interface PersonalCell : ZZTableViewCell


/*
 *足迹cell
 */
@property (nonatomic,strong)UIImageView * logoImg;  //头像
@property (nonatomic,strong)UILabel * nameLabel;    //标题
@property (nonatomic,strong)UILabel * descriptionLabel;     //详情
@property (nonatomic,strong)UIImageView * photoImg;  //照片
@property (nonatomic,strong)UIImageView * locationImg;  //定位
@property (nonatomic,strong)UILabel * addressLabel;    //地址
@property (nonatomic,strong)ZZGoPayBtn * moreBtn;         //分享和点赞
@property (nonatomic,strong)UIImageView * sanjiaoImg;   //三角图片
@property (nonatomic,strong)UIView * zanNumBgView;      //赞的背景view
@property (nonatomic,strong)UILabel * numPerLabel;      //多少人赞
@property (nonatomic,strong)UILabel * timeLabel;        //时间
@property (nonatomic,strong)UILabel * alertLabel;   //+1
@property (nonatomic,strong)LeftImgAndRightTitleBtn * zanBtn;
@property (nonatomic,strong)LeftImgAndRightTitleBtn * shareBtn;
@property (nonatomic, assign)id <TableViewCellDelegate>delegate;
/*
 *交易
 */
@property (nonatomic, strong)UIImageView * thingimage;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * jiaoyiNameLabel;
@property (nonatomic, strong)UIImageView * signImage;
@property (nonatomic, strong)UILabel * detailLabel;
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UILabel * postLabel;

@property (nonatomic,strong)BussinessModel * bussinessModel;
@property (nonatomic,strong)LocationModel * locationModel;


@property (nonatomic,strong)PersonalModel * personalModel;

+ (id)personalCellWithTaableView:(UITableView *)tableView;
- (void)showAlertLabel;
@end
