//
//  LCCircleButton.h
//  BillsTool
//
//  Created by JD on 11/3/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FANavigationBarDelegate;

@interface FANavigationBar : UIView

@property (nonatomic,readonly) UIButton *leftButton;
@property (nonatomic,readonly) UILabel  *titleLabel;
@property (nonatomic,readonly) UIButton *rightButton;

@property (nonatomic,strong) UIImage    *left;
@property (nonatomic,strong) UIImage    *right;
@property (nonatomic,strong) NSString   *title;
@property (nonatomic,strong) NSString   *rightText;

@property (nonatomic,weak) id<FANavigationBarDelegate> delegate;

- (id)initWithLeftImage:(UIImage *)left withTitle:(NSString *)title rightImage:(UIImage *)right;
- (id)initWithLeftImage:(UIImage *)left withTitle:(NSString *)title rightText:(NSString *)right;


@end

@protocol FANavigationBarDelegate <NSObject>

@optional
- (void)leftButtonDidTouch;
- (void)rightButtonDidTouch;

@end