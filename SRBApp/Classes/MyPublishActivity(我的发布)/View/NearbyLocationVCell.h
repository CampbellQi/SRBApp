//
//  NearbyLocationVCell.h
//  SRBApp
//
//  Created by lizhen on 15/3/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "TencentMapModel.h"

@interface NearbyLocationVCell : ZZTableViewCell
@property (nonatomic, strong) UIImageView *locationImage;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *addressLable;
@property (nonatomic, strong) TencentMapModel *model;

@end
