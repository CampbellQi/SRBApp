//
//  CommonFriendCell.h
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "CommenFriendModel.h"
#import "ZZGoPayBtn.h"

@interface CommonFriendCell : ZZTableViewCell
@property (nonatomic,strong)UILabel * titleLabel;                   //标题
@property (nonatomic,strong)UIImageView * imgView;                  //头像
@property (nonatomic,strong)UILabel * signLabel;                    //签名
@property (nonatomic,strong)CommenFriendModel * commenFriendModel;
@property (nonatomic,strong)ZZGoPayBtn * chatBtn;
+ (id)settingCellWithTaableView:(UITableView *)tableView;
@end
