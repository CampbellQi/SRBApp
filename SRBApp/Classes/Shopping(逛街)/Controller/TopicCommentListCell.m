//
//  TopicCommentListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TopicCommentListCell.h"
#import "CompareCurrentTime.h"

@implementation TopicCommentListCell

- (void)awakeFromNib {
    // Initialization code
    self.avaterIV.layer.masksToBounds = YES;
    self.avaterIV.layer.cornerRadius = self.avaterIV.width * 0.5;
    [self.avaterIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaterClicked)]];
}
-(void)setSourceModel:(TopicCommentModel *)sourceModel {
    _sourceModel = sourceModel;
    self.accountLbl.text = sourceModel.nickname;
    self.contentLbl.attributedText = sourceModel.attrContent;
    [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:sourceModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    NSString * timeStr = [CompareCurrentTime compareCurrentTime:sourceModel.updatetimeLong];
    self.timeLbl.text = timeStr;
}
-(void)avaterClicked {
    if (self.avaterClickedBlock) {
        self.avaterClickedBlock(_sourceModel.account);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
