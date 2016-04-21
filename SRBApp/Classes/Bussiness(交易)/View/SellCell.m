//
//  SellCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SellCell.h"

@implementation SellCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 + 100, 15 + 41, 120, 35)];
//        _priceLabel.font = [UIFont systemFontOfSize:17];
//        _priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
//        [self.contentView addSubview:_priceLabel];
//        
//        _oldPrice = [[UILabel alloc]initWithFrame:CGRectMake(_priceLabel.frame.origin.x + _priceLabel.frame.size.width + 9, _priceLabel.frame.origin.y , 120, 12)];
//        _oldPrice.font = [UIFont systemFontOfSize:12];
//        _oldPrice.textColor = [GetColor16 hexStringToColor:@"#959595"];
//        [self.contentView addSubview:_oldPrice];
//        
//        _image = [[UIImageView alloc]initWithFrame:CGRectMake(_priceLabel.frame.origin.x, _priceLabel.frame.origin.y + _priceLabel.frame.size.height - 12, 46, 16)];
//        _image.image = [UIImage imageNamed:@"discount_label.png"];
//        [self.contentView addSubview:_image];
//        
//        _zhekouLabel = [[UILabel alloc]initWithFrame:CGRectMake(_image.frame.origin.x, _image.frame.origin.y + 2, 40, 12)];
//        _zhekouLabel.font = [UIFont systemFontOfSize:12];
//        _zhekouLabel.textAlignment = NSTextAlignmentCenter;
//        _zhekouLabel.textColor = [UIColor whiteColor];
//        [self.contentView addSubview:_zhekouLabel];
//        
//        _postLabel = [[UILabel alloc]initWithFrame:CGRectMake(_image.frame.size.width + _image.frame.origin.x + 18, _image.frame.origin.y , 30, 16)];
//        _postLabel.font = [UIFont systemFontOfSize:12];
//        _postLabel.textAlignment = NSTextAlignmentCenter;
//        _postLabel.layer.cornerRadius = 2;
//        _postLabel.layer.masksToBounds = YES;
//        _postLabel.backgroundColor = [UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1];
//        _postLabel.textColor = [UIColor whiteColor];
//        [self.contentView addSubview:_postLabel];
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
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 + 100, 15 + 41, 120, 35)];
        _priceLabel.font = [UIFont systemFontOfSize:17];
        _priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [self.contentView addSubview:_priceLabel];
        
        _postLabel = [[UILabel alloc]initWithFrame:CGRectMake(_priceLabel.frame.origin.x + _priceLabel.frame.size.width + 20, _priceLabel.frame.origin.y , 30, 16)];
        _postLabel.font = [UIFont systemFontOfSize:12];
        _postLabel.textAlignment = NSTextAlignmentCenter;
        _postLabel.layer.cornerRadius = 2;
        _postLabel.layer.masksToBounds = YES;
        _postLabel.backgroundColor = [UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1];
        _postLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_postLabel];
        
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
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",bussinessModel.bangPrice];
    [self.priceLabel sizeToFit];
    if ([bussinessModel.dealType isEqualToString:@"0"]) {
        
    }else{
        self.signImage.image = [UIImage imageNamed:@"SALEtag.png"];
        if ([bussinessModel.originalPrice floatValue] == 0) {
            self.signImage.image = [UIImage imageNamed:@"shopping_freeBuy"];
        }
    }
    if ([bussinessModel.storage isEqualToString: @"0"]) {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        image.frame = self.thingimage.frame;
        image.image = [UIImage imageNamed:@"qiangguangleBig"];
        [self.contentView addSubview:image];
    }
    self.nameLabel.text = [NSString stringWithFormat:@"卖家:%@",bussinessModel.nickname];
    if ([bussinessModel.freeShipment isEqualToString:@"1"]) {
        self.postLabel.text = @"包邮";
        self.postLabel.frame = CGRectMake(_commentLabel.frame.origin.x - 10, self.priceLabel.frame.origin.y + 2, 30, 16);
        self.postLabel.hidden = NO;
    }
    else
    {
        self.postLabel.hidden = YES;
    }
    self.commentLabel.text = bussinessModel.consultCount;
    //    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    //    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    //    //拼接post参数
    //    NSDictionary * dic = [self parametersForDic:@"getPostMarkByRelation" parameters:@{@"account":name, @"password":password, @"isFriended":@"0",@"id":[dataArray[indexPath.row]model_id],@"start":@"0", @"count":@"10"}];
    //    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
    //        int result = [[dic objectForKey:@"result"] intValue];
    //        if (result == 0) {
    //            cell.commentLabel.text = [[dic objectForKey:@"data"] objectForKey:@"totalCount"];
    //        }else{
    //            cell.commentLabel.text = @"0";
    //        }
    //    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
