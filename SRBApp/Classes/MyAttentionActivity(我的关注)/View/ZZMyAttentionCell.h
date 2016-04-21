//
//  ZZMyAttentionCell.h
//  SRBApp
//
//  Created by zxk on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZOrderCustomBtn.h"
#import "ZZMyAttentionInfoModel.h"
#import "ZZMyAttentionVipModel.h"
#import "ZZGoPayBtn.h"

@interface ZZMyAttentionCell : ZZTableViewCell
@property (nonatomic,strong)UILabel * titleLabel;                   //标题
@property (nonatomic,strong)UIImageView * imgView;                  //头像
@property (nonatomic,strong)UILabel * signLabel;                    //签名
@property (nonatomic,strong)UILabel * locationLabel;                //位置
@property (nonatomic,strong)UILabel * priceLabel;                   //价格
//@property (nonatomic,strong)ZZOrderCustomBtn * delBtn;              //删除按钮
//@property (nonatomic,strong)ZZOrderCustomBtn * delBtnRight;              //删除按钮
@property (nonatomic,strong)ZZMyAttentionInfoModel * infoModel;     //信息model
@property (nonatomic,strong)ZZMyAttentionVipModel * vipModel;       //会员model
@property (nonatomic,assign)int type;                               //cell类型


+ (id)settingCellWithTaableView:(UITableView *)tableView;
@end
