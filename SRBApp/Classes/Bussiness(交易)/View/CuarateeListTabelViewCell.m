//
//  CuarateeListTabelViewCell.m
//  SRBApp
//
//  Created by lizhen on 15/2/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CuarateeListTabelViewCell.h"

@implementation CuarateeListTabelViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        placeholderView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:placeholderView];
        
        //图片
        self.imageV = [[MyImgView alloc] initWithFrame:CGRectMake(15, 30, 40, 40)];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        self.imageV.clipsToBounds = YES;
        self.imageV.layer.masksToBounds = YES;
        self.imageV.layer.cornerRadius = 20;
        self.imageV.userInteractionEnabled  = YES;
        [self addSubview:self.imageV];
        
        //备注
        self.remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageV.frame.origin.x + self.imageV.frame.size.width + 12, self.imageV.frame.origin.y + 10, SCREEN_WIDTH - 15 - self.imageV.frame.size.width - 15 - 12, 20)];
        self.remarkLabel.font = [UIFont systemFontOfSize:16];
        self.remarkLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [self addSubview:self.remarkLabel];
        
        //日期
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 120, self.imageV.frame.origin.y, 120, 15)];
        self.dateLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.dateLabel.font = SIZE_FOR_12;
        [self addSubview:self.dateLabel];
        
        //担保理由
        self.sanjiaoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(35, self.imageV.frame.origin.y + self.imageV.frame.size.height + 15, 15, 6)];
        self.sanjiaoImageV.hidden = YES;
        self.sanjiaoImageV.image = [UIImage imageNamed:@"assure_reason"];
        [self addSubview:self.sanjiaoImageV];
        //理由背景
        self.assureReasonView = [[UIView alloc] initWithFrame:CGRectMake(15, self.sanjiaoImageV.frame.origin.y + self.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 80)];
        self.assureReasonView.hidden = YES;
        self.assureReasonView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        [self addSubview:self.assureReasonView];
        //担保赏金
        self.assureLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 80, 16)];
        self.assureLable.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.assureLable.text = @"担保理由:";
        self.assureLable.font = SIZE_FOR_14;
        self.assureLable.hidden = YES;
        [self.assureReasonView addSubview:self.assureLable];
        //赏金
        self.assurePrice = [[UILabel alloc] initWithFrame:CGRectMake(75, 7, 100, 16)];
        self.assurePrice.font = SIZE_FOR_14;
        self.assurePrice.textAlignment = NSTextAlignmentLeft;
        self.assurePrice.hidden = YES;
        self.assurePrice.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [self.assureReasonView addSubview:self.assurePrice];
        //理由内容
        self.reasonContentLabel = [[CopyLabel alloc] initWithFrame:CGRectMake(self.assureLable.frame.origin.x, self.assureLable.frame.origin.y + self.assureLable.frame.size.height + 7, self.assureReasonView.frame.size.width - 30, 40)];
        self.reasonContentLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.reasonContentLabel.font = SIZE_FOR_12;
        self.reasonContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.reasonContentLabel.numberOfLines = 0;
        self.reasonContentLabel.hidden = YES;
        [self.assureReasonView addSubview:self.reasonContentLabel];
    }
    return self;
}
@end
