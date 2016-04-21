//
//  MyCommentView.m
//  SRBApp
//
//  Created by zxk on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MyCommentView.h"
#import "Singleton.h"

@implementation MyCommentView
{
    CGPoint beginPoint;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CommentNameView * name1View = [[CommentNameView alloc]init];
        name1View.frame = CGRectMake(0, 3, 60, 17);
        name1View.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        self.name1View = name1View;

//        UILabel * huifuLabel = [[UILabel alloc]init];
//        huifuLabel.font = [UIFont systemFontOfSize:13];
//        huifuLabel.hidden = YES;
//        huifuLabel.text = @"回复";
//        huifuLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
//        self.huifuLabel = huifuLabel;
//        //[self addSubview:huifuLabel];
//        
//        CommentNameView * name2View = [[CommentNameView alloc]init];
//        name2View.hidden = YES;
//        name2View.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
//        name2View.frame = CGRectMake(name1View.frame.size.width + name1View.frame.origin.x + 28, 3, 60, 17);
//        self.name2View = name2View;
//        
//        MyLabel * commentLabel = [[MyLabel alloc]init];
//        commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        commentLabel.verticalAlignment = VerticalAlignmentTop;
//        commentLabel.font = SIZE_FOR_14;
//        commentLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
//        commentLabel.numberOfLines = 0;
//        self.commentLabel = commentLabel;
//        
//        [self addSubview:commentLabel];
//        [self addSubview:name1View];
//        [self addSubview:name2View];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    beginPoint = [[touches anyObject]locationInView:self];
    Singleton * singleton = [Singleton sharedInstance];
    singleton.pinglunTap = YES;
    [self setBackgroundColor:[GetColor16 hexStringToColor:@"#e6e6e6"]];
    self.name1View.backgroundColor = [GetColor16 hexStringToColor:@"#e6e6e6"];
    self.name2View.backgroundColor = [GetColor16 hexStringToColor:@"#e6e6e6"];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[GetColor16 hexStringToColor:@"#f6f6f6"]];
    self.name1View.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    self.name2View.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //CGPoint tempPoint = [[touches anyObject]locationInView:self];
    Singleton * singleton = [Singleton sharedInstance];
    singleton.pinglunTap = NO;
//    if (tempPoint.x != beginPoint.x) {
//        Singleton * singleton = [Singleton sharedInstance];
//        singleton.pinglunTap = NO;
//    }
    [self setBackgroundColor:[GetColor16 hexStringToColor:@"#f6f6f6"]];
    self.name1View.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    self.name2View.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
}

@end
