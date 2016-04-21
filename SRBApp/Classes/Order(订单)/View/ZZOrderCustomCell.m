//
//  ZZOrderCustomCell.m
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZOrderCustomCell.h"
#import <UIImageView+WebCache.h>

@implementation ZZOrderCustomCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        bgView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:bgView];
        
        UILabel * sellerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, bgView.frame.size.height + bgView.frame.origin.y + 6, SCREEN_WIDTH - 15 - 15 - 100, 18)];
        sellerNameLabel.font = SIZE_FOR_14;
        sellerNameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.sellerNameLabel = sellerNameLabel;
        [self addSubview:sellerNameLabel];
        
        UILabel * statusLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100 - 15), self.sellerNameLabel.frame.origin.y, 100, 14)];
        statusLabel.font = SIZE_FOR_14;
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        self.statusLabel = statusLabel;
        [self addSubview:statusLabel];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sellerNameLabel.frame.size.height + sellerNameLabel.frame.origin.y + 8, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:lineView];
        
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, lineView.frame.size.height + lineView.frame.origin.y + 15, 60, 60)];
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds = YES;
        self.imageview = imageview;
        [self addSubview:imageview];
        
        UILabel * orderTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width + imageview.frame.origin.x + 12, lineView.frame.size.height + lineView.frame.origin.y + 12, SCREEN_WIDTH - 15 - 15 - 12 - 60, 17)];
        orderTitleLabel.font = SIZE_FOR_14;
        orderTitleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.orderTitleLabel = orderTitleLabel;
        [self addSubview:orderTitleLabel];
        
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width + imageview.frame.origin.x + 12, orderTitleLabel.frame.size.height + orderTitleLabel.frame.origin.y + 10, 120, 14)];
        self.priceLabel = priceLabel;
        priceLabel.font = SIZE_FOR_14;
        priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [self addSubview:priceLabel];
        
        UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width + imageview.frame.origin.x + 12,  imageview.frame.size.height + imageview.frame.origin.y - 12, 65, 12)];
        numLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        numLabel.font = SIZE_FOR_12;
        self.numLabel = numLabel;
        [self addSubview:numLabel];
        
//        UILabel * sendPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(numLabel.frame.size.width + numLabel.frame.origin.x,numLabel.frame.origin.y, 80, 12)];
//        sendPriceLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
//        sendPriceLabel.font = SIZE_FOR_12;
//        self.sendPriceLabel = sendPriceLabel;
//        [self addSubview:sendPriceLabel];
        
        ZZGoPayBtn * delBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];
        delBtn.layer.masksToBounds = YES;
        delBtn.layer.cornerRadius = 2;
        [delBtn setTitle:@"删 除" forState:UIControlStateNormal];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
        delBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        delBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        delBtn.frame = CGRectMake((SCREEN_WIDTH - 40 - 35), imageview.frame.origin.y + imageview.frame.size.height - 25, 60, 25);
        self.delBtn = delBtn;
        delBtn.hidden = YES;
        [self addSubview:delBtn];
        
//        UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, priceLabel.frame.origin.y, 50, 12)];
//        timeLabel.font = fonts;
//        timeLabel.textAlignment = NSTextAlignmentRight;
//        timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
//        self.timeLabel = timeLabel;
//        [self addSubview:timeLabel];
        
        ZZGoPayBtn * goPayBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];
        goPayBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [goPayBtn setTitle:@"去付款" forState:UIControlStateNormal];
        [goPayBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        [goPayBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [goPayBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
        goPayBtn.frame = CGRectMake((SCREEN_WIDTH - 75), imageview.frame.origin.y + imageview.frame.size.height - 25, 60, 25);
        goPayBtn.layer.cornerRadius = 2;
        goPayBtn.layer.masksToBounds = YES;
        self.goPayBtn = goPayBtn;
        goPayBtn.hidden = YES;
        [self addSubview:goPayBtn];
    }
    return self;
}

+ (id)settingCellWithTaableView:(UITableView *)tableView
{
    static NSString * ID = @"orderList";
    ZZOrderCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZZOrderCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setOrderModel:(ZZOrderModel *)orderModel
{
    _orderModel = orderModel;
    self.statusLabel.text = orderModel.statusName;
    //如果确认状态是1,则将去付款按钮显示出来
    if ([orderModel.confirm isEqualToString:@"1"] && [orderModel.status isEqualToString:@"0"]) {
        self.goPayBtn.hidden = NO;
    }else
    {
        self.goPayBtn.hidden = YES;
    }
    
    //如果订单状态是取消,则将删除按钮显示出来
    if ([orderModel.status isEqualToString:@"-100"]) {
        self.delBtn.hidden = NO;
    }else{
        self.delBtn.hidden = YES;
        if ([orderModel.confirm isEqualToString:@"0"] && [orderModel.status isEqualToString:@"0"]) {
            
        }
    }

//    self.orderIDLabel.text = orderModel.orderNum;
    //格式化日期
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate * date = [dateFormatter dateFromString:orderModel.updatetime];
//    [dateFormatter setDateFormat:@"MM-dd"];
//    NSString * str = [dateFormatter stringFromDate:date];
//    self.timeLabel.text = [NSString stringWithFormat:@"%@",str];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",orderModel.orderAmount];
    self.sellerNameLabel.text = [NSString stringWithFormat:@"卖家:%@",orderModel.sellernick];
//    self.buyerNameLabel.text = orderModel.buyernick;
    NSDictionary * tempdic = orderModel.goods[0];
    self.orderTitleLabel.text = [tempdic objectForKey:@"title"];
    [self.imageview sd_setImageWithURL:[tempdic objectForKey:@"cover"] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    self.imageview.clipsToBounds = YES;
    
    NSString * sendPrice = orderModel.transportPrice;
//    if ([sendPrice isEqualToString:@"0.00"]) {
//        sendPrice = @"包邮";
//    }else{
//        sendPrice = orderModel.transportPrice;
//    }
    self.sendPriceLabel.text = sendPrice;
    self.numLabel.text = [NSString stringWithFormat:@"数量:%@",[tempdic objectForKey:@"num"]];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
