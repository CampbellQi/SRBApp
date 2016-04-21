//
//  SellerManagementCell.m
//  SRBApp
//
//  Created by zxk on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SellerManagementCell.h"
#import <UIImageView+WebCache.h>

@implementation SellerManagementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        bgView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:bgView];
        
        UILabel * buyerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, bgView.frame.size.height + bgView.frame.origin.y + 6, SCREEN_WIDTH - 15 - 15 - 100, 18)];
        buyerLabel.text = @"求购人:";
        buyerLabel.font = SIZE_FOR_14;
        self.buyerLabel = buyerLabel;
        buyerLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [self addSubview:buyerLabel];
        
        UILabel * statusLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100 - 15), self.buyerLabel.frame.origin.y, 100, 14)];
        self.statusLabel = statusLabel;
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        statusLabel.font = SIZE_FOR_14;
        [self addSubview:statusLabel];
        
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, buyerLabel.frame.size.height + buyerLabel.frame.origin.y + 8, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:lineView];
        
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, lineView.frame.size.height + lineView.frame.origin.y + 15, 60, 60)];
        self.logoImg = imageview;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds = YES;
        [self addSubview:imageview];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width + imageview.frame.origin.x + 12, lineView.frame.size.height + lineView.frame.origin.y + 12, SCREEN_WIDTH - 15 - 15 - 12 - 60, 17)];
        titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        titleLabel.font = SIZE_FOR_14;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width + imageview.frame.origin.x + 12, titleLabel.frame.size.height + titleLabel.frame.origin.y + 10, 120, 14)];
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
        
        //操作按钮
        ZZGoPayBtn * operationBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];
        operationBtn.layer.masksToBounds = YES;
        operationBtn.layer.cornerRadius = 2;
        [operationBtn setTitle:@"删 除" forState:UIControlStateNormal];
        [operationBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [operationBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
        operationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        operationBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        operationBtn.frame = CGRectMake((SCREEN_WIDTH - 40 - 35), imageview.frame.origin.y + imageview.frame.size.height - 25, 60, 25);
        self.operationBtn = operationBtn;
        operationBtn.hidden = YES;
        [self addSubview:operationBtn];
    }
    return self;
}

+ (id)sellerManagementCellWithTableView:(UITableView *)tableView
{
    static NSString * reID = @"sellercell";
    SellerManagementCell * cell = [tableView dequeueReusableCellWithIdentifier:reID];
    if (cell == nil) {
        cell = [[SellerManagementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reID];
    }
    return cell;
}

- (void)setSellerModel:(SellerManagementModel *)sellerModel
{
    _sellerModel = sellerModel;
    self.statusLabel.text = sellerModel.statusName;
    if ([sellerModel.status isEqualToString:@"-100"]) {
        self.operationBtn.hidden = NO;
    }else{
        self.operationBtn.hidden = YES;
    }
//    //格式化日期
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate * date = [dateFormatter dateFromString:sellerModel.updatetime];
//    [dateFormatter setDateFormat:@"MM-dd"];
//    NSString * str = [dateFormatter stringFromDate:date];
//    self.timeLabel.text = str;
    
    NSDictionary * tempdic = sellerModel.goods[0];
    [self.logoImg sd_setImageWithURL:[tempdic objectForKey:@"cover"] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImg.clipsToBounds = YES;
//    self.timeLabel.text = str;
    self.numLabel.text = [NSString stringWithFormat:@"数量:%@",[tempdic objectForKey:@"num"]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",sellerModel.orderAmount];
    self.buyerLabel.text = [NSString stringWithFormat:@"买家:%@",sellerModel.buyernick];
    self.titleLabel.text = [tempdic objectForKey:@"title"];
    NSString * sendPrice = sellerModel.transportPrice;
//    if ([sendPrice isEqualToString:@"0.00"]) {
//        sendPrice = @"包邮";
//    }else{
//        sendPrice = sellerModel.transportPrice;
//    }
    self.sendPriceLabel.text = sendPrice;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
