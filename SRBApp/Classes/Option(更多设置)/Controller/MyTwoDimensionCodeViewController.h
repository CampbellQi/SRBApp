//
//  MyTwoDimensionCodeViewController.h
//  SRBApp
//
//  Created by lizhen on 15/4/22.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface MyTwoDimensionCodeViewController : ZZViewController
@property (nonatomic, strong) UIImageView *qrCodeImaV;//二维码
@property (nonatomic, strong) UILabel *invitecodeLabel;//邀请码
@property (nonatomic, strong) UIImageView *sexImgV;//性别
@property (nonatomic, strong) UIImageView *constellationcodeImgV;//星座
@property (nonatomic, strong) UIImageView *headImageV;//星座
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, assign) CGRect  labelRect;        //自适应
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) UIView *customView;

@end
