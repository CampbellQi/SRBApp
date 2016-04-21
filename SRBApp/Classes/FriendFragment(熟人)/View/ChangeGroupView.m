//
//  ChangeGroupView.m
//  SRBApp
//
//  Created by zxk on 14/12/31.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ChangeGroupView.h"

@implementation ChangeGroupView
{
    UIView * bgView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self.nameText becomeFirstResponder];
//        bgView = [[UIView alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT/2 - 120, SCREEN_WIDTH - 30, 180)];
//        bgView.layer.masksToBounds = YES;
//        bgView.layer.cornerRadius = 6;
//        
//        UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 30)];
//        topView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//        bgView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
//        [bgView addSubview:topView];
//        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((topView.frame.size.width - 120)/2, 10, 120, 16)];
//        titleLabel.text = @"修改分组";
//        titleLabel.font = SIZE_FOR_IPHONE;
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        [topView addSubview:titleLabel];
//        
//        UILabel * grouplabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.frame.size.height + titleLabel.frame.origin.y + 10, 120, 14)];
//        grouplabel.font = SIZE_FOR_14;
//        grouplabel.text = @"新组名";
//        [bgView addSubview:grouplabel];
//        
//        self.nameText = [[UITextView alloc]initWithFrame:CGRectMake(grouplabel.frame.origin.x, grouplabel.frame.size.height + grouplabel.frame.origin.y + 4, bgView.frame.size.width - 20, 30)];
//        self.nameText.text = self.groupName;
//        //self.nameText.borderStyle = UITextBorderStyleRoundedRect;
//        //self.nameText.contentSize = CGSizeMake(bgView.frame.size.width - 20, 20);
//        self.nameText.layer.borderColor = [GetColor16 hexStringToColor:@"#959595"].CGColor;
//        self.nameText.layer.borderWidth = 1;
//        self.nameText.delegate = self;
//        self.nameText.font = SIZE_FOR_14;
//        
//        [bgView addSubview:self.nameText];
//        
//        UILabel * numlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.nameText.frame.size.height + self.nameText.frame.origin.y + 10, 120, 14)];
//        numlabel.font = SIZE_FOR_14;
//        numlabel.text = @"序号";
//        [bgView addSubview:numlabel];
//        
//        self.numText = [[UITextView alloc]initWithFrame:CGRectMake(numlabel.frame.origin.x, numlabel.frame.size.height + numlabel.frame.origin.y + 4, bgView.frame.size.width - 20, 30)];
//        self.numText.delegate = self;
//        self.numText.layer.borderColor = [GetColor16 hexStringToColor:@"#959595"].CGColor;
//        self.numText.layer.borderWidth = 1;
//        self.numText.contentSize = CGSizeMake(bgView.frame.size.width - 20, 20);
//        self.numText.font = SIZE_FOR_14;
//        [bgView addSubview:self.numText];
//        
//        
//        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.numText.frame.size.height + self.numText.frame.origin.y + 4, bgView.frame.size.width, 1)];
//        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//        [bgView addSubview:lineView];
//        
//        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        cancelBtn.frame = CGRectMake(0, lineView.frame.size.height + lineView.frame.origin.y, bgView.frame.size.width/2, 30);
//        //        cancelBtn.highlighted = YES;
//        [cancelBtn addTarget:self action:@selector(baseBtn:) forControlEvents:UIControlEventTouchUpInside];
//        cancelBtn.tag = 0;
//        [cancelBtn setTitleColor:RGBCOLOR(28, 0, 206, 1) forState:UIControlStateNormal];
//        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        
//        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [sureBtn addTarget:self action:@selector(baseBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [sureBtn setTitleColor:RGBCOLOR(28, 0, 206, 1) forState:UIControlStateNormal];
//        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//        sureBtn.frame = CGRectMake(bgView.frame.size.width/2, lineView.frame.size.height + lineView.frame.origin.y, bgView.frame.size.width/2, 30);
//        sureBtn.tag = 1;
//        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
//        
//        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(bgView.frame.size.width / 2 - 1, cancelBtn.frame.origin.y, 1, cancelBtn.frame.size.height)];
//        lineView2.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//        
//        [bgView addSubview:cancelBtn];
//        [bgView addSubview:sureBtn];
//        [bgView addSubview:lineView2];
//        [self addSubview:bgView];
//        
//        //        UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        //        tempView.alpha = 0.5;
//        //        tempView.backgroundColor = LIGHTGRAY;
//        //        [self insertSubview:tempView atIndex:0];

    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview != nil) {
        
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT/2 - 120, SCREEN_WIDTH - 30, 180)];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 6;
        
        UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 30)];
        topView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        bgView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        [bgView addSubview:topView];
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((topView.frame.size.width - 120)/2, 10, 120, 16)];
        titleLabel.text = @"修改分组";
        titleLabel.font = SIZE_FOR_IPHONE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:titleLabel];
        
        UILabel * grouplabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.frame.size.height + titleLabel.frame.origin.y + 10, 120, 14)];
        grouplabel.font = SIZE_FOR_14;
        grouplabel.text = @"新组名";
        [bgView addSubview:grouplabel];
        
        self.nameText = [[UITextView alloc]initWithFrame:CGRectMake(grouplabel.frame.origin.x, grouplabel.frame.size.height + grouplabel.frame.origin.y + 4, bgView.frame.size.width - 20, 30)];
        self.nameText.text = self.groupName;
        //self.nameText.borderStyle = UITextBorderStyleRoundedRect;
        //self.nameText.contentSize = CGSizeMake(bgView.frame.size.width - 20, 20);
        self.nameText.layer.borderColor = [GetColor16 hexStringToColor:@"#959595"].CGColor;
        self.nameText.layer.borderWidth = 1;
        self.nameText.delegate = self;
        self.nameText.font = SIZE_FOR_14;
        
        [bgView addSubview:self.nameText];
        
        UILabel * numlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.nameText.frame.size.height + self.nameText.frame.origin.y + 10, 120, 14)];
        numlabel.font = SIZE_FOR_14;
        numlabel.text = @"序号";
        [bgView addSubview:numlabel];
        
        self.numText = [[UITextView alloc]initWithFrame:CGRectMake(numlabel.frame.origin.x, numlabel.frame.size.height + numlabel.frame.origin.y + 4, bgView.frame.size.width - 20, 30)];
        self.numText.delegate = self;
        self.numText.layer.borderColor = [GetColor16 hexStringToColor:@"#959595"].CGColor;
        self.numText.layer.borderWidth = 1;
        self.numText.contentSize = CGSizeMake(bgView.frame.size.width - 20, 20);
        self.numText.font = SIZE_FOR_14;
        [bgView addSubview:self.numText];

        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.numText.frame.size.height + self.numText.frame.origin.y + 4, bgView.frame.size.width, 1)];
        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [bgView addSubview:lineView];
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.frame = CGRectMake(0, lineView.frame.size.height + lineView.frame.origin.y, bgView.frame.size.width/2, 30);
//        cancelBtn.highlighted = YES;
        [cancelBtn addTarget:self action:@selector(baseBtn:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.tag = 0;
        [cancelBtn setTitleColor:RGBCOLOR(28, 0, 206, 1) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateHighlighted];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [sureBtn addTarget:self action:@selector(baseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setTitleColor:RGBCOLOR(28, 0, 206, 1) forState:UIControlStateNormal];
        [sureBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateHighlighted];
        sureBtn.frame = CGRectMake(bgView.frame.size.width/2, lineView.frame.size.height + lineView.frame.origin.y, bgView.frame.size.width/2, 30);
        sureBtn.tag = 1;
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(bgView.frame.size.width / 2 - 1, cancelBtn.frame.origin.y, 1, cancelBtn.frame.size.height)];
        lineView2.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        
        [bgView addSubview:cancelBtn];
        [bgView addSubview:sureBtn];
        [bgView addSubview:lineView2];
        [self addSubview:bgView];
        
//        UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        tempView.alpha = 0.5;
//        tempView.backgroundColor = LIGHTGRAY;
//        [self insertSubview:tempView atIndex:0];
        
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect rect = bgView.frame;
    rect.origin.y -= 30;
    bgView.frame = rect;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect rect = bgView.frame;
    rect.origin.y += 30;
    bgView.frame = rect;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

- (void)baseBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(changeGroup:didSelectBtn:withName:andNum:)]) {
        [self.delegate changeGroup:self didSelectBtn:btn.tag withName:self.nameText.text andNum:self.numText.text];
    }
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
