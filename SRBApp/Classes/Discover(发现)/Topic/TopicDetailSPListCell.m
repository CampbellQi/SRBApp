//
//  TopicDetailSPListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/10.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "TopicDetailSPListCell.h"

@implementation TopicDetailSPListCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setCover:(NSString *)cover {
    _cover = cover;
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:_cover] placeholderImage:[UIImage imageNamed:@"zanwu"]];
}
-(void)setSourceModel:(TPMarkModel *)sourceModel {
    _sourceModel = sourceModel;
    self.brandLbl.text = sourceModel.brand;
    self.nameLbl.text = sourceModel.name;
    self.orignLbl.text = sourceModel.origin;
    self.refPriceLbl.text = sourceModel.shopprice;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
