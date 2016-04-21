//
//  CommentView.m
//  SRBApp
//
//  Created by zxk on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UIImageView * selectImgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 15, 17)];
        selectImgview.userInteractionEnabled = YES;
        self.selectImgview = selectImgview;
        [self addSubview:selectImgview];
        
        UIImageView * gradeImgview = [[UIImageView alloc]initWithFrame:CGRectMake(23, 1, 25, 25)];
        self.gradeImgview = gradeImgview;
        [self addSubview:gradeImgview];
        
        UILabel * gradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(23,30,24,15)];
        gradeLabel.font = SIZE_FOR_12;
        gradeLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.gradeLabel = gradeLabel;
        [self addSubview:gradeLabel];
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
