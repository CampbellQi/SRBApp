//
//  TuijianView.h
//  SRBApp
//
//  Created by 刘若曈 on 15/3/16.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"

@interface TuijianView : ZZView
@property (nonatomic, strong)UIImageView * imageV;
@property (nonatomic, strong)UILabel * title;
@property (nonatomic, strong)UILabel * price;
@property (nonatomic, strong)UILabel * content;
@property (nonatomic, assign)NSInteger * tagNum;
@end
