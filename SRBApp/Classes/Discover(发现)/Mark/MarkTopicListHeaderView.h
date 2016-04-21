//
//  MarkTopicListHeaderView.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/10.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkTopicListHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *attentionCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *grayLbl;

@property (nonatomic, strong)NSDictionary *dataDict;
@end
