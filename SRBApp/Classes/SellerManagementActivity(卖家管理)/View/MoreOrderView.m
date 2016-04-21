//
//  MoreOrderView.m
//  SRBApp
//
//  Created by zxk on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MoreOrderView.h"

@interface MoreOrderView ()
@property (nonatomic,strong)UIImageView * imgView;
@end

@implementation MoreOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview != nil) {
        //__weak MoreOrderView * tempView = self;
        UIImage * image = [UIImage imageNamed:@"bg_comment.png"];
        UIImageView * cateImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 64, 17, 7)];
        cateImage.image = image;
        cateImage.userInteractionEnabled = YES;
        [self addSubview:cateImage];
        
        UIView * bgview =  [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 123 - 15, 71, 123, 0)];
        bgview.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        bgview.layer.masksToBounds = NO;
        bgview.layer.cornerRadius = 2;
        bgview.layer.shadowColor = [GetColor16 hexStringToColor:@"#434343"].CGColor;
        bgview.layer.shadowOffset = CGSizeMake(2, 2);
        bgview.layer.shadowOpacity = 0.3;
        bgview.layer.shadowRadius = 2;
        [self addSubview:bgview];
        
        [UIView animateWithDuration:0.2 animations:^{
            bgview.frame = CGRectMake(SCREEN_WIDTH - 123 - 15, 71, 123, self.array.count * 31 - 1);
        } completion:^(BOOL finished) {
            for (int i = 0; i < self.array.count ; i++) {
                @autoreleasepool {
                    MenuBtn * btn = [MenuBtn buttonWithType:UIButtonTypeCustom];
                    [btn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(0, i * 31, 123, 30);
                    [btn setAdjustsImageWhenHighlighted:NO];
                    btn.titleLabel.font = SIZE_FOR_14;
                    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArr[i]]] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
                    btn.tag = i + 1000;
                    btn.alpha = 0;
                    [btn addTarget:self action:@selector(mark:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:[self.array objectAtIndex:i] forState:UIControlStateNormal];
//                    [btn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateHighlighted];
                    UIView * lineView;
                    if (i != self.array.count - 1) {
                        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, btn.frame.size.height + btn.frame.origin.y , 123, 1)];
                        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
                        lineView.alpha = 0;
                        [bgview addSubview:lineView];
                    }
                    [UIView animateWithDuration:0.2 animations:^{
                        btn.alpha = 1;
                        
                        lineView.alpha = 1;
                        
                        [bgview addSubview:btn];
                    }];
                }
            }
        }];
    }
}

- (void)mark:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(moreOrderView:didSelectRow:)]) {
        [self.delegate moreOrderView:self didSelectRow:sender.tag - 1000];
    }
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
