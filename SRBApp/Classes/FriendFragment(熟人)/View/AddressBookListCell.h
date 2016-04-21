//
//  AddressBookListCell.h
//  SRBApp
//
//  Created by 刘若曈 on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "MyImgView.h"

@interface AddressBookListCell : ZZTableViewCell
@property (nonatomic, strong)MyImgView * headImage;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * sourceLabel;
@property (nonatomic, strong)UILabel * friendLabel;
@property (nonatomic, strong)UIButton * signButton;
@end
