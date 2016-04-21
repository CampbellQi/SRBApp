//
//  TopicDetailHeaderView.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/10.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "TopicDetailHeaderView.h"

@implementation TopicDetailHeaderView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"TopicDetailHeaderView" owner:self options:nil][0];
        [self addSubview:self.topView];
        self.topView.clipsToBounds = YES;
        self.clipsToBounds = YES;
        self.topView.frame = self.bounds;
        
        self.avaterIV.layer.masksToBounds = YES;
        self.avaterIV.layer.cornerRadius = 0.5 * self.avaterIV.width;
        
        [self.avaterIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaterClicked)]];
    }
    return self;
}
-(void)setTagClickedBlock:(TagClickedBlock)tagClickedBlock {
    self.markView.tagClickedBlock = tagClickedBlock;
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
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
