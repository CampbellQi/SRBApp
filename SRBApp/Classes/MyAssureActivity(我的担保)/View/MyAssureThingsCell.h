//
//  MyAssureThingsCell.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "PublishButton.h"

@interface MyAssureThingsCell : ZZTableViewCell
@property (nonatomic, strong)UIImageView * thingImv;
@property (nonatomic, strong)UILabel * titleLb;
@property (nonatomic, strong)UILabel * detailLb;
@property (nonatomic, strong)UILabel * dateLb;
@property (nonatomic, strong)PublishButton * deleteBtn;
@end
