//
//  LocationNewsCell.h
//  SRBApp
//
//  Created by zxk on 15/2/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "MyImgView.h"
#import "MyLabel.h"
#import "LocationModel.h"

@interface LocationNewsCell : ZZTableViewCell
@property (nonatomic,strong)MyImgView * logoImg;
@property (nonatomic,strong)MyImgView * photoImg;
@property (nonatomic,strong)MyImgView * zanImg;
@property (nonatomic,strong)MyLabel * nameLabel;
@property (nonatomic,strong)MyLabel * contentLabel;
@property (nonatomic,strong)MyLabel * timeLabel;
@property (nonatomic,strong)LocationModel * locationModel;
+ (id)locationNewsCellWithTableView:(UITableView *)tableView;
@end
