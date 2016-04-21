//
//  YanZhengMaView.h
//  SRBApp
//
//  Created by zxk on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"

@interface YanZhengMaView : ZZView
@property (nonatomic,strong)UILabel * showLabel;
@property (nonatomic,strong)UILabel * labelOne;
@property (nonatomic,strong)UILabel * labelTwo;
@property (nonatomic,strong)UILabel * labelThree;
@property (nonatomic,strong)UILabel * labelFour;
@property (nonatomic,strong)NSString * numStr;
- (void)makeYanzhengma;
- (void)drawRect:(CGRect)rect;
@end
