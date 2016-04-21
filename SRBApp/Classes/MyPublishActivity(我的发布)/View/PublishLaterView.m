//
//  PublishLaterView.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "PublishLaterView.h"

@implementation PublishLaterView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, 125, 60 , 100 )];
        image1.image = [UIImage imageNamed:@"xiaoren"];
        [self addSubview:image1];
        
        UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake(image1.frame.size.width + image1.frame.origin.x + 10, image1.frame.origin.y + 10,130 ,50 )];
        image2.image = [UIImage imageNamed:@"publish_done_notice"];
        [self addSubview:image2];
        
        _lookNowButton = [[UIButton alloc]initWithFrame:CGRectMake(image1.center.x, image1.frame.origin.y + image1.frame.size.height + 45, 130 ,65 /2)];
        [_lookNowButton setBackgroundImage:[UIImage imageNamed:@"publish_btn_cyan_nor"] forState:UIControlStateNormal];
        [_lookNowButton setBackgroundImage:[UIImage imageNamed:@"publish_btn_cyan_pre"] forState:UIControlStateHighlighted];
        [_lookNowButton setTitle:@"立即查看" forState:UIControlStateNormal];
        [_lookNowButton setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        [self addSubview:_lookNowButton];
        
        _goOnPublishButton = [[UIButton alloc]initWithFrame:CGRectMake(_lookNowButton.frame.origin.x, _lookNowButton.frame.origin.y + _lookNowButton.frame.size.height + 25, 130 ,65 /2)];
        [_goOnPublishButton setBackgroundImage:[UIImage imageNamed:@"publish_btn_orange_nor"] forState:UIControlStateNormal];
        [_goOnPublishButton setBackgroundImage:[UIImage imageNamed:@"publish_btn_orange_pre"] forState:UIControlStateHighlighted];
        [_goOnPublishButton setTitle:@"继续发布" forState:UIControlStateNormal];
        [_goOnPublishButton setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        [self addSubview:_goOnPublishButton];
        
        _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(_goOnPublishButton.frame.origin.x, _goOnPublishButton.frame.origin.y + _goOnPublishButton.frame.size.height + 25, 130 ,65 /2)];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"publish_btn_pink_nor"] forState:UIControlStateNormal];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"publish_btn_pink_pre"] forState:UIControlStateHighlighted];
        [_shareButton setTitle:@"分享到..." forState:UIControlStateNormal];
        [_shareButton setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        [self addSubview:_shareButton];
        
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

@end
