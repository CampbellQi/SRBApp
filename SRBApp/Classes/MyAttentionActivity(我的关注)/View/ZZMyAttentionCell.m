//
//  ZZMyAttentionCell.m
//  SRBApp
//
//  Created by zxk on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZMyAttentionCell.h"
#import <UIImageView+WebCache.h>

@implementation ZZMyAttentionCell
{
    UIImageView * locationImg;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        self.imgView = imgview;
        imgview.userInteractionEnabled = YES;
        [self.contentView addSubview:imgview];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgview.frame.size.width + imgview.frame.origin.x + 12, 15, SCREEN_WIDTH - 87.5 - 15 - 12 - 60, 17)];
        titleLabel.font = SIZE_FOR_14;
        titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        
        UILabel * signLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.size.height + titleLabel.frame.origin.y + 6, SCREEN_WIDTH - 102, 17)];
        signLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        signLabel.font = SIZE_FOR_14;
        self.signLabel = signLabel;
        [self.contentView addSubview:signLabel];
        
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, imgview.frame.size.height + imgview.frame.origin.y - 14, 150, 16)];
        priceLabel.font = SIZE_FOR_14;
        priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        self.priceLabel = priceLabel;
        //[self.contentView addSubview:priceLabel];
        
        
        
//        locationImg = [[UIImageView alloc]initWithFrame:CGRectMake(85, signLabel.frame.size.height + signLabel.frame.origin.y + 10, 10, 10)];
//        locationImg.image = [UIImage imageNamed:@"fb_wzb"];
//        locationImg.hidden = YES;
//        [self addSubview:locationImg];
//        
//        UILabel * locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, signLabel.frame.size.height + signLabel.frame.origin.y + 10, 200, 12)];
//        locationLabel.font = [UIFont systemFontOfSize:12];
//        self.locationLabel = locationLabel;
//        [self addSubview:locationLabel];
        
//        ZZOrderCustomBtn * delBtn = [ZZOrderCustomBtn buttonWithType:UIButtonTypeCustom];
//        delBtn.frame = CGRectMake(SCREEN_WIDTH - 20 - 37.5, 35, 20, 20);
//        [delBtn setBackgroundImage:[UIImage imageNamed:@"ad_delete"] forState:UIControlStateNormal];
//        delBtn.hidden = YES;
//        self.delBtn = delBtn;
//        [self addSubview:delBtn];
//        
//        ZZOrderCustomBtn * delBtnRight = [ZZOrderCustomBtn buttonWithType:UIButtonTypeCustom];
//        delBtnRight.frame = CGRectMake(SCREEN_WIDTH - 20 - 37.5, 35, 20, 20);
//        [delBtnRight setBackgroundImage:[UIImage imageNamed:@"ad_delete"] forState:UIControlStateNormal];
//        delBtnRight.hidden = YES;
//        self.delBtnRight = delBtnRight;
//        [self addSubview:delBtnRight];
    }
    return self;
}

//创建cell
+ (id)settingCellWithTaableView:(UITableView *)tableView
{
    static NSString * reuse = @"attentionList";
    ZZMyAttentionCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[ZZMyAttentionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    return cell;
}

//vipModel时设置cell样式
- (void)setVipModel:(ZZMyAttentionVipModel *)vipModel
{
    _vipModel = vipModel;
    self.imgView.frame = CGRectMake(15, 15, 40, 40);
    self.imgView.layer.cornerRadius = 20;
    self.imgView.layer.masksToBounds = YES;
    self.titleLabel.frame = CGRectMake(self.imgView.frame.size.width + self.imgView.frame.origin.x + 12, 15, SCREEN_WIDTH - 87.5 - 15 - 12 - 60, 12);
    self.signLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y + 12, self.titleLabel.frame.size.width, 40);
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:vipModel.avatar] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    self.titleLabel.font = SIZE_FOR_IPHONE;
    CGRect rect = [vipModel.sign boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 87.5 - 15 - 12 - 60, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: SIZE_FOR_12} context:nil];
    CGRect  frame = self.signLabel.frame;
    frame.size.height = rect.size.height;
    self.signLabel.frame = frame;

    self.titleLabel.text = vipModel.nickname;
    self.signLabel.text = vipModel.sign;
}

//infoModel时设置cell样式
- (void)setInfoModel:(ZZMyAttentionInfoModel *)infoModel
{
    _infoModel = infoModel;
//    self.imgView.frame = CGRectMake(15, 15, 60, 60);
//    self.titleLabel.frame = CGRectMake(self.imgView.frame.size.width + self.imgView.frame.origin.x + 12, 15, SCREEN_WIDTH - 87.5 - 15 - 12 - 60, 14);
//    self.titleLabel.font = SIZE_FOR_12;
//    self.signLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y + 12, SCREEN_WIDTH - self.titleLabel.frame.origin.x - 15, 55);
//    
//    CGRect rect = [infoModel.descriptions boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 87.5 - 15 - 12 - 60, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: SIZE_FOR_12} context:nil];
//    CGRect frame = self.signLabel.frame;
//    frame.size.height = rect.size.height;
//    self.signLabel.frame = frame;
//
//    self.imgView.layer.cornerRadius = 0;
    
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:infoModel.cover] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    self.titleLabel.text = infoModel.title;
    self.signLabel.text = infoModel.descriptions;
    if ([infoModel.dealType isEqualToString:@"2"]) {
        self.priceLabel.hidden = YES;
    }else{
        self.priceLabel.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",infoModel.bangPrice];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
