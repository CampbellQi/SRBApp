//
//  CommentNameView.m
//  SRBApp
//
//  Created by zxk on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CommentNameView.h"

@implementation CommentNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, frame.size.height)];
        self.nameLabel = nameLabel;
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textColor = MAINCOLOR;
        [self addSubview:nameLabel];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[GetColor16 hexStringToColor:@"#e6e6e6"]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[GetColor16 hexStringToColor:@"#f6f6f6"]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[GetColor16 hexStringToColor:@"#f6f6f6"]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
