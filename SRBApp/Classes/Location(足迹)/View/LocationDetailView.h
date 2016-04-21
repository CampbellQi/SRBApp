//
//  LocationDetailView.h
//  SRBApp
//
//  Created by zxk on 15/2/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"
#import "LocationMyLabel.h"
#import "NameTextView.h"

@interface LocationDetailView : ZZView
@property (nonatomic,strong)UIImageView * logoImg;
@property (nonatomic,strong)NameTextView * nameLabel;
@property (nonatomic,strong)LocationMyLabel * contentLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)NSDictionary * contentDic;
@end
