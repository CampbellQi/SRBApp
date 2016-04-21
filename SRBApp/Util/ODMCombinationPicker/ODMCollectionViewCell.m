//
//  ODMCollectionViewCell.m
//  CombinationPickerContoller
//
//  Created by allfake on 7/31/14.
//  Copyright (c) 2014 Opendream. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "ODMCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ODMCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHightlightBackground:(BOOL)isSelected withAimate:(BOOL)animate
{
    [self.imageView.layer removeAllAnimations];
    [self.bgView.layer removeAllAnimations];
    [self.layer removeAllAnimations];
    
    if (isSelected == YES) {
        [self showSelectedIV];
        //[self setHightlightBackground];
        
    } else {
        [self hideSelectedIV];
        //[self setNormalBackground:animate];
        
    }
}
-(void)showSelectedIV {
    self.selBtn.selected = YES;
    self.bgView.hidden = NO;
}
-(void)hideSelectedIV {
    self.selBtn.selected = NO;
    self.bgView.hidden = YES;
}
- (void)setNormalBackground:(BOOL)animate
{
    
    if (animate) {
        
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x+1, self.imageView.frame.origin.y+1, self.imageView.frame.size.width-2, self.imageView.frame.size.height-2)];
                             
                             [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x+1, self.bgView.frame.origin.y+1, self.bgView.frame.size.width-2, self.bgView.frame.size.height-2)];
                             
                         }
                         completion:^(BOOL finished){
                             
                             [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x-1, self.imageView.frame.origin.y-1, self.imageView.frame.size.width+2, self.imageView.frame.size.height+2)];
                             
                             [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x-1, self.bgView.frame.origin.y-1, self.bgView.frame.size.width+2, self.bgView.frame.size.height+2)];
                             
                         }
         ];

    }
    
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    
}

- (void)setHightlightBackground
{

    self.bgView.layer.borderWidth = 1.0f;
    self.bgView.layer.borderColor = [UIColor greenColor].CGColor;
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x+1, self.imageView.frame.origin.y+1, self.imageView.frame.size.width-2, self.imageView.frame.size.height-2)];
                         
                         [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x+1, self.bgView.frame.origin.y+1, self.bgView.frame.size.width-2, self.bgView.frame.size.height-2)];

                     }
                     completion:^(BOOL finished){
                         
                         [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x-1, self.imageView.frame.origin.y-1, self.imageView.frame.size.width+2, self.imageView.frame.size.height+2)];
                         
                         [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x-1, self.bgView.frame.origin.y-1, self.bgView.frame.size.width+2, self.bgView.frame.size.height+2)];

                     }
     ];
    
    
}

@end
