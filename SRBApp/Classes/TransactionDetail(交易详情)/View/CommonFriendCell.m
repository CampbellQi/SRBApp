//
//  CommonFriendCell.m
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CommonFriendCell.h"
#import <UIImageView+WebCache.h>

@implementation CommonFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        self.imgView = imgview;
        imgview.layer.cornerRadius = 20;
        imgview.layer.masksToBounds = YES;
        imgview.userInteractionEnabled = YES;
        [self addSubview:imgview];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgview.frame.size.width + imgview.frame.origin.x + 15, 13, SCREEN_WIDTH - 70 - 37.5 - 20, 18)];
        titleLabel.font = SIZE_FOR_IPHONE;
        titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel * signLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.size.height + titleLabel.frame.origin.y + 8, titleLabel.frame.size.width, 30)];
        
        signLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        signLabel.font = SIZE_FOR_12;
        signLabel.numberOfLines = 0;
        self.signLabel = signLabel;
        [self addSubview:signLabel];
        
        ZZGoPayBtn * chatBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];
        chatBtn.frame = CGRectMake(SCREEN_WIDTH - 20 - 37.5, 15, 20, 20);
        chatBtn.hidden = YES;
        [chatBtn setBackgroundImage:[UIImage imageNamed:@"detail_activity_comment_normal"] forState:UIControlStateNormal];
        self.chatBtn = chatBtn;
        [self addSubview:chatBtn];
    }
    return self;
}

//创建cell
+ (id)settingCellWithTaableView:(UITableView *)tableView
{
    static NSString * reuse = @"attentionList";
    CommonFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CommonFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    return cell;
}

- (void)setCommenFriendModel:(CommenFriendModel *)commenFriendModel
{
    _commenFriendModel = commenFriendModel;
    self.chatBtn.hidden = NO;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:commenFriendModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    self.titleLabel.text = commenFriendModel.nickname;
    self.signLabel.text = commenFriendModel.sign;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
