//
//  MyEvaluateListCell.m
//  SRBApp
//
//  Created by zxk on 14/12/25.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyEvaluateListCell.h"
#import <UIImageView+WebCache.h>
#import "WQOneToSixPhotosView.h"

@implementation MyEvaluateListCell

+ (id)sellerCellWithTableView:(UITableView *)tableView
{
    static NSString * reuseID = @"comment";
    MyEvaluateListCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[MyEvaluateListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setToSellerModel:(TosellerModel *)toSellerModel
{

    NSDictionary * sellerDic = toSellerModel.seller;
    NSDictionary * buyerDic = toSellerModel.buyer;
    self.nameLabel.text = [NSString stringWithFormat:@"代购人：%@",[sellerDic objectForKey:@"nickname"]];
    //self.buyerLabel.text = [NSString stringWithFormat:@"求购：%@",[buyerDic objectForKey:@"nickname"]];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:toSellerModel.cover] placeholderImage:[UIImage imageNamed:@"wutu.png"]];

    self.titleLabel.text = toSellerModel.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",toSellerModel.orderAmount];
    
    NSString *sayStr = toSellerModel.content;
    self.commentLabel.text = sayStr;
    
    //计算评论高度
    CGRect commentRect = [toSellerModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: SIZE_FOR_14} context:nil];
    CGRect rect = self.commentLabel.frame;
    rect.size.height = commentRect.size.height;
    self.commentLabel.frame = rect;
    
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
    
    rectComment.size.height = 10 + 10 + 16 + rect.size.height + 7 + kuan + 5;
    self.commentBgview.frame = rectComment;
    
    if ([toSellerModel.grade isEqualToString:@"1"]) {
        self.commentForImg.image = [UIImage imageNamed:@"s_good"];
        self.goodComment.text = @"综合评分：好评";
    }else if([toSellerModel.grade isEqualToString:@"0"]){
        self.commentForImg.image = [UIImage imageNamed:@"s_middle"];
        self.goodComment.text = @"综合评分：中评";
    }else if([toSellerModel.grade isEqualToString:@"-1"]){
        self.commentForImg.image = [UIImage imageNamed:@"s_negative"];
        self.goodComment.text = @"综合评分：差评";
    }else if([toSellerModel.isCommented isEqualToString: @"0"]){
        self.goodComment.text = @"求购人还未评价:(";
        self.commentBgview.height = 10 + 10 + 16 + 7;
        self.goodComment.textColor = [GetColor16 hexStringToColor:@"#c6c6c6"];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 40, 16)];
        self.goodComment.frame = view.frame;
        self.goodComment.textAlignment = NSTextAlignmentCenter;
    }else
    {
        self.commentForImg.image = [UIImage imageNamed:@"s_fake"];
        self.goodComment.text = @"综合评分：假货";
    }
    //NSArray * imageArr = [toSellerModel.photos componentsSeparatedByString:@","];
    if (imageArr.count == 0) {
        
        self.imageView1.hidden = YES;
        self.imageView2.hidden = YES;
        self.imageView3.hidden = YES;
        self.imageView4.hidden = YES;
        self.imageView5.hidden = YES;
        self.imageView6.hidden = YES;
        //self.imageView1.y = CGRectGetMaxY(self.commentLabel.frame) + 5;
    }
    if (imageArr.count == 1) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        self.imageView1.hidden = NO;
        self.imageView2.hidden = YES;
        self.imageView3.hidden = YES;
        self.imageView4.hidden = YES;
        self.imageView5.hidden = YES;
        self.imageView6.hidden = YES;
        self.imageView1.y = CGRectGetMaxY(self.commentLabel.frame) + 5;
    }else if (imageArr.count == 2) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:imageArr[1]] placeholderImage:[UIImage imageNamed:@"wutu"]];
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = YES;
        self.imageView4.hidden = YES;
        self.imageView5.hidden = YES;
        self.imageView6.hidden = YES;
        self.imageView1.y = CGRectGetMaxY(self.commentLabel.frame) + 5;
        self.imageView2.y = CGRectGetMinY(self.imageView1.frame);
        
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
        self.imageView1.y = CGRectGetMaxY(self.commentLabel.frame) + 5;
        self.imageView2.y = CGRectGetMaxY(self.commentLabel.frame) + 5;
        self.imageView3.y = CGRectGetMaxY(self.commentLabel.frame) + 5;
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
        self.imageView4.y = self.commentLabel.y + self.commentLabel.height + 5 + self.imageView1.height +5;
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
        self.imageView4.y = self.commentLabel.y + self.commentLabel.height + 5 + self.imageView1.height +  5;
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
