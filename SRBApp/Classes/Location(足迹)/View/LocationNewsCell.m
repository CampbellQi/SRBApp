//
//  LocationNewsCell.m
//  SRBApp
//
//  Created by zxk on 15/2/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "LocationNewsCell.h"
#import <UIImageView+WebCache.h>

@implementation LocationNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        MyImgView * logoImg = [[MyImgView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        logoImg.layer.masksToBounds = YES;
        logoImg.layer.cornerRadius = 20;
        self.logoImg = logoImg;
        [self addSubview:logoImg];
        
        MyImgView * photoImg = [[MyImgView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 10, 60, 60)];
        self.photoImg = photoImg;
        [self addSubview:photoImg];
        
        MyLabel * nameLabel = [[MyLabel alloc]initWithFrame:CGRectMake(67, 10, 160, 17)];
        nameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        nameLabel.font = SIZE_FOR_14;
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        MyLabel * contentLabel = [[MyLabel alloc]initWithFrame:CGRectMake(67, nameLabel.frame.size.height + nameLabel.frame.origin.y + 5, SCREEN_WIDTH - 67 - 12 - 15 - 60, 17)];
        contentLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        contentLabel.font = SIZE_FOR_14;
        self.contentLabel = contentLabel;
        [self addSubview:contentLabel];
        
        MyImgView * zanImg = [[MyImgView alloc]initWithFrame:CGRectMake(67, nameLabel.frame.size.height + nameLabel.frame.origin.y + 5, 17, 17)];
        self.zanImg = zanImg;
        [self addSubview:zanImg];
        
        MyLabel * timeLabel = [[MyLabel alloc]initWithFrame:CGRectMake(67, contentLabel.frame.size.height + nameLabel.frame.origin.y + 5, 160, 14)];
        timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        timeLabel.font = SIZE_FOR_12;
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        
    }
    return self;
}

+ (id)locationNewsCellWithTableView:(UITableView *)tableView
{
    static NSString * reuseID = @"location";
    LocationNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[LocationNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }else{
        [cell removeFromSuperview];
    }
    
    return cell;
}

- (void)setLocationModel:(LocationModel *)locationModel
{
    _locationModel = locationModel;
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:locationModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.nameLabel.text = locationModel.nickname;
    self.contentLabel.text = locationModel.content;
    self.timeLabel.text = locationModel.updatetime;
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:locationModel.photos] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
