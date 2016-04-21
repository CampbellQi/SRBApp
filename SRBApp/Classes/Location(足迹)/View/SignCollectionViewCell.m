//
//  SignCollectionViewCell.m
//  SRBApp
//
//  Created by zxk on 15/4/16.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SignCollectionViewCell.h"

@implementation SignCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        SignBtn * signBtn = [SignBtn buttonWithType:UIButtonTypeCustom];
        signBtn.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 60) / 3, 25);
        signBtn.titleLabel.font = SIZE_FOR_14;
        [signBtn setBackgroundColor:[GetColor16 hexStringToColor:@"#ffffff"]];
        [signBtn setTitleColor:[GetColor16 hexStringToColor:@"e5005d"] forState:UIControlStateNormal];
        [signBtn setTitleColor:RGBCOLOR(206, 208, 208, 1) forState:UIControlStateSelected];
        signBtn.layer.borderColor = [GetColor16 hexStringToColor:@"#e5005d"].CGColor;
        signBtn.layer.cornerRadius = 2;
        signBtn.layer.masksToBounds = YES;
        signBtn.layer.borderWidth = 1;
        signBtn.isHaveBorder = YES;
        [self addSubview:signBtn];
    }
    return self;
}
@end
