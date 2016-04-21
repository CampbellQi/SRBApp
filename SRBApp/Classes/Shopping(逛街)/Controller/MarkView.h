//
//  MarkView.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

typedef void (^MarkViewTapBlock) (NSDictionary *dataDict);

#import <UIKit/UIKit.h>

@interface MarkView : UIView
//初始化标签view
-(id)initWithFrame:(CGRect)aFrame MarkName:(NSDictionary *)aMarkDict;
@property (nonatomic, strong)NSDictionary *markDict;
@property (nonatomic, copy)MarkViewTapBlock markViewTapBlock;

@property (nonatomic, strong)UILabel *nameLbl;
@end
