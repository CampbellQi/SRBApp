//
//  FansAndImpressionBaseCell.m
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "FansAndImpressionBaseCell.h"


@implementation FansAndImpressionBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
        logoImg.layer.masksToBounds = YES;
        logoImg.layer.cornerRadius = 20;
        [self addSubview:logoImg];
        self.logoImg = logoImg;
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 15, 15, 160, 16)];
        nameLabel.font = SIZE_FOR_IPHONE;
        nameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UILabel * descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height + nameLabel.frame.origin.y + 10, SCREEN_WIDTH - 15 - 15 - 15 - 40, 27)];
        descriptionLabel.font = SIZE_FOR_12;
        descriptionLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.descriptionLabel = descriptionLabel;
        descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        descriptionLabel.numberOfLines = 0;
        [self addSubview:descriptionLabel];
        
        UILabel * relationLabel = [[UILabel alloc]initWithFrame:CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y+descriptionLabel.frame.size.height+10, 35, 18)];
        relationLabel.font = SIZE_FOR_12;
        relationLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        relationLabel.layer.borderColor = [GetColor16 hexStringToColor:@"#959595"].CGColor;
        relationLabel.layer.cornerRadius = 2;
        relationLabel.layer.borderWidth = 1;
        relationLabel.textAlignment = NSTextAlignmentCenter;
        self.relationLabel = relationLabel;
        relationLabel.hidden = YES;
        [self addSubview:relationLabel];
        
        _qinmiZhiShu = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 88 - 70, relationLabel.frame.origin.y, 70, 12)];
        _qinmiZhiShu.text = @"亲密指数:";
        _qinmiZhiShu.hidden = YES;
        _qinmiZhiShu.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        _qinmiZhiShu.font = SIZE_FOR_12;
        [self addSubview:_qinmiZhiShu];
        
        _qinMiZhiShuImg = [[QinMiZhiShuImg alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 88, relationLabel.frame.origin.y, 88, 12)];
        _qinMiZhiShuImg.hidden = YES;
        [self addSubview:_qinMiZhiShuImg];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
