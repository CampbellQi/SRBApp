//
//  TopicDetailListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TopicDetailListImageCell.h"
#import "TPMarkModel.h"
#import "WQMarkView.h"
#import "InputMarkController.h"

@implementation TopicDetailListImageCell

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
    //NSLog(@"%@", sourceData[@"content"]);
}

-(void)showMarksView {
    //NSLog(@"coverSize = %@", NSStringFromCGRect(self.coverIV.frame));
    for (UIView *iv in self.coverIV.subviews) {
        [iv removeFromSuperview];
    }
    
//    float width = SCREEN_WIDTH - 2 * CGRectGetMinX(self.coverIV.frame);
//    float height = width * 3 / 4;
    float width = CGRectGetWidth(self.coverIV.frame);
    float height = CGRectGetHeight(self.coverIV.frame);
    //添加标签
    for (NSDictionary *dict in self.sourceData.labels) {
        TPMarkModel *model = [[TPMarkModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        WQMarkView *mark = [WQMarkView produceWithData:model];
        NSArray *xyz = [dict[@"xyz"] componentsSeparatedByString:@","];
        mark.currentPoint = CGPointMake([xyz[0] floatValue] * width, [xyz[1] floatValue] * height);
        [self.coverIV addSubview:mark];
        [mark resetCenter];
        mark.isFreeze = YES;
        
    }
}
-(void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    //NSLog(@"coverSize = %@", NSStringFromCGRect(self.coverIV.frame));
}
-(void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"coverSize = %@", NSStringFromCGRect(self.coverIV.frame));
}
@end
