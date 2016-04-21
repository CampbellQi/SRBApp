//
//  RechargeListCell.m
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "RechargeListCell.h"

@implementation RechargeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel * orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 220, 12)];
        UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, orderNumLabel.frame.size.height + orderNumLabel.frame.origin.y + 12, 220, 12)];
        orderNumLabel.font = SIZE_FOR_12;
        timeLabel.font = SIZE_FOR_12;
        orderNumLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 130, 12, 130, 12)];
        priceLabel.font = SIZE_FOR_14;
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        self.orderNum = orderNumLabel;
        self.timeLabel = timeLabel;
        self.priceLabel = priceLabel;
        
        ZZGoPayBtn * goPayBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];
        [goPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
        goPayBtn.frame = CGRectMake(SCREEN_WIDTH - 70 - 15, priceLabel.frame.size.height + priceLabel.frame.origin.y + 8, 70, 25);
        goPayBtn.layer.cornerRadius = 2;
        goPayBtn.layer.masksToBounds = YES;
        goPayBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        goPayBtn.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [goPayBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        self.goPayBtn = goPayBtn;
        
        UILabel * statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70 - 15, priceLabel.frame.size.height + priceLabel.frame.origin.y + 8, 70, 15)];
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.text = @"充值成功";
        statusLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        statusLabel.font = SIZE_FOR_12;
        self.stateLabel = statusLabel;
        
        [self addSubview:statusLabel];
        [self addSubview:goPayBtn];
        [self addSubview:timeLabel];
        [self addSubview:priceLabel];
        [self addSubview:orderNumLabel];
    }
    return self;
}

- (void)setRechargeModel:(RechargeListModel *)rechargeModel
{
    _rechargeModel = rechargeModel;
    self.orderNum.text = [NSString stringWithFormat:@"充值号:%@",rechargeModel.orderNum];
    //格式化日期
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:rechargeModel.updatetime];
    NSString * str = [dateFormatter stringFromDate:date];
    self.timeLabel.text = str;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",rechargeModel.price];
    if ([rechargeModel.status isEqualToString:@"1"]) {
        self.goPayBtn.hidden = YES;
        self.stateLabel.hidden = NO;
    }else{
        self.goPayBtn.hidden = NO;
        self.stateLabel.hidden = YES;
    }
}

+ (id)rechargeListCellWithTableView:(UITableView *)tableView
{
    static NSString * reuseID = @"recharge";
    RechargeListCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[RechargeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
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
