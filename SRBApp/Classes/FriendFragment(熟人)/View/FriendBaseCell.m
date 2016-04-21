//
//  FriendBaseCell.m
//  SRBApp
//
//  Created by zxk on 14/12/25.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "FriendBaseCell.h"
#import <UIImageView+WebCache.h>

@implementation FriendBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        LogoImgView * logoImg = [[LogoImgView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        logoImg.layer.masksToBounds = YES;
        logoImg.userInteractionEnabled = YES;
        logoImg.layer.cornerRadius = 20;
        logoImg.userInteractionEnabled = YES;
        logoImg.contentMode = UIViewContentModeScaleAspectFill;
        logoImg.clipsToBounds = YES;
        self.logoImg = logoImg;
        [self addSubview:logoImg];
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 15, 9, 130, 19)];
        nameLabel.font = SIZE_FOR_IPHONE;
        nameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        CommonFriendLabel * descriptionLabel = [[CommonFriendLabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 15, nameLabel.frame.size.height + nameLabel.frame.origin.y + 8, SCREEN_WIDTH - 55 - 15 - 15 - 60 - 5, 14)];
        descriptionLabel.font = SIZE_FOR_12;
        descriptionLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.descriptionLabel = descriptionLabel;
        [self addSubview:descriptionLabel];
        
        ZZGoPayBtn * commonFriendBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeRoundedRect];
        commonFriendBtn.frame = CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 15, nameLabel.frame.size.height + nameLabel.frame.origin.y + 9, 75, 14);
        commonFriendBtn.titleLabel.font = SIZE_FOR_12;
        [commonFriendBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
        [commonFriendBtn setTitleColor:[GetColor16 hexStringToColor:@"#eeeeee"] forState:UIControlStateSelected];
        self.commonFriendBtn = commonFriendBtn;
        [self addSubview:commonFriendBtn];
        
        ZZGoPayBtn * addBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(SCREEN_WIDTH - 60 - 15, 35.0 / 2.0, 60, 25);
        [addBtn setTitle:@"添 加" forState:UIControlStateNormal];
        [addBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        addBtn.layer.masksToBounds = YES;
        addBtn.layer.cornerRadius = 2;
        addBtn.hidden = YES;
        addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
        self.addBtn = addBtn;
        [self addSubview:addBtn];
        
        UILabel * addedLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50-15, 35.0/2.0, 50, 25)];
        addedLabel.text = @"已添加";
        addedLabel.font = SIZE_FOR_IPHONE;
        addedLabel.hidden = YES;
        self.addedLabel = addedLabel;
        addedLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [self addSubview:addedLabel];
        
        
//        ZZGoPayBtn * chatBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];
//        chatBtn.frame = CGRectMake(SCREEN_WIDTH - 20 - 37.5, 20, 20, 20);
//        chatBtn.hidden = YES;
//        [chatBtn setBackgroundImage:[UIImage imageNamed:@"pop_chat"] forState:UIControlStateNormal];
//        self.chatBtn = chatBtn;
//        [self addSubview:chatBtn];
        

    }
    return self;
}

//- (void)hiddenOfSignView{
//    self.signView.hidden = NO;
//}

