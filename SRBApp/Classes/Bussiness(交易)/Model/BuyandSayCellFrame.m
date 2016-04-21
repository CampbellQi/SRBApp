//
//  BuyandSayCellFrame.m
//  SRBApp
//
//  Created by fengwanqi on 15/8/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "BuyandSayCellFrame.h"
#import "WQOneToSixPhotosView.h"

@implementation BuyandSayCellFrame

-(void)setMarkModel:(MarkModel *)markModel {
    _markModel = markModel;
    _headImageF = CGRectMake(15, 5, 30, 30);
    _titleLabelF = CGRectMake(_headImageF.origin.x + +_headImageF.size.width + 10, 5, SCREEN_WIDTH - 80, 16);
    _goodCommentF = CGRectMake(_titleLabelF.origin.x, _titleLabelF.origin.y + _titleLabelF.size.height + 5, 90, 16);
    _commentImgF = CGRectMake(_goodCommentF.size.width + _goodCommentF.origin.x + 8, _goodCommentF.origin.y + 2, 12,12);
    _dateLabelF = CGRectMake(SCREEN_WIDTH - 170, _titleLabelF.origin.y, 155, 12);
    
    _sayLabelF = CGRectMake(_titleLabelF.origin.x,_goodCommentF.origin.y + _goodCommentF.size.height + 2, SCREEN_WIDTH - 80, 14);
    CGRect tempRect = [markModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 80, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_12} context:nil];
    _sayLabelF.size.height = tempRect.size.height;
    //图片数组
    CGSize photosSize;
    CGFloat photosY = CGRectGetMaxY(_sayLabelF) + 2;
    NSArray * photosArr = [_markModel.photos componentsSeparatedByString:@","];
    if (_markModel.photos != nil && ![_markModel.photos isEqualToString:@""]) {
        photosSize = [WQOneToSixPhotosView sizeWithCount:photosArr.count];
    }else{
        photosSize = CGSizeZero;
    }
    self.photosViewF = (CGRect){{_titleLabelF.origin.x,photosY},photosSize};
    self.cellHeight = CGRectGetMaxY(_photosViewF) + 10;
}
@end
