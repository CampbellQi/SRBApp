//
//  TopicDetailListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TopicDetailListCell.h"

@implementation TopicDetailListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSourceData:(TopicDetailModel *)sourceData {
    _sourceData = sourceData;
    //NSString *photos = sourceData.photos;
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:sourceData.cover] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//    NSArray *photosArr = [photos componentsSeparatedByString:@","];
//    if (photosArr.count > 0) {
//        [self.coverIV sd_setImageWithURL:[NSURL URLWithString:photosArr[0]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//    }
    self.contentLbl.attributedText = sourceData.attrContent;
    //NSLog(@"%@", sourceData[@"content"]);
}
@end
