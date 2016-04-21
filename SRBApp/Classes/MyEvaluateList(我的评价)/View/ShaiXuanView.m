//
//  ShaiXuanView.m
//  SRBApp
//
//  Created by zxk on 15/1/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ShaiXuanView.h"

@implementation ShaiXuanView

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview != nil) {
        //__weak MoreOrderView * tempView = self;
        UIImage * image = [UIImage imageNamed:@"bg_comment.png"];
        UIImageView * cateImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 40, 64, 17, 7)];
        cateImage.image = image;
        cateImage.userInteractionEnabled = YES;
        [self addSubview:cateImage];
        
        UIView * bgview =  [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 123)/2, 71, 123, 38)];
        bgview.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        bgview.layer.masksToBounds = NO;
        bgview.layer.cornerRadius = 2;
        bgview.layer.shadowColor = [GetColor16 hexStringToColor:@"#434343"].CGColor;
        bgview.layer.shadowOffset = CGSizeMake(2, 2);
        bgview.layer.shadowOpacity = 0.3;
        bgview.layer.shadowRadius = 2;
        [self addSubview:bgview];
        
        [UIView animateWithDuration:0.2 animations:^{
            bgview.frame = CGRectMake((SCREEN_WIDTH - 123)/2, 71, 123, self.array.count * 35);
        } completion:^(BOOL finished) {
            for (int i = 0; i < self.array.count ; i++) {
                @autoreleasepool {
                    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
                    btn.showsTouchWhenHighlighted = YES;
                    
                    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    btn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
                    btn.titleLabel.font = SIZE_FOR_14;
//                    if (i == 0) {
//                        btn.tag = 10 + 1000;
//                        [btn setTitle:[self.array objectAtIndex:i] forState:UIControlStateNormal];
//                        btn.frame = CGRectMake(21, i * 35 + 2, 85, 30);
//                    }else{
                        btn.tag = i + 1000;
                        [btn setTitle:[self.array objectAtIndex:i] forState:UIControlStateNormal];
                    if (self.array.count == 3) {
                        if (i == 0) {
                            btn.frame = CGRectMake(21, i * 35 + 2, 85, 30);
                        }else{
                            btn.frame = CGRectMake(21, i * 35 + 2, 85, 30);
                        }
                        
                    }else{
                        if (i == 0) {
                            btn.frame = CGRectMake(21, i * 35 + 2, 85, 30);
                        }else{
                            btn.frame = CGRectMake(31, i * 35 + 2, 85, 30);
                        }
                    }
//                    }
                    btn.alpha = 0;
                    [btn addTarget:self action:@selector(mark:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIView * lineView;
                    if (i != self.array.count - 1) {
                        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, btn.frame.size.height + btn.frame.origin.y + 2 , 123, 1)];
                        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
                        lineView.alpha = 0;
                        [bgview addSubview:lineView];
                    }
                    
                    
                    UIImageView * img = [[UIImageView alloc]init];
//                    if (i == 1 || i == 5) {
//                       img.frame = CGRectMake(26, i * 35 + 8, 14, 14);
//                    }else{
//                        img.frame = CGRectMake(26, i * 35 + 8, 20, 20);
//                    }
                    img.frame = CGRectMake(26, i * 35 + 9, 14, 14);

                    img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArr[i]]];
                    img.alpha = 0;
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        btn.alpha = 1;
                        img.alpha = 1;
                        lineView.alpha = 1;
                        [bgview addSubview:img];
                        [bgview addSubview:btn];
                    }];
                }
            }
        }];
    }
}

- (void)mark:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(shaiXuanView:didSelectRow:)]) {
        [self.delegate shaiXuanView:self didSelectRow:sender.tag - 1000];
    }
    if (sender.tag != 1010) {
      [self removeFromSuperview];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}


@end
