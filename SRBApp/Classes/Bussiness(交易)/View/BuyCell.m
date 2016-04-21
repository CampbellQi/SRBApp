//
//  BuyCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "BuyCell.h"

@implementation BuyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 + 100, 15 + 40 + 5, SCREEN_WIDTH - 145, 35)];
//        _detailLabel.font = [UIFont systemFontOfSize:14];
//        _detailLabel.numberOfLines = 0;
//        _detailLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
//        [self.contentView addSubview:_detailLabel];
//        
//        _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 20, 130 - 15 - 13, 20, 12)];
//        _commentLabel.textAlignment = NSTextAlignmentRight;
//        _commentLabel.backgroundColor = [UIColor clearColor];
//        [_commentLabel setTextColor:[UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1]];
//        _commentLabel.font = [UIFont systemFontOfSize:12];
//        [self.contentView addSubview:_commentLabel];
//        
//        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(_commentLabel.frame.origin.x - 10, _commentLabel.frame.origin.y, 13, 13)];
//        imageview.image = [UIImage imageNamed:@"pinglun"];
//        [self.contentView addSubview:imageview];
        
        MyImgView * isStickImg = [[MyImgView alloc]initWithFrame:CGRectMake(self.thingimage.frame.origin.x + self.thingimage.frame.size.width + 12, self.thingimage.frame.origin.y, 34, 17)];
        isStickImg.hidden = YES;
        isStickImg.image = [UIImage imageNamed:@"zhiding"];
        self.isStickImg = isStickImg;
        [self addSubview:isStickImg];
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 + 100, 15 + 40 + 5, SCREEN_WIDTH - 145, 35)];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [self.contentView addSubview:_detailLabel];
        
        _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 20, 130 - 15 - 13, 20, 12)];
        _commentLabel.textAlignment = NSTextAlignmentRight;
        _commentLabel.backgroundColor = [UIColor clearColor];
        [_commentLabel setTextColor:[UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1]];
        _commentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_commentLabel];
        
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(_commentLabel.frame.origin.x - 10, _commentLabel.frame.origin.y, 13, 13)];
        imageview.image = [UIImage imageNamed:@"pinglun"];
        [self.contentView addSubview:imageview];
    }
    return self;
}

- (void)setBussinessModel:(BussinessModel *)bussinessModel
{
    _bussinessModel = bussinessModel;
    [self.thingimage sd_setImageWithURL:[NSURL URLWithString:bussinessModel.cover] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.thingimage.contentMode = UIViewContentModeScaleAspectFill;
    self.thingimage.clipsToBounds = YES;
    self.titleLabel.text = bussinessModel.title;
    self.detailLabel.text = bussinessModel.model_description;
    self.signImage.image = [UIImage imageNamed:@"maisignNew.png"];
    self.nameLabel.text = [NSString stringWithFormat:@"买家:%@", bussinessModel.nickname];
    self.commentLabel.text = bussinessModel.consultCount;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
