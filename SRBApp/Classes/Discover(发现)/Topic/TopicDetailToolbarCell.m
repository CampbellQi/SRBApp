//
//  TopicDetailToolbarCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/10.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "TopicDetailToolbarCell.h"

@implementation TopicDetailToolbarCell

- (void)awakeFromNib {
    // Initialization code
    [self.purchiseBtn addTarget:self action:@selector(purchiseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.usedBtn addTarget:self action:@selector(usedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.grassBtn addTarget:self action:@selector(grassBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.turnBtn addTarget:self action:@selector(turnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

//求购
-(void)purchiseBtnClicked:(UIButton *)sender {
    if (self.btnClickedBlock) {
        self.btnClickedBlock(purchiseBtn, self.sourceModel);
    }
}
//用过
-(void)usedBtnClicked:(UIButton *)sender{
    if (self.btnClickedBlock) {
        self.btnClickedBlock(usedBtn, self.sourceModel);
    }
}
//长草
-(void)grassBtnClicked:(UIButton *)sender{
    if (self.btnClickedBlock) {
        self.btnClickedBlock(grassBtn, self.sourceModel);
    }
}
//转需
-(void)turnBtnClicked:(UIButton *)sender{
    if (self.btnClickedBlock) {
        self.btnClickedBlock(turnBtn, self.sourceModel);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSourceModel:(TopicDetailModel *)sourceModel {
    _sourceModel = sourceModel;
    self.purchiseCountLlb.text = sourceModel.quotes;
    self.grassCountLbl.text = sourceModel.favCount;
}
@end
