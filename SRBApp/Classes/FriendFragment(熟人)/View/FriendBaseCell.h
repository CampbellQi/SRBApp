//
//  FriendBaseCell.h
//  SRBApp
//
//  Created by zxk on 14/12/25.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "FriendSearchModel.h"
#import "FriendFragmentModel.h"
#import "ZZGoPayBtn.h"
#import "FriendGroupModel.h"
#import "NewFriendModel.h"
#import "LogoImgView.h"
#import "CommonFriendLabel.h"

@interface FriendBaseCell : ZZTableViewCell
@property (nonatomic,strong)FriendSearchModel * friendSearchModel;
@property (nonatomic,strong)FriendFragmentModel * friendFragmentModel;
@property (nonatomic,strong)FriendGroupModel * friendGroupModel;
@property (nonatomic,strong)NewFriendModel * friendNewModel;
@property (nonatomic,strong)LogoImgView * logoImg;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)CommonFriendLabel * descriptionLabel;
@property (nonatomic,strong)ZZGoPayBtn * addBtn;      //添加
@property (nonatomic,strong)UILabel * addedLabel;     //已添加
@property (nonatomic,strong)ZZGoPayBtn * ignoreBtn;   //忽略
@property (nonatomic, strong) UILabel *dateLabel;     //日期
@property (nonatomic,strong)ZZGoPayBtn * chatBtn;     //聊天按钮
@property (nonatomic, strong) UIView *signView;       //新的提示
@property (nonatomic,strong)ZZGoPayBtn * commonFriendBtn;

@property (nonatomic,strong)NSIndexPath * indexpath;

+ (id)friendBaseCellWithTableView:(UITableView *)tableView;
- (void)setFriendFragment:(NSIndexPath *)indexpath withFriendGroup:(FriendGroupModel *)friendGroup;
@end
