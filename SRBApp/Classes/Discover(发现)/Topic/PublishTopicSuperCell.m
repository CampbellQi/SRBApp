//
//  PublishTopicSuperCell.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PublishTopicSuperCell.h"

@implementation PublishTopicSuperCell

- (void)awakeFromNib {
    // Initialization code
    self.bgView.layer.cornerRadius = 4.0f;
    self.bgView.layer.borderColor = DICECOLOR(214, 214, 214, 1).CGColor;
    self.bgView.layer.borderWidth = 1.0f;
    //self.bgView.backgroundColor = [UIColor whiteColor];
}
- (IBAction)addBtnClicked:(id)sender {
    if (self.addBlock) {
        self.addBlock(self);
    }
}
- (IBAction)deleteBtnClicked:(id)sender {
    if ((self.deleteBlock)) {
        self.deleteBlock(self);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)prepareForMove {
    self.contentView.hidden = YES;
}
@end
