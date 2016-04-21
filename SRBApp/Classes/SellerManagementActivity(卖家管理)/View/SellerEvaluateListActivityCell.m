//
//  SellerEvaluateListActivityCell.m
//  SRBApp
//
//  Created by zxk on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SellerEvaluateListActivityCell.h"
#import <UIImageView+WebCache.h>


@implementation SellerEvaluateListActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        UIImageView * logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
//        logoImg.layer.masksToBounds = YES;
//        logoImg.layer.cornerRadius = 20;
//        self.logoImg = logoImg;
//        [self addSubview:logoImg];
        
        MyImgView * goodsImg = [[MyImgView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        goodsImg.contentMode = UIViewContentModeScaleAspectFill;
        goodsImg.clipsToBounds = YES;
        goodsImg.userInteractionEnabled = YES;
        self.goodsImg = goodsImg;
        [self addSubview:goodsImg];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsImg.frame.size.width + goodsImg.frame.origin.x + 12, 15, SCREEN_WIDTH - 15 - 15 - 12 - 60, 17)];
        titleLabel.font = SIZE_FOR_14;
        titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
    
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.size.height + titleLabel.frame.origin.y + 5, 150, 14)];
        priceLabel.font = SIZE_FOR_14;
        priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        self.priceLabel = priceLabel;
        [self addSubview:priceLabel];
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.size.height + priceLabel.frame.origin.y + 5, 160, 14)];
        nameLabel.font = SIZE_FOR_12;
        nameLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UILabel * buyerLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height + nameLabel.frame.origin.y + 5, 160, 14)];
        buyerLabel.font = SIZE_FOR_12;
        buyerLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.buyerLabel = buyerLabel;
        [self addSubview:buyerLabel];
        
        UIImageView * sanjiaoImg = [[UIImageView alloc]initWithFrame:CGRectMake(goodsImg.frame.size.width / 2 + goodsImg.frame.origin.x, goodsImg.frame.size.height + goodsImg.frame.origin.y + 15, 17, 7)];
        self.commentImg = sanjiaoImg;
        sanjiaoImg.image = [UIImage imageNamed:@"bg_comment"];
        [self addSubview:sanjiaoImg];
        
        UIView * commentBgview = [[UIView alloc]initWithFrame:CGRectMake(15, sanjiaoImg.frame.size.height + sanjiaoImg.frame.origin.y, SCREEN_WIDTH - 30, 60)];
        self.commentBgview = commentBgview;
        commentBgview.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        //commentBgview.backgroundColor = [UIColor redColor];
        [self addSubview:commentBgview];
        
        //评分
        UILabel * goodComment = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 16)];
        goodComment.font = SIZE_FOR_12;
        goodComment.hidden = NO;
        self.goodComment = goodComment;
        goodComment.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [commentBgview addSubview:goodComment];
        
        //评分图片
        UIImageView * commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(goodComment.frame.size.width + goodComment.frame.origin.x + 8, 11, 12,12)];
        commentImg.hidden = NO;
        self.commentForImg = commentImg;
        [commentBgview addSubview:commentImg];
        
        //评论
        UILabel * commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, goodComment.frame.size.height + goodComment.frame.origin.y + 5, SCREEN_WIDTH - 50, 30)];
        commentLabel.font = SIZE_FOR_14;
        commentLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        commentLabel.numberOfLines = 0;
        self.commentLabel = commentLabel;
        [commentBgview addSubview:commentLabel];
        
        //买家没有评论
        UILabel * noCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake((commentBgview.frame.size.width - 120)/2, 10.5, 120, 14)];
        noCommentLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.noBuyerCommentLabel = noCommentLabel;
        noCommentLabel.textAlignment = NSTextAlignmentCenter;
        noCommentLabel.font = SIZE_FOR_14;
        noCommentLabel.hidden = YES;
        [commentBgview addSubview:noCommentLabel];
        
        float kuan = (commentBgview.frame.size.width - 20) / 3;
        
        UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(commentLabel.frame.origin.x - 5, commentLabel.frame.origin.y + commentLabel.frame.size.height + 5, kuan, kuan)];
        imageView1.contentMode = UIViewContentModeScaleAspectFill;
        imageView1.clipsToBounds = YES;
        self.imageView1 = imageView1;
        [commentBgview addSubview:imageView1];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView1.frame.origin.x + imageView1.frame.size.width + 5, imageView1.frame.origin.y , kuan, kuan)];
        imageView2.contentMode = UIViewContentModeScaleAspectFill;
        imageView2.clipsToBounds = YES;
        self.imageView2 = imageView2;
        [commentBgview addSubview:imageView2];
        
        UIImageView * imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView2.frame.origin.x + imageView2.frame.size.width + 5, imageView2.frame.origin.y , kuan, kuan)];
        imageView3.contentMode = UIViewContentModeScaleAspectFill;
        imageView3.clipsToBounds = YES;
        self.imageView3 = imageView3;
        [commentBgview addSubview:imageView3];
        
        UIImageView * imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView1.frame.origin.x, imageView1.frame.origin.y + imageView1.frame.size.height + 5, kuan, kuan)];
        imageView4.contentMode = UIViewContentModeScaleAspectFill;
        imageView4.clipsToBounds = YES;
        self.imageView4 = imageView4;
        [commentBgview addSubview:imageView4];
        
        UIImageView * imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView2.frame.origin.x, imageView2.frame.origin.y + imageView2.frame.size.height + 5, kuan, kuan)];
        imageView5.contentMode = UIViewContentModeScaleAspectFill;
        imageView5.clipsToBounds = YES;
        self.imageView5 = imageView5;
        [commentBgview addSubview:imageView5];
        
        UIImageView * imageView6 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView3.frame.origin.x, imageView3.frame.origin.y + imageView3.frame.size.height + 5, kuan, kuan)];
        imageView6.contentMode = UIViewContentModeScaleAspectFill;
        imageView6.clipsToBounds = YES;
        self.imageView6 = imageView6;
        [commentBgview addSubview:imageView6];
    }
    return self;
}

