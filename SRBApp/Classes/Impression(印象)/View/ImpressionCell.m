//
//  ImpressionCell.m
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ImpressionCell.h"

@implementation ImpressionCell

- (void)setImpressionModel:(RemarkModel *)impressionModel
{
    _impressionModel = impressionModel;
    self.qinMiZhiShuImg.hidden = NO;
    self.qinmiZhiShu.hidden = NO;
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:impressionModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImg.clipsToBounds = YES;
    self.nameLabel.text = impressionModel.nickname;
    self.descriptionLabel.text = impressionModel.sign;
    self.relationLabel.hidden = NO;
    
    self.relationLabel.text = impressionModel.relation;
    if ([impressionModel.grade isEqualToString:@"1"]) {
        self.qinMiZhiShuImg.imgOne.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgTwo.image = [UIImage imageNamed:@"wx003"];
        self.qinMiZhiShuImg.imgThree.image = [UIImage imageNamed:@"wx003"];
        self.qinMiZhiShuImg.imgFour.image = [UIImage imageNamed:@"wx003"];
        self.qinMiZhiShuImg.imgFive.image = [UIImage imageNamed:@"wx003"];
    }else if ([impressionModel.grade isEqualToString:@"2"]){
        self.qinMiZhiShuImg.imgOne.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgTwo.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgThree.image = [UIImage imageNamed:@"wx003"];
        self.qinMiZhiShuImg.imgFour.image = [UIImage imageNamed:@"wx003"];
        self.qinMiZhiShuImg.imgFive.image = [UIImage imageNamed:@"wx003"];
    }else if ([impressionModel.grade isEqualToString:@"3"]){
        self.qinMiZhiShuImg.imgOne.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgTwo.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgThree.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgFour.image = [UIImage imageNamed:@"wx003"];
        self.qinMiZhiShuImg.imgFive.image = [UIImage imageNamed:@"wx003"];
    }
    else if ([impressionModel.grade isEqualToString:@"4"]){
        self.qinMiZhiShuImg.imgOne.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgTwo.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgThree.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgFour.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgFive.image = [UIImage imageNamed:@"wx003"];
    }else if ([impressionModel.grade isEqualToString:@"5"]){
        self.qinMiZhiShuImg.imgOne.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgTwo.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgThree.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgFour.image = [UIImage imageNamed:@"wx001"];
        self.qinMiZhiShuImg.imgFive.image = [UIImage imageNamed:@"wx001"];
    }else{
        self.qinMiZhiShuImg.imgOne.image = [UIImage imageNamed:@"wx003"];
        self.qinMiZhiShuImg.imgTwo.image = [UIImage imageNamed:@"wx003"];
        self.qinMiZhiShuImg.imgThree.image = [UIImage imageNamed:@"wx003"];
        self.qinMiZhiShuImg.imgFour.image = [UIImage imageNamed:@"wx003"];
        self.qinMiZhiShuImg.imgFive.image = [UIImage imageNamed:@"wx003"];
    }
    
}

+ (id)impressionCellWithTaableView:(UITableView *)tableView
{
    static NSString * reuseID = @"impression";
    ImpressionCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[ImpressionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
