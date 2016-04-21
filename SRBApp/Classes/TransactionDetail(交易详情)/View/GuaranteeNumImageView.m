//
//  GuaranteeNumImageView.m
//  SRBApp
//
//  Created by zxk on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GuaranteeNumImageView.h"

@implementation GuaranteeNumImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgOne = [[UIImageView alloc]initWithFrame:CGRectMake(70, 21, 20, 15)];
        _imgTwo = [[UIImageView alloc]initWithFrame:CGRectMake(95, 21, 20, 15)];
        _imgThree = [[UIImageView alloc]initWithFrame:CGRectMake(120, 21, 20, 15)];
        _imgFour = [[UIImageView alloc]initWithFrame:CGRectMake(145, 21, 20, 15)];
        _imgFive = [[UIImageView alloc]initWithFrame:CGRectMake(170, 21, 20, 15)];
        
        [self addSubview:_imgOne];
        [self addSubview:_imgThree];
        [self addSubview:_imgTwo];
        [self addSubview:_imgFour];
        [self addSubview:_imgFive];
        
        _danbaoNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 51, 12)];
        _danbaoNameLabel.text = @"请选择";
        _danbaoPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 5, 70, 12)];
        _danbaoPriceLabel.text = @"0.00";
        _danbaoPriceLabel.textAlignment = NSTextAlignmentRight;
        UILabel * xinxinLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, 60, 12)];
        xinxinLabel.font = SIZE_FOR_12;
        xinxinLabel.text = @"信心指数:";
        [self addSubview:self.danbaoNameLabel];
        [self addSubview:self.danbaoPriceLabel];
        [self addSubview:xinxinLabel];

    }
    return self;
}

- (void)setImage:(int)num
{
    switch (num) {
        case 0:
        {
            _imgOne.image = [UIImage imageNamed:@"kpzs_1"];
            _imgTwo.image = [UIImage imageNamed:@"kpzs_1"];
            _imgThree.image = [UIImage imageNamed:@"kpzs_1"];
            _imgFour.image = [UIImage imageNamed:@"kpzs_1"];
            _imgFive.image = [UIImage imageNamed:@"kpzs_1"];
            break;
        }
        case 1:
        {
            _imgOne.image = [UIImage imageNamed:@"kpzs_3"];
            _imgTwo.image = [UIImage imageNamed:@"kpzs_1"];
            _imgThree.image = [UIImage imageNamed:@"kpzs_1"];
            _imgFour.image = [UIImage imageNamed:@"kpzs_1"];
            _imgFive.image = [UIImage imageNamed:@"kpzs_1"];
            break;
        }
        case 2:
        {
            _imgOne.image = [UIImage imageNamed:@"kpzs_3"];
            _imgTwo.image = [UIImage imageNamed:@"kpzs_3"];
            _imgThree.image = [UIImage imageNamed:@"kpzs_1"];
            _imgFour.image = [UIImage imageNamed:@"kpzs_1"];
            _imgFive.image = [UIImage imageNamed:@"kpzs_1"];
            break;
        }
        case 3:
        {
            _imgOne.image = [UIImage imageNamed:@"kpzs_3"];
            _imgTwo.image = [UIImage imageNamed:@"kpzs_3"];
            _imgThree.image = [UIImage imageNamed:@"kpzs_3"];
            _imgFour.image = [UIImage imageNamed:@"kpzs_1"];
            _imgFive.image = [UIImage imageNamed:@"kpzs_1"];
            break;
        }
        case 4:
        {
            _imgOne.image = [UIImage imageNamed:@"kpzs_3"];
            _imgTwo.image = [UIImage imageNamed:@"kpzs_3"];
            _imgThree.image = [UIImage imageNamed:@"kpzs_3"];
            _imgFour.image = [UIImage imageNamed:@"kpzs_3"];
            _imgFive.image = [UIImage imageNamed:@"kpzs_1"];
            break;
        }
        case 5:
        {
            _imgOne.image = [UIImage imageNamed:@"kpzs_3"];
            _imgTwo.image = [UIImage imageNamed:@"kpzs_3"];
            _imgThree.image = [UIImage imageNamed:@"kpzs_3"];
            _imgFour.image = [UIImage imageNamed:@"kpzs_3"];
            _imgFive.image = [UIImage imageNamed:@"kpzs_3"];
            break;
        }
        default:
            break;
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