+ (id)sellerCellWithTableView:(UITableView *)tableView
{
    static NSString * reuseID = @"comment";
    SellerEvaluateListActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[SellerEvaluateListActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setToSellerModel:(TosellerModel *)toSellerModel
{
    _toSellerModel = toSellerModel;

    NSDictionary * buyerDic = toSellerModel.buyer;
    self.nameLabel.text = [NSString stringWithFormat:@"求购人:%@",[buyerDic objectForKey:@"nickname"]];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:toSellerModel.cover] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    self.goodsImg.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImg.clipsToBounds = YES;
    self.titleLabel.text = toSellerModel.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",toSellerModel.orderAmount];
    
    NSString *sayStr = toSellerModel.content;
    if ([sayStr isEqualToString:@"0"]) {
        sayStr = @"无评价内容";
    }
    self.commentLabel.text = sayStr;
    
    if ([toSellerModel.isCommented isEqualToString:@"1"]) {
        //计算评论高度
        CGRect commentRect = [toSellerModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: SIZE_FOR_14} context:nil];
        CGRect rect = self.commentLabel.frame;
        rect.size.height = commentRect.size.height;
        self.commentLabel.frame = rect;
        
        CGRect rectComment = self.commentBgview.frame;
        rectComment.size.height = 10 + 10 + 16 + rect.size.height + 7;
        self.commentBgview.frame = rectComment;
    }
//    else{
//        self.commentBgview.frame = CGRectMake(15, self.commentImg.frame.size.height + self.commentImg.frame.origin.y, SCREEN_WIDTH - 30, 45);
//        self.noBuyerCommentLabel.frame = CGRectMake((self.commentBgview.frame.size.width - 120)/2, 16, 120, 14);
//    }

    CGRect rectComment = self.commentBgview.frame;
    
    float kuan = 0;
    
    NSArray * imageArr = [toSellerModel.photos componentsSeparatedByString:@","];
    if (!toSellerModel.photos || toSellerModel.photos.length == 0) {
        imageArr = [[NSArray alloc] init];
    }
    if (imageArr.count) {
        kuan = (self.commentBgview.frame.size.width - 20) / 3;
    }
    if (imageArr.count > 3) {
        kuan *= 2;
    }
    
    if ([toSellerModel.isCommented isEqualToString:@"0"]) {
        self.noBuyerCommentLabel.hidden = NO;
        self.noBuyerCommentLabel.text = @"求购人还没有评价";
        self.commentForImg.hidden = YES;
        self.goodComment.hidden = YES;
    }else{
        self.noBuyerCommentLabel.hidden = YES;
        self.commentForImg.hidden = NO;
        self.goodComment.hidden = NO;
        if ([toSellerModel.grade isEqualToString:@"1"]) {
            self.commentForImg.image = [UIImage imageNamed:@"s_good"];
            self.goodComment.text = @"综合评分：好评";
        }else if([toSellerModel.grade isEqualToString:@"0"]){
            self.commentForImg.image = [UIImage imageNamed:@"s_middle"];
            self.goodComment.text = @"综合评分：中评";
        }else if([toSellerModel.grade isEqualToString:@"-1"]){
            self.commentForImg.image = [UIImage imageNamed:@"s_negative"];
            self.goodComment.text = @"综合评分：差评";
        }else{
            self.commentForImg.image = [UIImage imageNamed:@"s_fake"];
            self.goodComment.text = @"综合评分：假货";
        }
    }
    
    rectComment.size.height = 10 + 10 + 16 + self.commentLabel.frame.size.height + 7 + kuan + 5;
    self.commentBgview.frame = rectComment;

    if (imageArr.count == 0) {
        
        self.imageView1.hidden = YES;
        self.imageView2.hidden = YES;
        self.imageView3.hidden = YES;
        self.imageView4.hidden = YES;
        self.imageView5.hidden = YES;
        self.imageView6.hidden = YES;
        //self.imageView1.y = self.commentLabel.y + self.commentLabel.height + 5;
    }
    else if (imageArr.count == 1) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        self.imageView1.hidden = NO;
        self.imageView2.hidden = YES;
        self.imageView3.hidden = YES;
        self.imageView4.hidden = YES;
        self.imageView5.hidden = YES;
        self.imageView6.hidden = YES;
        self.imageView1.y = self.commentLabel.y + self.commentLabel.height + 5;
    }else if (imageArr.count == 2) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:imageArr[1]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = YES;
        self.imageView4.hidden = YES;
        self.imageView5.hidden = YES;
        self.imageView6.hidden = YES;
        self.imageView1.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView2.y = self.commentLabel.y + self.commentLabel.height + 5;
        
    }else if (imageArr.count == 3) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:imageArr[1]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:imageArr[2]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = NO;
        self.imageView4.hidden = YES;
        self.imageView5.hidden = YES;
        self.imageView6.hidden = YES;
        self.imageView1.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView2.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView3.y = self.commentLabel.y + self.commentLabel.height + 5;
    }else if (imageArr.count == 4) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:imageArr[1]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:imageArr[2]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView4 sd_setImageWithURL:[NSURL URLWithString:imageArr[3]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = NO;
        self.imageView4.hidden = NO;
        self.imageView5.hidden = YES;
        self.imageView6.hidden = YES;
        self.imageView1.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView2.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView3.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView4.y = self.commentLabel.y + self.commentLabel.height + 5 + self.imageView1.height + 5;
    }else if (imageArr.count == 5) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:imageArr[1]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:imageArr[2]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView4 sd_setImageWithURL:[NSURL URLWithString:imageArr[3]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView5 sd_setImageWithURL:[NSURL URLWithString:imageArr[4]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = NO;
        self.imageView4.hidden = NO;
        self.imageView5.hidden = NO;
        self.imageView6.hidden = YES;
        self.imageView1.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView2.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView3.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView4.y = self.commentLabel.y + self.commentLabel.height + 5 + self.imageView1.height + 5;
        self.imageView5.y = self.commentLabel.y + self.commentLabel.height + 5 + self.imageView1.height + 5;
    }else if (imageArr.count == 6) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:imageArr[1]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:imageArr[2]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView4 sd_setImageWithURL:[NSURL URLWithString:imageArr[3]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView5 sd_setImageWithURL:[NSURL URLWithString:imageArr[4]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView6 sd_setImageWithURL:[NSURL URLWithString:imageArr[5]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = NO;
        self.imageView4.hidden = NO;
        self.imageView5.hidden = NO;
        self.imageView6.hidden = NO;
        self.imageView1.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView2.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView3.y = self.commentLabel.y + self.commentLabel.height + 5;
        self.imageView4.y = self.commentLabel.y + self.commentLabel.height + 5 + self.imageView1.height + 5;
        self.imageView5.y = self.commentLabel.y + self.commentLabel.height + 5 + self.imageView1.height + 5;
        self.imageView6.y = self.commentLabel.y + self.commentLabel.height + 5 + self.imageView1.height + 5;
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
