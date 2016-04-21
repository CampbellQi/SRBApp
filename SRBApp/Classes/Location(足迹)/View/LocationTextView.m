//
//  LocationTextView.m
//  SRBApp
//
//  Created by zxk on 15/4/17.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "LocationTextView.h"

#define ZZTextViewCoverTag 999

@implementation LocationTextView
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        self.scrollEnabled = NO;
        self.editable = NO;
        UILongPressGestureRecognizer * longRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(addGestureRecognizer:)];
        longRecognizer.allowableMovement = 100.0f;
        longRecognizer.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longRecognizer];
        
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addGestureRecognizer:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        gestureRecognizer.enabled = NO;
    }
    [super addGestureRecognizer:gestureRecognizer];
}


//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    [UIMenuController sharedMenuController].menuVisible = NO;
//    return NO;
//}

- (void)setupSpecialRects
{
    NSArray * specials;
    if (self.attributedText.length != 0 && self.attributedText != nil) {
        specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    }else{
        return;
    }
    
    for (ZZSpecial * special in specials) {
        //找出触摸点在哪个特殊字符串上面
        self.selectedRange = special.range;
        //self.selectedRange -- 影响-->self.selectedTextRange
        //获得选中范围的矩形框
        NSArray * selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        self.selectedRange = NSMakeRange(0, 0);
        
        NSMutableArray * rects = [NSMutableArray array];
        for (UITextSelectionRect * selectionrect in selectionRects) {
            CGRect rect = selectionrect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            
            //添加rect
            [rects addObject:[NSValue valueWithCGRect:rect]];
        }
        special.rects = rects;
    }
    
}

/**
 找出被触摸的特殊字符串
 */
- (ZZSpecial *)touchingSpecialWithPoint:(CGPoint)point
{
    if (self.attributedText.length != 0 && self.attributedText != nil) {
        NSArray * specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
        for (ZZSpecial * special in specials) {
            for (NSValue * rectValue in special.rects) {//点中了某个特殊字符串
                if (CGRectContainsPoint(rectValue.CGRectValue, point)) {
                    return special;
                }
            }
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    beginPoint = [[touches anyObject]locationInView:self];
    //触摸对象
    UITouch * touch = [touches anyObject];
    //触摸点
    CGPoint point = [touch locationInView:self];
    
    //初始化矩形框
    [self setupSpecialRects];
    
    //根据触摸点获得被触摸的特殊字符串
    ZZSpecial * special = [self touchingSpecialWithPoint:point];
    
    //在被触摸的特殊字符串后面显示一段高亮的背景
    for (NSValue * rectValue in special.rects) {
        //在被触摸的特殊字符串后面显示一段高亮的背景
        UIView * cover = [[UIView alloc]init];
        cover.backgroundColor = [UIColor lightGrayColor];
        cover.frame = rectValue.CGRectValue;
        cover.layer.cornerRadius = 5;
        cover.tag = ZZTextViewCoverTag;
        [self insertSubview:cover atIndex:0];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    for (UIView * child in self.subviews) {
        if (child.tag == ZZTextViewCoverTag) {
            [child removeFromSuperview];
        }
    }
    
    CGPoint tempPoint = [[touches anyObject]locationInView:self];
    if (beginPoint.x - tempPoint.x <= 8.5 && beginPoint.x - tempPoint.x >= - 8.5 && beginPoint.y - tempPoint.y <= 8.5 && beginPoint.y - tempPoint.y >= - 8.5) {
        //触摸对象
        UITouch * touch = [touches anyObject];
        //触摸点
        CGPoint point = [touch locationInView:self];
        ZZSpecial * special = [self touchingSpecialWithPoint:point];
        if (special.goodsID != nil && ![special.goodsID isEqualToString:@""]) {
            if ([self.delegate respondsToSelector:@selector(pushToViewGoodsID:Moudle:withLocationTextView:)]) {
                [self.delegate pushToViewGoodsID:special.goodsID Moudle:special.sourcemodule withLocationTextView:self];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(pushToLocationTagView:withLocationTextView:)]) {
                [self.delegate pushToLocationTagView:[special.text stringByReplacingOccurrencesOfString:@"#" withString:@""]withLocationTextView:self];
            }
        }

    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [super hitTest:point withEvent:event];
}

/**
 告诉系统触摸点point是否在这个UI控件身上
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //初始化矩形框
    [self setupSpecialRects];
    
    //根据触摸点获得被触摸的特殊字符串
    ZZSpecial * special = [self touchingSpecialWithPoint:point];
    if (special) {
        return YES;
    }else{
        return NO;
    }
//    return YES;
}

//触摸事件的处理
//1.判断点在谁身上:调用所有UI控件的 - (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//2.pointInside返回YES的控件就是触摸点所在的UI控件
//2.由触摸点所在的UI控件选出处理事件的UI控件:调用- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event


@end
