//
//  PublishTopicTextCell.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PublishTopicTextCell.h"

@implementation PublishTopicTextCell

- (void)awakeFromNib {
    // Initialization code
     [super awakeFromNib];
    [self.textLbl addTapAction:@selector(textTap) forTarget:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textTap {
    if (self.editBlock) {
        self.editBlock(self);
    }
}
- (IBAction)deleteBtnClicked:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}
@end
