//
//  CuarateeListTabelViewCell.h
//  SRBApp
//
//  Created by lizhen on 15/2/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "MyImgView.h"
#import "CopyLabel.h"

@interface CuarateeListTabelViewCell : ZZTableViewCell
@property (nonatomic, strong) UILabel *buyRemarkNLabel;//买家备注
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) MyImgView *imageV;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *sellRemarkNLabel;//卖家备注
@property (nonatomic, strong) UILabel *signLabelUp;
//@property (nonatomic, strong) PublishButton *signLabelDown;

@property (nonatomic, strong) UIImageView *sanjiaoImageV;
@property (nonatomic, strong) UIView *assureReasonView;//担保理由
@property (nonatomic, strong) UILabel *assureLable;//担保赏金
@property (nonatomic, strong) UILabel *assurePrice;//赏金
@property (nonatomic, strong) CopyLabel *reasonContentLabel;//理由内容
@property (nonatomic, strong) UILabel *dateLabel;//日期
@end
