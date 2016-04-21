//
//  BuyerWaitCommentCell.m
//  SRBApp
//
//  Created by zxk on 15/1/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "BuyerWaitCommentCell.h"
#import <UIImageView+WebCache.h>

@implementation BuyerWaitCommentCell

+ (id)waitCommentCellWithTableView:(UITableView *)tableView
{
    static NSString * reuseID = @"waitComment";
    BuyerWaitCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[BuyerWaitCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setToSellerModel:(TosellerModel *)toSellerModel
{
    NSDictionary * sellerDic = toSellerModel.seller;
    self.nameLabel.text = [NSString stringWithFormat:@"卖家:%@",[sellerDic objectForKey:@"nickname"]];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:toSellerModel.cover] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    self.goodsImg.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImg.clipsToBounds = YES;
    self.titleLabel.text = toSellerModel.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",toSellerModel.orderAmount];
    NSString * sendPriceStr = toSellerModel.transportPrice;
    if ([sendPriceStr floatValue] == 0) {
        sendPriceStr = @"包邮";
        self.sendPriceLabel.text = [NSString stringWithFormat:@"%@",sendPriceStr];
    }else{
       self.sendPriceLabel.text = [NSString stringWithFormat:@"运费：¥ %@",sendPriceStr];
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
