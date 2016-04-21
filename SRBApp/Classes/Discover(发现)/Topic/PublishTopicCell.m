//
//  PublishTopicCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "PublishTopicCell.h"



@implementation PublishTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imageIV addTapAction:@selector(imageIVTap) forTarget:self];
    [self.textIV addTapAction:@selector(textTap) forTarget:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)imageIVTap {
    if (self.imageTapBlock) {
        self.imageTapBlock(self);
    }
}
-(void)textTap {
    if (self.textTapBlock) {
        self.textTapBlock(self);
    }
}


@end
