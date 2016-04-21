//
//  BaseGoodsCollectionCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BaseGoodsCollectionCell.h"

@implementation BaseGoodsCollectionCell
-(void)awakeFromNib {
    [super awakeFromNib];
    self.avaterIV.layer.masksToBounds = YES;
    self.avaterIV.layer.cornerRadius = self.avaterIV.width * 0.5;
}
-(void)setSourceModel:(BussinessModel *)sourceModel {
    _sourceModel = sourceModel;
    //商品
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:sourceModel.cover] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.nameLbl.text = sourceModel.title;
    self.priceLbl.text = [NSString stringWithFormat:@"￥ %@",sourceModel.bangPrice];
    self.brandLbl.text = sourceModel.brand;
    //用户
    [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:sourceModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.nickName.text = self.sourceModel.nickname;
    self.reliableindexLbl.text = [NSString stringWithFormat:@"靠谱指数：%@",self.sourceModel.evaluationper];
}
-(void)setSelected:(BOOL)selected {

}

@end
