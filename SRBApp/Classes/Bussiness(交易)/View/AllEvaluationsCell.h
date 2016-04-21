//
//  AllEvaluationsCell.h
//  SRBApp
//
//  Created by 刘若曈 on 15/4/30.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"

@interface AllEvaluationsCell : ZZTableViewCell
@property (nonatomic, strong)MyImgView * headImage;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * sayLabel;
@property (nonatomic, strong)UILabel * dateLabel;
-(void)setIntroductionText:(NSString*)text;
@end
