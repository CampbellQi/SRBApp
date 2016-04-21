//
//  HadPublishCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "HadPublishCell.h"

@implementation HadPublishCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        MyImgView * isStickImg = [[MyImgView alloc]initWithFrame:CGRectMake(self.picIV.frame.origin.x + self.picIV.frame.size.width + 12, self.picIV.frame.origin.y, 34, 17)];
        isStickImg.hidden = YES;
        isStickImg.image = [UIImage imageNamed:@"zhiding"];
        self.isStickImg = isStickImg;
        [self addSubview:isStickImg];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 40)];
        view.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        [self addSubview:view];
        
        MyImgView * theImage = [[MyImgView alloc]initWithFrame:CGRectMake(15, 12.5, 15, 15)];
        self.theImage = theImage;
        theImage.image = [UIImage imageNamed:@"shengyushijian"];
        [view addSubview:theImage];
        
        MyLabel * shengyuLabel = [[MyLabel alloc]initWithFrame:CGRectMake(theImage.frame.size.width + theImage.frame.origin.x + 6, 13, SCREEN_WIDTH - 36 - 61, 14)];
        shengyuLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        shengyuLabel.font = SIZE_FOR_12;
        self.shengyuLabel = shengyuLabel;
        [view addSubview:shengyuLabel];
        
        
        MyLabel * doneLabel = [[MyLabel alloc]initWithFrame:CGRectMake(theImage.frame.size.width + theImage.frame.origin.x + 6, 27, SCREEN_WIDTH - 36 - 61, 14)];
        doneLabel.hidden = YES;
        doneLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        doneLabel.font = SIZE_FOR_12;
        doneLabel.transform = CGAffineTransformMakeScale(1, 0.1);
        self.doneLabel = doneLabel;
        doneLabel.text = @"刷新成功";
        [view addSubview:doneLabel];
        
        _button = [PublishButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(SCREEN_WIDTH - 15 - 31, 2.5, 31, 35);
        [_button setBackgroundImage:[UIImage imageNamed:@"editdelete"] forState:UIControlStateNormal];
        [view addSubview:_button];
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 15)];
        bottomView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:bottomView];
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
