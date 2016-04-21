//
//  GoodsOrderListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/8/31.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TopicListCell.h"
#import "CompareCurrentTime.h"

@implementation TopicListCell


- (void)awakeFromNib {
    // Initialization code
    self.avaterIV.layer.masksToBounds = YES;
    self.avaterIV.layer.cornerRadius = self.avaterIV.width * 0.5;
    self.commentBtn.layer.cornerRadius = 4.0f;
    self.praiseBtn.layer.cornerRadius = 4.0f;
    [self.avaterIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaterClicked)]];
    self.markView.width = SCREEN_WIDTH - 33 - 14;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)avaterClicked {
    if (self.avaterClickedBlock) {
        self.avaterClickedBlock(_bussinessModel.account);
    }
}
-(void)setBussinessModel:(BussinessModel *)bussinessModel {
    _bussinessModel = bussinessModel;
    
    [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:bussinessModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.accountLbl.text = bussinessModel.nickname;
    if (bussinessModel.attr_title) {
        self.titleLbl.attributedText = bussinessModel.attr_title;
    }else {
        self.titleLbl.text = bussinessModel.title;
    }
    
    self.contentLbl.text = bussinessModel.model_description;
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:bussinessModel.cover] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    NSArray *marksArray = [bussinessModel.tags componentsSeparatedByString:@","];
    [self.markView setTags:marksArray];
    if (marksArray.count == 0) {
        self.markIV.hidden = YES;
    }
    
    NSString * timeStr = [CompareCurrentTime compareCurrentDate:bussinessModel.updatetimeLong];
    self.timeLbl.text = timeStr;
    
    NSString *consultCount = bussinessModel.consultCount;
    if ([consultCount intValue] >= 100) {
        consultCount = @"99+";
    }
    NSString *likeCount = bussinessModel.likeCount;
    if ([likeCount intValue] >= 100) {
        likeCount = @"99+";
    }
    [self.commentBtn setTitle:[NSString stringWithFormat:@" %@", consultCount] forState:UIControlStateNormal];
    [self.praiseBtn setTitle:[NSString stringWithFormat:@" %@", likeCount] forState:UIControlStateNormal];
    
    
}
-(void)setTagClickedBlock:(TagClickedBlock)tagClickedBlock {
    self.markView.tagClickedBlock = tagClickedBlock;
}
@end
