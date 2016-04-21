//
//  MarkView.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MarkView.h"

@implementation MarkView
{
    UIImageView *_bgIV;
}
//初始化标签view
-(id)initWithFrame:(CGRect)aFrame MarkName:(NSDictionary *)aMarkDict{
    if (self = [super initWithFrame:aFrame]) {
        self.markDict = aMarkDict;
        //背景图
        UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:bgIV];
        //蒙层
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.45];
        [self addSubview:view];
        //标题
        float height = self.height;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(2, (aFrame.size.height - height)/2, aFrame.size.width - 4, height)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
        lbl.numberOfLines = 0;
        lbl.font = [UIFont boldSystemFontOfSize:12];
        lbl.textColor = [UIColor whiteColor];
        //lbl.center = iv.center;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        [self addSubview:lbl];
        
        if (aMarkDict) {
            [bgIV sd_setImageWithURL:[NSURL URLWithString:aMarkDict[@"pic"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            lbl.text = aMarkDict[@"name"];
        }
        
        _nameLbl = lbl;
        _bgIV = bgIV;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)]];
    }
    return self;
}
-(void)setMarkDict:(NSDictionary *)markDict {
    _markDict = markDict;
    [_bgIV sd_setImageWithURL:[NSURL URLWithString:markDict[@"pic"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    _nameLbl.text = markDict[@"name"];
}
//标签点击事件
-(void)tapped {
    if (self.markViewTapBlock) {
        self.markViewTapBlock(_markDict);
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
