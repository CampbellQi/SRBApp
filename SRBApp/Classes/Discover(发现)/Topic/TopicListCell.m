//
//  GoodsOrderListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/8/31.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define DESC_PLACEHOLDER  @"请不要超过60个字哦~"
#import "TopicListCell.h"
#import "CompareCurrentTime.h"
#import "WQMarkView.h"
#import "TPMarkModel.h"
#import "InputMarkController.h"

@implementation TopicListCell


- (void)awakeFromNib {
    // Initialization code
    self.avaterIV.layer.masksToBounds = YES;
    self.avaterIV.layer.cornerRadius = self.avaterIV.width * 0.5;
    self.commentBtn.layer.cornerRadius = 4.0f;
    self.praiseBtn.layer.cornerRadius = 4.0f;
    //self.contentView.layer.masksToBounds = YES;
    //self.contentView.layer.borderColor = GRAYCOLOR.CGColor;
    //self.contentView.layer.borderWidth = 1.0f;
    
    [self.avaterIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaterClicked)]];
    self.markView.width = SCREEN_WIDTH - 33 - 14;
    //[self.markView setLabelBackgroundColor:[UIColor yellowColor]];
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
    if (bussinessModel.tags.length) {
        NSArray *marksArray = [bussinessModel.tags componentsSeparatedByString:@","];
        [self.markView setTags:marksArray];
        self.markIV.hidden = NO;
    }else {
        self.markIV.hidden = YES;
    }
    
    
    NSString * timeStr = [CompareCurrentTime compareCurrentTime:bussinessModel.updatetimeLong];
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

-(void)showMarksView {
    for (UIView *iv in self.coverIV.subviews) {
        [iv removeFromSuperview];
    }
    //添加标签
    for (NSDictionary *dict in self.bussinessModel.labels) {
        TPMarkModel *model = [[TPMarkModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        WQMarkView *mark = [WQMarkView produceWithData:model];
        NSArray *xyz = [dict[@"xyz"] componentsSeparatedByString:@","];
        mark.currentPoint = CGPointMake([xyz[0] floatValue] * CGRectGetWidth(self.coverIV.frame), [xyz[1] floatValue] * CGRectGetHeight(self.coverIV.frame));
        [self.coverIV addSubview:mark];
        [mark resetCenter];
        mark.isFreeze = YES;
        
    }
}
-(void)setTagClickedBlock:(TagClickedBlock)tagClickedBlock {
    self.markView.tagClickedBlock = tagClickedBlock;
}
@end
