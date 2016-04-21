//
//  AllEvaluationsViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/4/30.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface AllEvaluationsViewController : ZZViewController
@property (nonatomic, strong)NSString * signOfEvaluation;
@property (nonatomic, strong)NSString * username;
@property (nonatomic, strong)NSString * uptitle;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UIImageView * imgview;
- (void)urlRequestPost;
@end
