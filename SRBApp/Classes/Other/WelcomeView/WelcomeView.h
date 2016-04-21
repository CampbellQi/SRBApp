//
//  WelcomeView.h
//  testWelcomeView
//
//  Created by fengwanqi on 15/12/9.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeView : UIView<UIScrollViewDelegate>

-(id)initWithFrame:(CGRect)frame GifArray:(NSArray *)gifArray;

@property (nonatomic, strong)UIButton *button;
@end
