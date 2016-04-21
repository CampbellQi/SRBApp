//
//  SPListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/19.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BaseSPListCell.h"
#import "TPMarkModel.h"
#import "WQMarkView.h"

@implementation BaseSPListCell

- (void)awakeFromNib {
    // Initialization code
    _unselPointLbl.layer.cornerRadius = _unselPointLbl.width * 0.5;
    _selPointLbl.layer.cornerRadius = _selPointLbl.width * 0.5;
    _unselPointLbl.layer.masksToBounds = YES;
    _selPointLbl.layer.masksToBounds = YES;
    
    _ordersBtn.layer.cornerRadius = 3.0f;
    
    _daysBgView.layer.cornerRadius = 8.0f;
    _daysBgView.layer.borderColor = MAINCOLOR.CGColor;
    _daysBgView.layer.borderWidth = 1.0f;
    
    _avaterIV.layer.cornerRadius = 0.5 * _avaterIV.width;
    _avaterIV.layer.masksToBounds = YES;
    
    _contentBgView.layer.cornerRadius = 4.0f;
    _contentBgView.layer.borderColor = GRAYCOLOR.CGColor;
    _contentBgView.layer.borderWidth = 0.5f;
    
    _sameBtn.layer.cornerRadius = CGRectGetHeight(_sameBtn.frame) * 0.5;
    _sameBtn.layer.borderColor = GRAYCOLOR.CGColor;
    _sameBtn.layer.borderWidth = 0.5f;
    
    _consultBtn.layer.cornerRadius = CGRectGetHeight(_sameBtn.frame) * 0.5;
    _consultBtn.layer.borderColor = GRAYCOLOR.CGColor;
    _consultBtn.layer.borderWidth = 0.5f;
    
    //留言
    [self.memoLbl addTapAction:@selector(spreadBtnClicked:) forTarget:self];
    
    [self.positionBtn addTarget:self action:@selector(positionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //查看原文
    [self.originalTextBtn addTarget:self action:@selector(originalTextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //分享
    [self.shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //长草
    [self.grassBtn addTarget:self action:@selector(grassBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //咨询
    [self.consultBtn addTarget:self action:@selector(consultBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //同求
    [self.sameBtn addTarget:self action:@selector(sameBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //头像
    [self.avaterIV addTapAction:@selector(avaterIVClicked) forTarget:self];
    //封面
    [self.coverIV addTapAction:@selector(coverIVClicked) forTarget:self];
    //接单
    [self.takingOrderBtn addTarget:self action:@selector(takingOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setSourceModel:(BussinessModel *)sourceModel {
    _sourceModel = sourceModel;
    
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:sourceModel.cover] placeholderImage:[UIImage imageNamed:@"zanwu.png"]];
    NSString * timeStr = [CompareCurrentTime compareCurrentTime:sourceModel.updatetimeLong];
    self.timeLbl.text = timeStr;
    self.sizeLbl.text = sourceModel.size;
    if (sourceModel.originalPrice && sourceModel.originalPrice.length != 0 && [sourceModel.originalPrice floatValue] != 0) {
        self.originalPriceLbl.text = [NSString stringWithFormat:@"￥ %d 元 以内/件", [sourceModel.originalPrice intValue]];
    }else {
        self.originalPriceLbl.text = @"";
    }
    
    self.shoplandLbl.text = sourceModel.shopland;
    self.memoLbl.text = sourceModel.say;
    self.countLbl.text = sourceModel.storage;
    self.daysLbl.text = [NSString stringWithFormat:@"剩余\n%@天", sourceModel.endday];
    
    [self.grassBtn setTitle:[NSString stringWithFormat:@"长草 %@", sourceModel.favCount] forState:UIControlStateNormal];
    
     //self.consultBtn.text = [NSString stringWithFormat:@"咨询 %@", sourceModel.consultCount];
     //self.sameLbl.text = [NSString stringWithFormat:@"同求 %@", sourceModel.quotes];
    [self.consultBtn setTitle:[NSString stringWithFormat:@"咨询 %@", sourceModel.consultCount] forState:UIControlStateNormal];
    [self.sameBtn setTitle:[NSString stringWithFormat:@"同求 %@", sourceModel.quotes] forState:UIControlStateNormal];
    
    [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:sourceModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu.png"]];
    self.nicknameLbl.text = sourceModel.nickname;

    //位置
    if (!sourceModel.model_position || sourceModel.model_position.length == 0) {
        self.positionBtn.hidden = YES;
    }else {
        self.positionBtn.hidden = NO;
        [self.positionBtn setTitle:[NSString stringWithFormat:@" %@", sourceModel.model_position] forState:UIControlStateNormal];
    }
    //原文链接
    if ([sourceModel.parentId isEqualToString:@"0"]) {
        self.originalTextBtn.hidden = YES;
    }else {
        self.originalTextBtn.hidden = NO;
    }
    
    //接单
    if ([self.sourceModel.account isEqualToString:ACCOUNT_SELF]) {
        NSLog(@"%@",self.sourceModel.account);
        [self.takingOrderBtn setTitle:@"删 除" forState:UIControlStateNormal];
    }else{
        [self.takingOrderBtn setTitle:@"接 单" forState:UIControlStateNormal];
    }
}

-(void)positionBtnClicked:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(PostionBtn, _sourceModel);
    }
}
-(void)originalTextBtnClicked:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(OriginalTextBtn, _sourceModel);
    }
}
-(void)shareBtnClicked:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(ShareBtn, _sourceModel);
    }
}
-(void)grassBtnClicked:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(GrassBtn, _sourceModel);
    }
}
-(void)consultBtnClicked:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(ConsultBtn, _sourceModel);
    }
}
-(void)sameBtnClicked:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(SameBtn, _sourceModel);
    }
}
-(void)takingOrderBtnClicked:(UIButton *)sender {
    if (([self.sourceModel.account isEqualToString:ACCOUNT_SELF])) {
        if (self.actionBlock) {
            self.actionBlock(DeleteOrderBtn, _sourceModel);
        }
    }else {
        if (self.actionBlock) {
            self.actionBlock(TakingOrderBtn, _sourceModel);
        }
    }
    
}
-(void)avaterIVClicked {
    if (self.actionBlock) {
        self.actionBlock(AvaterIV, _sourceModel);
    }
}
-(void)coverIVClicked {
    if (self.actionBlock) {
        self.actionBlock(CoverIV, _sourceModel);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)spreadBtnClicked:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(SpreadBtn, _sourceModel);
    }
}

-(void)showMarksView {
    for (UIView *iv in self.coverIV.subviews) {
        [iv removeFromSuperview];
    }
    //添加标签
    for (NSDictionary *dict in self.sourceModel.labels) {
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
@end
