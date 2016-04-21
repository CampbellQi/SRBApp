//
//  BrowsingHistoryCell.m
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "BrowsingHistoryCell.h"
#import <UIImageView+WebCache.h>

@implementation BrowsingHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * goodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        self.imageview = goodsImg;
        [self.contentView addSubview:goodsImg];
        
        UILabel * goodsTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsImg.frame.size.width + goodsImg.frame.origin.x + 12, 15, 200, 18)];
        goodsTitleLabel.font = SIZE_FOR_14;
        self.goodsTitleLabel = goodsTitleLabel;
        [self.contentView addSubview:goodsTitleLabel];
        
        UILabel * descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsImg.frame.size.width + goodsImg.frame.origin.x + 12, goodsTitleLabel.frame.size.height + goodsTitleLabel.frame.origin.y + 6, SCREEN_WIDTH - 102, 18)];
        descriptionLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        descriptionLabel.font = SIZE_FOR_14;
        self.descriptionLabel = descriptionLabel;
        [self.contentView addSubview:descriptionLabel];
        
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsImg.frame.size.width + goodsImg.frame.origin.x + 12, goodsImg.frame.size.height + goodsImg.frame.origin.y - 16, 150, 16)];
        priceLabel.font = SIZE_FOR_14;
        priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        self.priceLabel = priceLabel;
        //[self.contentView addSubview:priceLabel];
    }
    return self;
}

+ (id)browsingHeistoryCellWithTableView:(UITableView *)tableView
{
    static NSString * reuseID = @"history";
    BrowsingHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[BrowsingHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setBrowsingHistoryModel:(BrowsingHistoryModel *)browsingHistoryModel
{
    _browsingHistoryModel = browsingHistoryModel;
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:browsingHistoryModel.cover] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    self.imageview.clipsToBounds = YES;
    self.goodsTitleLabel.text = browsingHistoryModel.title;
    self.descriptionLabel.text = browsingHistoryModel.descriptions;
    if ([browsingHistoryModel.dealType isEqualToString:@"2"]) {
        [self.priceLabel setHidden:YES];
    }else{
        [self.priceLabel setHidden:NO];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",browsingHistoryModel.bangPrice];
    }
    
//    CGRect rect = [browsingHistoryModel.descriptions boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 102, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_12} context:nil];
//    CGRect labelRect = self.descriptionLabel.frame;
//    labelRect.size.height = rect.size.height;
//    self.descriptionLabel.frame = labelRect;
//    
//    self.priceLabel.frame = CGRectMake(self.imageview.frame.size.width + self.imageview.frame.origin.x + 12, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 6, 150, 14);
    
}


@end