//cell的重用
+ (id)friendBaseCellWithTableView:(UITableView *)tableView
{
    static NSString * reuserID = @"search";
    FriendBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    if (cell == nil) {
        cell = [[FriendBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserID];
    }
    return cell;
}

- (void)setFriendFragmentModel:(FriendFragmentModel *)friendFragmentModel
{
    _friendFragmentModel = friendFragmentModel;
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:friendFragmentModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImg.clipsToBounds = YES;
    NSString * nameStr;
    if ([friendFragmentModel.memo isEqualToString:@""] || [friendFragmentModel.memo length] == 0) {
        nameStr = friendFragmentModel.nickname;
    }else{
        nameStr = friendFragmentModel.memo;
    }
    CGRect nameRect = self.nameLabel.frame;
    nameRect.size.width = SCREEN_WIDTH - 65 - 15;
    self.nameLabel.frame = nameRect;
    self.descriptionLabel.frame = CGRectMake(self.logoImg.frame.size.width + self.logoImg.frame.origin.x + 15, self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y + 8, SCREEN_WIDTH - 55 - 15 - 15, 14);
    self.nameLabel.text = nameStr;
    self.descriptionLabel.text = friendFragmentModel.sign;
    self.addBtn.hidden = YES;
    self.ignoreBtn.hidden = YES;
}

#pragma mark - 设置好友model
- (void)setFriendFragment:(NSIndexPath *)indexpath withFriendGroup:(FriendGroupModel *)friendGroup
{
    _friendGroupModel = friendGroup;
    NSDictionary * tempdic = friendGroup.group[indexpath.row];
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:[tempdic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImg.clipsToBounds = YES;
    NSString * nameStr;
    if ([[tempdic objectForKey:@"memo"]isEqualToString:@""] || [[tempdic objectForKey:@"memo"] length] == 0) {
        nameStr = [tempdic objectForKey:@"nickname"];
    }else{
        nameStr = [tempdic objectForKey:@"memo"];
    }
    CGRect nameRect = self.nameLabel.frame;
    nameRect.size.width = SCREEN_WIDTH - 65 - 15;
    self.nameLabel.frame = nameRect;
    self.descriptionLabel.frame = CGRectMake(self.logoImg.frame.size.width + self.logoImg.frame.origin.x + 15, self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y + 8, SCREEN_WIDTH - 55 - 15 - 15, 14);
    self.nameLabel.text = nameStr;
    self.descriptionLabel.text = [tempdic objectForKey:@"sign"];
    self.addBtn.hidden = YES;
    self.ignoreBtn.hidden = YES;
}

#pragma mark -设置新的熟人
- (void)setFriendNewModel:(NewFriendModel *)friendNewModel
{
    _friendNewModel = friendNewModel;
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:friendNewModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImg.clipsToBounds = YES;
    self.nameLabel.text = friendNewModel.nickname;
//    //日期格式化
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate * date = [dateFormatter dateFromString:friendNewModel.updatetime];
//    [dateFormatter setDateFormat:@"MM-dd"];
//    NSString * str = [dateFormatter stringFromDate:date];
    
//    NSString * tempStr = [NSString stringWithFormat:@"%@ 我是%@",str,friendNewModel.nickname];
    self.descriptionLabel.text = friendNewModel.say;
    if ([friendNewModel.isFriended isEqualToString:@"1"]) {
        self.addBtn.hidden = YES;
        self.addedLabel.hidden = NO;
    }else{
        self.addBtn.hidden = NO;
        self.addedLabel.hidden = YES;
    }
    
    [self.nameLabel sizeToFit];
    CGRect nameLabelRect = self.nameLabel.frame;
    CGRect tempRect = nameLabelRect;
    if (self.nameLabel.frame.size.width + self.nameLabel.frame.origin.x > SCREEN_WIDTH - 60 - 15 - 75) {
        tempRect.size.width = SCREEN_WIDTH - 60 - 15 - 75 - 70;
        self.nameLabel.frame = tempRect;
    }else{
        self.nameLabel.frame = CGRectMake(self.logoImg.frame.size.width + self.logoImg.frame.origin.x + 15, 10, 130, 18);
        [self.nameLabel sizeToFit];
    }
    self.commonFriendBtn.titleLabel.font = SIZE_FOR_12;
    self.commonFriendBtn.frame = CGRectMake(self.nameLabel.frame.size.width + self.nameLabel.frame.origin.x , self.nameLabel.frame.origin.y + 2, 75, 16);
    [self.commonFriendBtn setTitle:[NSString stringWithFormat:@"共同熟人%@人",friendNewModel.commonCount] forState:UIControlStateNormal] ;
}

- (void)setFriendSearchModel:(FriendSearchModel *)friendSearchModel
{
    _friendSearchModel = friendSearchModel;
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:friendSearchModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImg.clipsToBounds = YES;
    self.nameLabel.text = friendSearchModel.nickname;
    CGRect nameRect = self.nameLabel.frame;
    nameRect.size.width = SCREEN_WIDTH - 65 - 5 - 60 - 15;
    self.nameLabel.frame = nameRect;
    [self.commonFriendBtn setTitle:[NSString stringWithFormat:@"共同熟人%@人",friendSearchModel.commonCount] forState:UIControlStateNormal] ;
    if ([friendSearchModel.isFriended isEqualToString:@"0"]) {
        self.addBtn.hidden = NO;
        self.addedLabel.hidden = YES;
    }else{
        self.addBtn.hidden = YES;
        self.addedLabel.hidden = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
