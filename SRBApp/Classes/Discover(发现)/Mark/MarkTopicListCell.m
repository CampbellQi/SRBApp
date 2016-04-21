//
//  MarkTopicListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/10.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MarkTopicListCell.h"
#import "CompareCurrentTime.h"

@implementation MarkTopicListCell

- (void)awakeFromNib {
    // Initialization code
    self.avaterIV.layer.masksToBounds = YES;
    self.avaterIV.layer.cornerRadius = self.avaterIV.width * 0.5;
}
-(void)setBussinessModel:(BussinessModel *)bussinessModel {
    _bussinessModel = bussinessModel;
    self.titleLbl.text = bussinessModel.title;
    self.contentLbl.text = bussinessModel.model_description;
    
    [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:bussinessModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.accountLbl.text = bussinessModel.nickname;
    
    NSString *consultCount = bussinessModel.consultCount;
    if ([consultCount intValue] >= 100) {
        consultCount = @"99+";
    }
    NSString *likeCount = bussinessModel.likeCount;
    if ([likeCount intValue] >= 100) {
        likeCount = @"99+";
    }
    
    self.commentCountLbl.text = consultCount;
    self.collectCountLbl.text = likeCount;
    NSString * timeStr = [CompareCurrentTime compareCurrentTime:bussinessModel.updatetimeLong];
    self.timeLbl.text = timeStr;
    
    self.IV1.hidden = YES;
    self.IV2.hidden = YES;
    self.IV3.hidden = YES;

    NSArray *photosArray = nil;
    if (bussinessModel.photos.length != 0) {
        photosArray = [bussinessModel.photos componentsSeparatedByString:@","];
    }
    if (photosArray.count) {
        if (photosArray.count >= 1) {
            [self.IV1 sd_setImageWithURL:[NSURL URLWithString:photosArray[0]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.IV1.hidden = NO;
        }
        if (photosArray.count >= 2) {
            [self.IV2 sd_setImageWithURL:[NSURL URLWithString:photosArray[1]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.IV2.hidden = NO;
        }
        
        if (photosArray.count >= 3) {
            [self.IV3 sd_setImageWithURL:[NSURL URLWithString:photosArray[2]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.IV3.hidden = NO;
        }
    }else {
        if (bussinessModel.cover.length != 0) {
            [self.IV1 sd_setImageWithURL:[NSURL URLWithString:bussinessModel.cover] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.IV1.hidden = NO;
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
