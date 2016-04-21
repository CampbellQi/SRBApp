//
//  PublishTopicImageCell.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PublishTopicImageCell.h"
#import "TPMarkModel.h"
#import "WQMarkView.h"

@implementation PublishTopicImageCell

- (void)awakeFromNib {
    // Initialization code
     [super awakeFromNib];
    [self.contentIV addTapAction:@selector(contentIVTap) forTarget:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)contentIVTap {
    if (self.editBlock) {
        self.editBlock(self);
    }
}

-(void)showMarksView {
    //NSLog(@"coverSize = %@", NSStringFromCGRect(self.coverIV.frame));
    for (UIView *iv in self.contentIV.subviews) {
        [iv removeFromSuperview];
    }
    
    //    float width = SCREEN_WIDTH - 2 * CGRectGetMinX(self.coverIV.frame);
    //    float height = width * 3 / 4;
    float width = CGRectGetWidth(self.contentIV.frame);
    float height = CGRectGetHeight(self.contentIV.frame);
    //添加标签
    for (TPMarkModel *model in self.marksArray) {
        WQMarkView *mark = [WQMarkView produceWithData:model];
        NSArray *xyz = [model.xyz componentsSeparatedByString:@","];
        mark.currentPoint = CGPointMake([xyz[0] floatValue] * width, [xyz[1] floatValue] * height);
        [self.contentIV addSubview:mark];
        [mark resetCenter];
        mark.isFreeze = YES;
        
    }
}

@end
