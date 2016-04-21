//
//  PersonalBaseSPListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalBaseSPFilingsListCell.h"

@implementation PersonalBaseSPFilingsListCell
{
}
- (void)awakeFromNib {
    // Initialization code
    
    _spAvaterIV1.layer.cornerRadius = 0.5 * _spAvaterIV1.width;
    _spAvaterIV1.layer.masksToBounds = YES;
    _spAvaterIV2.layer.cornerRadius = 0.5 * _spAvaterIV2.width;
    _spAvaterIV2.layer.masksToBounds = YES;
    _spAvaterIV3.layer.cornerRadius = 0.5 * _spAvaterIV3.width;
    _spAvaterIV3.layer.masksToBounds = YES;
    
    _spotGoodsAvaterIV1.layer.cornerRadius = 0.5 * _spAvaterIV1.width;
    _spotGoodsAvaterIV1.layer.masksToBounds = YES;
    _spotGoodsAvaterIV2.layer.cornerRadius = 0.5 * _spotGoodsAvaterIV2.width;
    _spotGoodsAvaterIV2.layer.masksToBounds = YES;
    _spotGoodsAvaterIV3.layer.cornerRadius = 0.5 * _spotGoodsAvaterIV3.width;
    _spotGoodsAvaterIV3.layer.masksToBounds = YES;
    
    _grayBtn.layer.cornerRadius = 4.0f;
    _pinkBtn.layer.cornerRadius = 4.0f;
    
    _contentBgView.layer.cornerRadius = 4.0f;
    _contentBgView.layer.borderColor = GRAYCOLOR.CGColor;
    _contentBgView.layer.borderWidth = 0.5f;
    
    [self.helpSPApplySuperView addTapAction:@selector(helpSpApplyTap:) forTarget:self];
    [self.spotGoodsGroomSuperView addTapAction:@selector(spotGoodsGroomTap:) forTarget:self];
    
    [self.goodsSuperView addTapAction:@selector(goodsTap:) forTarget:self];
}
-(void)setSourceModel:(BussinessModel *)sourceModel {
    _sourceModel = sourceModel;
    
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:sourceModel.cover] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image.size.height > image.size.width) {
            self.coverIV.contentMode = UIViewContentModeScaleToFill;
        }else{
            self.coverIV.contentMode = UIViewContentModeScaleAspectFit;
        }
    }];
    self.brandLbl.text = sourceModel.brand;
    self.nameLbl.text = sourceModel.title;
    self.sizeLbl.text = sourceModel.size;
    self.amountLbl.text = [NSString stringWithFormat:@"x %@", sourceModel.storage];
    
    self.spApplyCountLbl.text = [NSString stringWithFormat:@"代购申请 %@", _sourceModel.taskcount];
    self.spotGoodsGroomLbl.text = [NSString stringWithFormat:@"现货推荐 %@", _sourceModel.handcount];
    self.timeLbl.text = sourceModel.taskLostNote;
    
    //申请代购用户头像
    _spAvaterIV1.hidden = YES;
    _spAvaterIV2.hidden = YES;
    _spAvaterIV3.hidden = YES;
    if (sourceModel.taskuser.count > 0) {
        [_spAvaterIV1 sd_setImageWithURL:[NSURL URLWithString:sourceModel.taskuser[0][@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        _spAvaterIV1.hidden = NO;
    }
    if (sourceModel.taskuser.count > 1) {
        [_spAvaterIV2 sd_setImageWithURL:[NSURL URLWithString:sourceModel.taskuser[1][@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        _spAvaterIV2.hidden = NO;
    }
    if (sourceModel.taskuser.count > 2) {
        [_spAvaterIV3 sd_setImageWithURL:[NSURL URLWithString:sourceModel.taskuser[2][@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        _spAvaterIV3.hidden = NO;
    }
    
    //现货推荐用户头像
    _spotGoodsAvaterIV1.hidden = YES;
    _spotGoodsAvaterIV2.hidden = YES;
    _spotGoodsAvaterIV3.hidden = YES;
    
    if (sourceModel.handuser.count > 0) {
        [_spotGoodsAvaterIV1 sd_setImageWithURL:[NSURL URLWithString:sourceModel.handuser[0][@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        _spotGoodsAvaterIV1.hidden = NO;
    }
    if (sourceModel.handuser.count > 1) {
        [_spotGoodsAvaterIV2 sd_setImageWithURL:[NSURL URLWithString:sourceModel.handuser[1][@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        _spotGoodsAvaterIV2.hidden = NO;
    }
    if (sourceModel.handuser.count > 2) {
        [_spotGoodsAvaterIV3 sd_setImageWithURL:[NSURL URLWithString:sourceModel.handuser[2][@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        _spotGoodsAvaterIV3.hidden = NO;
    }
    
    //设置操作按钮
    [self setUpOperateView];
    
}

-(void)setUpOperateView {
    if ([self.operateSuperView viewWithTag:100]) {
        [[self.operateSuperView viewWithTag:100] removeFromSuperview];
    }
    float height = CGRectGetHeight(self.operateSuperView.frame);
    PersonalOrderOperateView *view = [[PersonalOrderOperateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, height) OrderStatus:_sourceModel.taskStatus CurrentViewController:self.currentVC BussinessModel:_sourceModel];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 100;
    [self.operateSuperView addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)helpSpApplyTap:(id)sender {
    if (self.helpSpApplyTapBlock && _sourceModel.taskuser.count) {
        self.helpSpApplyTapBlock(_sourceModel);
    }
}

- (void)spotGoodsGroomTap:(id)sender {
    if (self.spotGoodsGroomTapBlock && _sourceModel.handuser.count) {
        self.spotGoodsGroomTapBlock(_sourceModel);
    }
}
- (void)goodsTap:(id)sender {
    if (self.goodsTapBlock) {
        self.goodsTapBlock(_sourceModel);
    }
}
@end
