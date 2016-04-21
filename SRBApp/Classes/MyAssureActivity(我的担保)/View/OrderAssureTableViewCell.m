//
//  OederAssureTableViewCell.m
//  SRBApp
//
//  Created by lizhen on 15/1/23.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "OrderAssureTableViewCell.h"
#import "GetColor16.h"

@implementation OrderAssureTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backGViwe  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 121 + 15)];
        backGViwe.backgroundColor = [UIColor whiteColor];
        [self addSubview:backGViwe];
        
        UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        placeholderView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [backGViwe addSubview:placeholderView];
        
        //分割线
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
        lineV.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [backGViwe addSubview:lineV];
        
//        //买家
//        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 35, 20)];
//        nameLabel.font = SIZE_FOR_14;
//        nameLabel.text = @"买家:";
//        [backGViwe addSubview:nameLabel];
        
        //订单号
        self.orderIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, 20)];
        self.orderIdLabel.font = SIZE_FOR_12;
        self.orderIdLabel.backgroundColor = [UIColor clearColor];
//        nameLabel.text = @"买家:";
        self.orderIdLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [backGViwe addSubview:self.orderIdLabel];
        
        //买家备注
//        self.buyRemarkNLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.size.width + 15, nameLabel.frame.origin.y, 150, nameLabel.frame.size.height)];
//        self.buyRemarkNLabel.font = SIZE_FOR_14;
//        [backGViwe addSubview:self.buyRemarkNLabel];
        
        //待收货
        self.signLabelUp = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 105, self.orderIdLabel.frame.origin.y, 90, self.orderIdLabel.frame.size.height)];
//        self.signLabelUp.text = @"等待熟人担保";
        self.signLabelUp.font = SIZE_FOR_14;
        self.signLabelUp.textAlignment = NSTextAlignmentRight;
        self.signLabelUp.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [backGViwe addSubview:self.signLabelUp];
        
        //图片
        self.imageV = [[MyImgView alloc] initWithFrame:CGRectMake(15, lineV.frame.origin.y + 1 + 15, 60, 60)];
        self.imageV.userInteractionEnabled = YES;
        [backGViwe addSubview:self.imageV];
        
        //标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageV.frame.origin.x + self.imageV.frame.size.width + 12, self.imageV.frame.origin.y - 2, SCREEN_WIDTH - 15 - self.imageV.frame.size.width - 15 - 12, 20)];
        self.titleLabel.font = SIZE_FOR_14;
        self.titleLabel.text = @"标题";
        self.titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [backGViwe addSubview:self.titleLabel];
        
        //价格
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 1, 120, 20)];
        self.priceLabel.font = SIZE_FOR_14;
        self.priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [backGViwe addSubview:self.priceLabel];
        
        //卖家
        UILabel *sellNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.priceLabel.frame.origin.x, self.priceLabel.frame.origin.y + self.priceLabel.frame.size.height - 2, 30, 20)];
        sellNameLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        sellNameLabel.text = @"卖家:";
        sellNameLabel.font = SIZE_FOR_12;
        [backGViwe addSubview:sellNameLabel];
        
        //卖家备注
        self.sellRemarkNLabel = [[UILabel alloc] initWithFrame:CGRectMake(sellNameLabel.frame.origin.x + sellNameLabel.frame.size.width, sellNameLabel.frame.origin.y, 100, sellNameLabel.frame.size.height)];
        self.sellRemarkNLabel.font = SIZE_FOR_12;
        self.sellRemarkNLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [backGViwe addSubview:self.sellRemarkNLabel];
        
        //买家
        UILabel *buyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.priceLabel.frame.origin.x, self.priceLabel.frame.origin.y + self.priceLabel.frame.size.height + 15, 30, 20)];
        buyNameLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        buyNameLabel.text = @"买家:";
        buyNameLabel.font = SIZE_FOR_12;
        [backGViwe addSubview:buyNameLabel];
        
        //卖家备注
        self.buyRemarkNLabel = [[UILabel alloc] initWithFrame:CGRectMake(buyNameLabel.frame.origin.x + buyNameLabel.frame.size.width, buyNameLabel.frame.origin.y, 100, buyNameLabel.frame.size.height)];
        self.buyRemarkNLabel.font = SIZE_FOR_12;
        self.buyRemarkNLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [backGViwe addSubview:self.buyRemarkNLabel];
        
        //我要担保
        self.signLabelDown = [PublishButton buttonWithType:UIButtonTypeCustom];
        self.signLabelDown.frame = CGRectMake(SCREEN_WIDTH - 15 - 80, self.imageV.frame.origin.y + self.imageV.frame.size.height - 25, 80, 25);
        self.signLabelDown.layer.masksToBounds = YES;
        self.signLabelDown.layer.cornerRadius = 2;
        [self.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [self.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
        self.signLabelDown.titleLabel.font = [UIFont systemFontOfSize:15];
        self.signLabelDown.titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [backGViwe addSubview:self.signLabelDown];
        
        //担保理由
        self.sanjiaoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(35, self.imageV.frame.origin.y + self.imageV.frame.size.height + 15, 15, 6)];
        self.sanjiaoImageV.hidden = YES;
        self.sanjiaoImageV.image = [UIImage imageNamed:@"assure_reason"];
        [backGViwe addSubview:self.sanjiaoImageV];
        //理由背景
        self.assureReasonView = [[UIView alloc] initWithFrame:CGRectMake(15, self.sanjiaoImageV.frame.origin.y + self.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 80)];
        self.assureReasonView.hidden = YES;
        self.assureReasonView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        [backGViwe addSubview:self.assureReasonView];
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
        self.reasonContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.reasonContentLabel.numberOfLines = 0;
        self.reasonContentLabel.hidden = YES;
        [self.assureReasonView addSubview:self.reasonContentLabel];
        
        //日期
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.assureReasonView.frame.size.width - 135, 9, 120, 15)];
        self.dateLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.dateLabel.font = SIZE_FOR_12;
        self.dateLabel.hidden = YES;
        [self.assureReasonView addSubview:self.dateLabel];
        
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
