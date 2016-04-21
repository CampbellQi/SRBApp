//
//  MyViewUtils.m
//  Cat
//
//  Created by mac on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LKViewUtils.h"
static LKViewUtils* instance;
@interface LKViewUtils(UIAlerViewDelegate)<UIAlertViewDelegate>
+(LKViewUtils*)sharedViewUtils;
@property(strong,nonatomic) void(^yesbloak)();
@property(strong,nonatomic) void(^noblock)();
@end
@implementation LKViewUtils
+(LKViewUtils *)sharedViewUtils
{
    if(instance == nil)
    {
        instance = [[LKViewUtils alloc] init];
    }
    return instance;
}
+(void)MakeViewRadiusAndShaow:(UIView *)view
{
    [LKViewUtils MakeViewRadiusAndShaow:view radius:8];
}
+(void)MakeViewRadius:(UIView*)view radius:(float)radius
{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds =YES;
}
+(void)MakeViewRadiusAndBorder:(UIView *)view
{
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 8;
    view.layer.borderColor = [UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:0.6].CGColor;
    view.layer.masksToBounds =YES;
}
+(void)MakeViewBorder:(UIView *)view
{
    view.layer.borderWidth = 1; 
    view.layer.borderColor = [UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:0.6].CGColor;
}
+(void)MakeViewRadiusAndShaow:(UIView *)view radius:(float)radius
{
    view.layer.cornerRadius = radius;
    view.layer.shadowOffset = CGSizeMake(3,3);
    view.layer.shadowOpacity = 0.6;
    view.layer.shadowColor =[UIColor blackColor].CGColor;
}
+(void)MakeViewShaow:(UIView *)view offset:(CGSize)offset
{
    view.layer.shadowOffset = offset;
    view.layer.shadowOpacity = 0.6;
    view.layer.shadowColor =[UIColor blackColor].CGColor;
}
+(void)AnimationFrame:(UIView *)view frame:(CGRect)newframe
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^
     {
         [view setFrame:newframe]; 
         
     }completion:nil];
    
}
+(void)AnimationFrame:(UIView *)view frame:(CGRect)newframe didEndEvent:(void (^)(void))endEvent
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseInOut animations:
     ^{
         [view setFrame:newframe];        
     }
                     completion:^(BOOL finished)
     {
         if(finished)
         {
             endEvent();
         }
     }];
}
+(void)AnimationAlpha:(UIView *)view Alpha:(float)alpha
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^
     {
         [view setAlpha:alpha];        
     }completion:nil];
}
+(CATransition *)AnimationFade
{

    CATransition *animation = [CATransition animation];
    [animation setDuration:0.6];
    [animation setType:LKView_Anima_Fade]; //淡入淡出
    [animation setSubtype:LKView_AnimaSubType_FromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}
+(CATransition*)AnimationLayer:(NSString *)type
{
    return [LKViewUtils AnimationLayer:type subType:kCATransitionFromLeft];
}
+(CATransition*)AnimationLayer:(NSString *)type subType:(NSString *)subType
{
    CATransition *transition = [CATransition animation]; //定义过度动画
    transition.duration = 1; //持续时间
    transition.type = type;   //动画样式
    transition.subtype = subType;  //方向
    
    return transition;
}
+(void)removeAllSubView:(UIView*)view
{
    for (UIView* subview in view.subviews) {
        [subview removeFromSuperview];
    }
}
+ (void)clearTableViewFooter: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+(void)setButton:(UIButton *)bt title:(NSString *)title
{
    if(title != nil)
    {
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitle:title forState:UIControlStateHighlighted];
    }
}
+(UILabel *)getAutoLable:(NSString *)txt font:(UIFont *)font point:(CGPoint) point
{
    return [self getAutoLable:txt font:font point:point maxWidth:[UIScreen mainScreen].bounds.size.width - 40];
}
+(UILabel *)getAutoLable:(NSString *)txt font:(UIFont *)font point:(CGPoint)point maxWidth:(int)maxWidth
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    [label setNumberOfLines:0];
    label.font = font;
    label.text = txt;
    CGSize size = CGSizeMake(maxWidth,8000);
    CGSize size2 = [txt sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    label.frame = CGRectMake(point.x,point.y,size2.width,size2.height);
    
    return label;
}
+(CGFloat)getTextHeight:(NSString *)txt font:(UIFont *)font width:(CGFloat)width
{
    CGSize labelSize = CGSizeZero;
    labelSize = [txt sizeWithFont:font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height;
}
+(UIImage *)getImageFromView:(UIView *)view
{ 
    UIGraphicsBeginImageContext(view.bounds.size); 
    [view.layer renderInContext:UIGraphicsGetCurrentContext()]; 
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    return image;
}
+(void)showAlertView:(NSString *)message
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}
+(void)showAlertViewYesOrNo:(NSString *)title message:(NSString *)message yes:(void (^)())yesblock no:(void (^)())noblock
{
  
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:instance cancelButtonTitle:@"是" otherButtonTitles:@"否",nil];
    [alertView show];
    [self sharedViewUtils];
    instance.yesbloak = yesblock;
    instance.noblock = noblock;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==0)
    {
        if(instance.yesbloak != nil)
        {
            instance.yesbloak();
        }
    }
    if(buttonIndex == 1)
    {
        if(instance.noblock != nil)
        {
            instance.noblock();
        }
    }
    instance.yesbloak = nil;
    instance.noblock = nil;
}

@end
