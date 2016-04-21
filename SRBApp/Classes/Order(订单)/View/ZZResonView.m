//
//  ZZResonView.m
//  SRBApp
//
//  Created by zxk on 14/12/20.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZResonView.h"


@interface ZZResonView()
@property (strong,nonatomic)UIView * bgView;
@end

@implementation ZZResonView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview != nil) {
        //self.backgroundColor = [UIColor clearColor];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.backgroundColor = [GetColor16 hexStringToColor:@"#434343"];
        view.alpha = 0.5;
        [self addSubview:view];
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(15, (SCREEN_HEIGHT - self.array.count * 30)/2, SCREEN_WIDTH - 30, self.array.count * 31)];
        bgView.backgroundColor = WHITE;
        bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        bgView.layer.shadowOffset = CGSizeMake(5, 5);
        [self addSubview:bgView];
        for (int i = 0; i < _array.count; i++) {
            @autoreleasepool {
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, i * 30 + 5, bgView.frame.size.width, 20);
                //btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.titleLabel.font = [UIFont systemFontOfSize:16];
                [btn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                btn.tag = i + 1000;
                [btn addTarget:self action:@selector(mark:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:[_array objectAtIndex:i] forState:UIControlStateNormal];
                if (i != _array.count - 1) {
                    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, btn.frame.size.height + btn.frame.origin.y + 5, bgView.frame.size.width, 1)];
                    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#959595"];
                    [bgView addSubview:lineView];
                }
                [bgView addSubview:btn];
            }
        }
    }
}

- (void)mark:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(resonView:didSelectRow:)]) {
        [self.delegate resonView:self didSelectRow:sender.tag - 1000];
    }
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
