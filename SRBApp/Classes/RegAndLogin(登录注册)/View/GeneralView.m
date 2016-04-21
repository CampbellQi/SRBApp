//
//  GeneralView.m
//  SRBApp
//
//  Created by zxk on 14/12/17.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "GeneralView.h"

@implementation GeneralView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        //左侧图片
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(25, (frame.size.height - 25)/2, 25, 25)];
        self.leftImg = image;
        [self addSubview:image];
        
        //输入框
        UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(image.frame.size.width + image.frame.origin.x + 25, (frame.size.height - 20)/2, SCREEN_WIDTH - (image.frame.size.width + image.frame.origin.x + 25) - 15, 20)];
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        if (SCREEN_WIDTH > 320) {
            text.font = SIZE_FOR_IPHONE;
        }else{
            text.font = SIZE_FOR_IPHONE;
        }
        self.shuRuText = text;
        [self addSubview:text];
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
