//
//  AboutUsViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface AboutUsViewController : ZZViewController
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * firstLabel;
@property (nonatomic, strong)UILabel * secondLabel;
@property (nonatomic, strong)UILabel * thirdLabel;
@property (nonatomic, strong)UIImageView * smallImageView;
@property (nonatomic, strong)UIButton * attentButton;
@property (nonatomic, strong)UIButton * editionButton;

@property (nonatomic, assign) int isNewVersion;//检测最新版本
@end
