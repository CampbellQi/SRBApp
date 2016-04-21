//
//  DanBaoMenuView.m
//  SRBApp
//
//  Created by zxk on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "DanBaoMenuView.h"

@implementation DanBaoMenuView


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview != nil) {
        UIView * shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        shadowView.backgroundColor = [UIColor blackColor];
        shadowView.alpha = 0.4;
        [self addSubview:shadowView];
        NSInteger count = 0;
        if (self.array == nil || self.array.count == 0) {
            count = 1;
        }else{
            count = self.array.count;
        }
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 220)/2, (SCREEN_HEIGHT - count * 42)/2, 220, count * 42)];
        bgView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        bgView.layer.masksToBounds = NO;
        bgView.layer.cornerRadius = 2;
        bgView.layer.shadowColor = [GetColor16 hexStringToColor:@"#434343"].CGColor;
        bgView.layer.shadowOffset = CGSizeMake(2, 2);
        bgView.layer.shadowOpacity = 0.3;
        bgView.layer.shadowRadius = 2;
        [self addSubview:bgView];
        
        if (self.array == nil || self.array.count == 0) {
            GuaranteeNumImageView * guaranteeImgView = [[GuaranteeNumImageView alloc]initWithFrame:CGRectMake(0, 0, 220, 40)];
            guaranteeImgView.danbaoNameLabel.text = @"请选择";
            guaranteeImgView.danbaoPriceLabel.text = @"";
            [guaranteeImgView setImage:0];
            guaranteeImgView.alpha = 0;
            UITapGestureRecognizer * clickTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTapOther:)];
            [guaranteeImgView addGestureRecognizer:clickTap];
            [UIView animateWithDuration:0.2 animations:^{
                guaranteeImgView.alpha = 1;
                            [bgView addSubview:guaranteeImgView];
            }];
        }else{
        [UIView animateWithDuration:0.2 animations:^{
            for (int i = 0; i < self.array.count; i++) {
                @autoreleasepool {
                    DanBaoRenModel * danBaroRenModel = [self.array objectAtIndex:i];
                    GuaranteeNumImageView * guaranteeImgView = [[GuaranteeNumImageView alloc]initWithFrame:CGRectMake(0, i * 42, 220, 40)];
                    int num = [danBaroRenModel.grade intValue];
                    [guaranteeImgView setImage:num];
                    guaranteeImgView.danbaoNameLabel.text = danBaroRenModel.nickname;
                    guaranteeImgView.danbaoPriceLabel.text = danBaroRenModel.bangPrice;
                    guaranteeImgView.tag = 1000+i;
                    guaranteeImgView.alpha = 0;
                    UIView * lineView;
                    if (i < count - 1) {
                        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, (i+1) * 40, 220, 1)];
                        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#959595"];
                        lineView.alpha = 0;
 
                    }
                    UITapGestureRecognizer * clickTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
                    [guaranteeImgView addGestureRecognizer:clickTap];
                    [UIView animateWithDuration:0.2 animations:^{
                        guaranteeImgView.alpha = 1;
                        lineView.alpha = 1;
                        [bgView addSubview:lineView];
                        [bgView addSubview:guaranteeImgView];
                    }];
                }
            }
        }];
        }
    }
}

- (void)clickTap:(UITapGestureRecognizer *)clickTap
{
    if ([self.delegate respondsToSelector:@selector(moreDanbaoView:didSelectRow:)]) {
        [self.delegate moreDanbaoView:self didSelectRow:clickTap.view.tag - 1000];
    }
    [self removeFromSuperview];
}

- (void)clickTapOther:(UITapGestureRecognizer *)clickTap
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
