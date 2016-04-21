//
//  SpotGoodsCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/12/15.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SpotGoodsCell.h"

@implementation SpotGoodsCell

-(void)setSourceModel:(BussinessModel *)sourceModel {
    _sourceModel = sourceModel;
    //商品
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:sourceModel.cover] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.nameLbl.text = sourceModel.title;
    self.priceLbl.text = [NSString stringWithFormat:@"￥ %@",sourceModel.bangPrice];
    self.brandLbl.text = sourceModel.brand;
}
- (IBAction)editBtnClicked:(id)sender {
    if (self.editBlock) {
        self.editBlock(self.sourceModel);
    }
}
@end
