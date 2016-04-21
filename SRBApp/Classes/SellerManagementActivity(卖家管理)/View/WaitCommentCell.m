//
//  WaitCommentCell.m
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "WaitCommentCell.h"
#import <UIImageView+WebCache.h>

@implementation WaitCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        bgView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:bgView];
        UIView * whiteBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 124)];
        whiteBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [self addSubview:whiteBGView];
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 17)];
        nameLabel.font = SIZE_FOR_14;
        self.nameLabel = nameLabel;
        [whiteBGView addSubview:nameLabel];
        
        UILabel * stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, 10, 100, 14)];
        stateLabel.text = @"交易成功";
        stateLabel.textAlignment = NSTextAlignmentRight;
        stateLabel.font = SIZE_FOR_14;
        stateLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [whiteBGView addSubview:stateLabel];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [whiteBGView addSubview:lineView];
        
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15, lineView.frame.size.height + lineView.frame.origin.y+14, 60, 60)];
        lineView.contentMode = UIViewContentModeScaleAspectFill;
        lineView.clipsToBounds = YES;
        self.goodsImg = imgview;
        [whiteBGView addSubview:imgview];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgview.frame.size.width+imgview.frame.origin.x+12, imgview.frame.origin.y, SCREEN_WIDTH - 15 - 12 - 15 - 60, 14)];
        titleLabel.font = SIZE_FOR_12;
        self.titleLabel = titleLabel;
        [whiteBGView addSubview:titleLabel];
        
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x,titleLabel.frame.origin.y+titleLabel.frame.size.height + 10,120,14)];
        priceLabel.font = SIZE_FOR_14;
        priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        self.priceLabel = priceLabel;
        [whiteBGView addSubview:priceLabel];
        
        UILabel * sendPiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x,priceLabel.frame.origin.y+priceLabel.frame.size.height+10,120,12)];
        sendPiceLabel.font = SIZE_FOR_12;
        sendPiceLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.sendPriceLabel = sendPiceLabel;
        [whiteBGView addSubview:sendPiceLabel];
        
        ZZGoPayBtn * goCommentBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];

        goCommentBtn.frame = CGRectMake(SCREEN_WIDTH - 25 - 60, imgview.frame.origin.y + imgview.frame.size.height - 25, 70, 25);

        goCommentBtn.layer.masksToBounds = YES;
        goCommentBtn.layer.cornerRadius = 2;

        goCommentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [goCommentBtn setTitle:@"去评价" forState:UIControlStateNormal];

        [goCommentBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        goCommentBtn.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
        self.goCommentBtn = goCommentBtn;
        [whiteBGView addSubview:goCommentBtn];
                
    }
    return self;
}

+ (id)waitCommentCellWithTableView:(UITableView *)tableView
{
    static NSString * reuseID = @"waitComment";
    WaitCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[WaitCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setToSellerModel:(TosellerModel *)toSellerModel
{
    _toSellerModel = toSellerModel;
    NSDictionary * buyerDic = toSellerModel.buyer;
    self.nameLabel.text = [NSString stringWithFormat:@"买家:%@",[buyerDic objectForKey:@"nickname"]];
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
