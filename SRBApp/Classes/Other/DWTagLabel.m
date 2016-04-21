//
//  DWTagLabel.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/4.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "DWTagLabel.h"
#define TEXT_COLOR [UIColor colorWithRed:227/225.0 green:66/225.0 blue:134/225.0 alpha:1]
@implementation DWTagLabel

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //self.backgroundColor = [UIColor lightGrayColor];
    self.textColor = [GetColor16 hexStringToColor:@"#f90875"];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //self.backgroundColor = [UIColor clearColor];
    self.textColor = TEXT_COLOR;
    if (self.tagTappedBlock) {
        self.tagTappedBlock(self);
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
