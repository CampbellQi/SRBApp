//
//  SellCell.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "BussinessCell.h"
#import "BussinessModel.h"

@interface SellCell : BussinessCell
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UILabel * postLabel;
@property (nonatomic, strong)UILabel * commentLabel;
@property (nonatomic, strong)UILabel * oldPrice;
@property (nonatomic ,strong)UILabel * zhekouLabel;
@property (nonatomic, strong)UIImageView * image;
@property (nonatomic,strong)MyImgView * isStickImg;
@property (nonatomic,strong)BussinessModel * bussinessModel;
@end
