//
//  PersonalBaseHelpSPListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalBaseSPListCell.h"
#import "PersonalOrderOperateView.h"

@implementation PersonalBaseSPListCell

- (void)awakeFromNib {
    // Initialization code
    _avaterIV.layer.cornerRadius = 0.5 * _avaterIV.width;
    _avaterIV.layer.masksToBounds = YES;
    
    _ContentBgView.layer.cornerRadius = 4.0f;
    _ContentBgView.layer.borderColor = GRAYCOLOR.CGColor;
    _ContentBgView.layer.borderWidth = 0.5f;
    [self.avaterIV addTapAction:@selector(avaterIVClicked) forTarget:self];
    [self.goodsSuperView addTapAction:@selector(goodsTapClicked) forTarget:self];
}
-(void)avaterIVClicked {
    if (self.avaterIVBlock) {
        NSString *account = @"";
        if (![_sourceModel.account isEqualToString:ACCOUNT_SELF]) {
            account = _sourceModel.account;
        }else {
            account = _sourceModel.seller[@"account"];
        }
        self.avaterIVBlock(account);
    }
}
-(void)goodsTapClicked {
    if (self.goodsSuperViewTapBlock) {
        self.goodsSuperViewTapBlock(self.sourceModel);
    }
}
-(void)setSourceModel:(BussinessModel *)sourceModel {
    _sourceModel = sourceModel;
    
    if ([self.operateSuperView viewWithTag:100]) {
        [[self.operateSuperView viewWithTag:100] removeFromSuperview];
    }
    
    [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:sourceModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.nickNameLbl.text = sourceModel.nickname;
    
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
    self.timeLbl.text = [NSString stringWithFormat:@"%@", _sourceModel.taskLostNote];
    //我的代购
    if (![sourceModel.account isEqualToString:ACCOUNT_SELF]) {
        
        if ([@[@"0", @"20", @"-20"] containsObject:_sourceModel.taskStatus]) {
            //申请中
            self.statusLbl.text = sourceModel.bid[@"statusName"];
        }else {
            self.statusLbl.text = sourceModel.taskStatusNote;
        }
        self.roleLbl.text = @"求购";
        
        [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:sourceModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        self.nickNameLbl.text = sourceModel.nickname;
        
        
    }else {
        self.statusLbl.text = sourceModel.taskStatusNote;
        self.roleLbl.text = @"代购";
        
        NSDictionary *seller = _sourceModel.seller;
        [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:seller[@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        self.nickNameLbl.text = seller[@"nickname"];
    }
    
    //操作按钮
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

- (IBAction)chatBtnClicked:(id)sender {
    if (self.chatBlock) {
        self.chatBlock(self.sourceModel);
    }
}
@end
