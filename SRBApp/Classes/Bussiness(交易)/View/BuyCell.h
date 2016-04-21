//
//  BuyCell.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "BussinessCell.h"
#import "BussinessModel.h"

@interface BuyCell : BussinessCell
@property (nonatomic, strong)UILabel * detailLabel;
@property (nonatomic, strong)UILabel * commentLabel;
@property (nonatomic,strong)MyImgView * isStickImg;
@property (nonatomic,strong)BussinessModel * bussinessModel;
@end
