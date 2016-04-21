//
//  HadPublishCell.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "PublishCell.h"
#import "PublishButton.h"

@interface HadPublishCell : PublishCell
@property (nonatomic, strong)PublishButton * button;
@property (nonatomic,strong)MyLabel * shengyuLabel;
@property (nonatomic,strong)MyImgView * isStickImg;
@property (nonatomic,strong)MyImgView * theImage;
@property (nonatomic,strong)MyLabel * doneLabel;
@end
