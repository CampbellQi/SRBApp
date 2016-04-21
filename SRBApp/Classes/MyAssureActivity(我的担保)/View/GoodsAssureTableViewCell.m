//
//  GoodsAssureTableViewCell.m
//  SRBApp
//
//  Created by lizhen on 15/1/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GoodsAssureTableViewCell.h"

@implementation GoodsAssureTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        placeholderView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:placeholderView];
        
        //图片
        self.imageV = [[MyImgView alloc] initWithFrame:CGRectMake(15, 30, 60, 60)];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        self.imageV.clipsToBounds = YES;
        self.imageV.userInteractionEnabled  = YES;
        [self addSubview:self.imageV];
        
        //标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageV.frame.origin.x + self.imageV.frame.size.width + 12, self.imageV.frame.origin.y - 2, SCREEN_WIDTH - 15 - self.imageV.frame.size.width - 15 - 12, 20)];
        self.titleLabel.font = SIZE_FOR_14;
        self.titleLabel.text = @"标题";
        self.titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [self addSubview:self.titleLabel];
        
        //价格
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 3, 120, 20)];
        self.priceLabel.font = SIZE_FOR_14;
        self.priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [self addSubview:self.priceLabel];
        
        //卖家
        _sellNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.priceLabel.frame.origin.x, self.priceLabel.frame.origin.y + self.priceLabel.frame.size.height + 3, 30, 20)];
        _sellNameLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        _sellNameLabel.text = @"卖家:";
        _sellNameLabel.font = SIZE_FOR_12;
        [self addSubview:_sellNameLabel];
        
        //卖家备注
        self.sellRemarkNLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sellNameLabel.frame.origin.x + _sellNameLabel.frame.size.width, _sellNameLabel.frame.origin.y, 100, _sellNameLabel.frame.size.height)];
        self.sellRemarkNLabel.font = SIZE_FOR_12;
        self.sellRemarkNLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [self addSubview:self.sellRemarkNLabel];
        
        //我要担保
        self.signLabelDown = [PublishButton buttonWithType:UIButtonTypeCustom];
        self.signLabelDown.frame = CGRectMake(SCREEN_WIDTH - 15 - 80, self.imageV.frame.origin.y + self.imageV.frame.size.height - 25, 80, 25);
        self.signLabelDown.layer.masksToBounds = YES;
        self.signLabelDown.layer.cornerRadius = 2;
        [self.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [self.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
        self.signLabelDown.titleLabel.font = [UIFont systemFontOfSize:15];
        self.signLabelDown.titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [self addSubview:self.signLabelDown];
        
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
        self.reasonContentLabel = [[CopyLabel alloc]initWithFrame:CGRectMake(self.assureLable.frame.origin.x, self.assureLable.frame.origin.y + self.assureLable.frame.size.height + 7, self.assureReasonView.frame.size.width - 30, 45)];
        self.reasonContentLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.reasonContentLabel.font = SIZE_FOR_12;
        self.reasonContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.reasonContentLabel.numberOfLines = 0;
        self.reasonContentLabel.hidden = YES;
        [self.assureReasonView addSubview:self.reasonContentLabel];
        
        //日期
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.assureReasonView.frame.size.width - 135, 9, 120, 15)];
        self.dateLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.dateLabel.font = SIZE_FOR_12;
        self.dateLabel.textAlignment = NSTextAlignmentRight;
//        self.dateLabel.hidden = YES;
        [self.assureReasonView addSubview:self.dateLabel];
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
