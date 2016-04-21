//
//  PersonalHelpSpApplyCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define PHOTO_MARGIN 10
#import "LayoutFrame.h"

#import "PersonalHelpSpApplyCell.h"
#import "PersonalOrderOperateView.h"

@implementation PersonalHelpSpApplyCell

- (void)awakeFromNib {
    // Initialization code
    self.avaterIV.layer.masksToBounds = YES;
    self.avaterIV.layer.cornerRadius = CGRectGetWidth(self.avaterIV.frame) * 0.5;
    //self.contentSuperView.layer.cornerRadius = 4.0;
    self.contentSuperView.layer.cornerRadius = 4.0f;
    self.contentSuperView.layer.borderColor = GRAYCOLOR.CGColor;
    self.contentSuperView.layer.borderWidth = 0.5f;
    
    [self.memoLbl addTapAction:@selector(spreadBtnClicked:) forTarget:self];
    [self.avaterIV addTapAction:@selector(avaterIVClicked) forTarget:self];
}

-(void)setSourceModel:(BussinessModel *)sourceModel {
    _sourceModel = sourceModel;
    
    [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:sourceModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.nicknameLbl.text = sourceModel.nickname;
    
    self.depositLbl.text = [NSString stringWithFormat:@"押金：￥%@", sourceModel.money];
    self.quotePriceLbl.text = [NSString stringWithFormat:@"报价：￥%@", sourceModel.quote];
    self.shoplandLbl.text = [NSString stringWithFormat:@"预计代购地点：%@", sourceModel.area];
    self.deliverGoodstimeLbl.text = [NSString stringWithFormat:@"预计发货时间：%@", sourceModel.sendtime];
    self.memoLbl.text = sourceModel.message;
    //NSString * timeStr = [CompareCurrentTime compareCurrentTime:sourceModel.updatetimeLong];
    self.timeLbl.text = sourceModel.updatetime;
    //显示图片
    if (sourceModel.photos.length != 0) {
        float photoWidth = self.coverSV.height - 2 * PHOTO_MARGIN;
        NSArray *photosArray = [sourceModel.photos componentsSeparatedByString:@","];
        for (int i=0; i<photosArray.count; i++) {
            UIImageView *iv = nil;
            if ([self viewWithTag:200+i]) {
                iv = [self viewWithTag:200+i];
            }else {
                iv = [[UIImageView alloc] init];
            }
            iv.frame = CGRectMake(i * photoWidth + PHOTO_MARGIN * (i + 1), PHOTO_MARGIN, photoWidth, photoWidth);
            [iv sd_setImageWithURL:[NSURL URLWithString:photosArray[i]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            [self.coverSV addSubview:iv];
            iv.tag = 200 + i;
            [iv addTapAction:@selector(photoTap:) forTarget:self];
        }
        self.coverSV.contentSize = CGSizeMake(photosArray.count * (photoWidth + PHOTO_MARGIN) + PHOTO_MARGIN, 0);
    }
    
    //位置
    if (!sourceModel.model_position || sourceModel.model_position.length == 0) {
        self.locationBtn.hidden = YES;
    }else {
        self.locationBtn.hidden = NO;
        [self.locationBtn setTitle:[NSString stringWithFormat:@"%@", sourceModel.model_position] forState:UIControlStateNormal];
    }
    
    //操作按钮
    [self setUpOperateView];
}
-(void)resetCoversFrame {
    float photoWidth = 88 - 2 * PHOTO_MARGIN;
    NSArray *photosArray = [self.sourceModel.photos componentsSeparatedByString:@","];
    for (int i=0; i<photosArray.count; i++) {
        UIView *cover = [self viewWithTag:i+200];
        cover.frame = CGRectMake(i * photoWidth + PHOTO_MARGIN * (i + 1), PHOTO_MARGIN, photoWidth, photoWidth);
    }
    self.coverSV.contentSize = CGSizeMake(photosArray.count * (photoWidth + PHOTO_MARGIN) + PHOTO_MARGIN, 0);
}
-(void)photoTap:(UIGestureRecognizer *)gr {
    if (self.photoIVBlock) {
        self.photoIVBlock(gr.view.tag, _sourceModel);
    }
}
-(void)setUpOperateView {
    if ([self.operateSuperView viewWithTag:100]) {
        [[self.operateSuperView viewWithTag:100] removeFromSuperview];
    }
    float height = CGRectGetHeight(self.operateSuperView.frame);
    PersonalOrderOperateView *view = [[PersonalOrderOperateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, height) OrderStatus:APPLY_HELPSP_STATUS CurrentViewController:self.currentVC BussinessModel:_sourceModel];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 100;
    [self.operateSuperView addSubview:view];
}
-(void)hideOperateView {
    UIView *view = [self viewWithTag:100];
    view.hidden = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)spreadBtnClicked:(id)sender {
    if (self.spreadBlock) {
        self.spreadBlock(self.spreadBtn, self.sourceModel);
    }
}
- (IBAction)chatBtnClicked:(id)sender {
    if (self.chatBlock) {
        self.chatBlock(self.sourceModel);
    }
}
-(void)avaterIVClicked {
    if (self.avaterIVBlock) {
        self.avaterIVBlock(self.sourceModel.account);
    }
}
@end
