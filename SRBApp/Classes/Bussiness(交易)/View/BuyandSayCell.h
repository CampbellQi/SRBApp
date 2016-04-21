//
//  BuyandSayCell.h
//  SRBApp
//
//  Created by 刘若曈 on 15/4/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "WQOneToSixPhotosView.h"
#import "BuyandSayCellFrame.h"

@interface BuyandSayCell : ZZTableViewCell
@property (nonatomic, strong)MyImgView * headImage;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * sayLabel;
@property (nonatomic, strong)UILabel * dateLabel;
@property (nonatomic, strong)UILabel * goodComment;
@property (nonatomic, strong)UIImageView * commentImg;
@property (nonatomic, strong)WQOneToSixPhotosView * photosView;

@property (nonatomic, strong)BuyandSayCellFrame *cellFrame;
//给用户介绍赋值并且实现自动换行
//-(void)setIntroductionText:(NSString*)text;
//初始化cell类
//-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
@end
