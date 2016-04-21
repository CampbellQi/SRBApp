//
//  UpImageView.m
//  SRBApp
//
//  Created by 刘若曈 on 15/2/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "UpImageView.h"

@implementation UpImageView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _del = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _del.image = [UIImage imageNamed:@"img_cancel"];
        _del.center = CGPointMake(self.frame.origin.x + self.frame.size.width - 10,self.frame.origin.y + 10 );
        [self addSubview:_del];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
