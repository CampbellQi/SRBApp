//
//  PersonalCell.m
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "PersonalCell.h"


@implementation PersonalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
        self.logoImg = logoImg;
        logoImg.layer.masksToBounds = YES;
        logoImg.layer.cornerRadius = 20;
        logoImg.userInteractionEnabled = YES;
        [self addSubview:logoImg];
        
        
        //足迹
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 8, 15, 100, 15)];
        nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel = nameLabel;
        nameLabel.textColor = [GetColor16 hexStringToColor:@"#0071bc"];
        [self addSubview:nameLabel];
        
        UILabel * descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 8, nameLabel.frame.size.height + nameLabel.frame.origin.y + 8, SCREEN_WIDTH - 15 - 15 - 20 - 8, 32)];
        descriptionLabel.font = SIZE_FOR_14;
        descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        descriptionLabel.numberOfLines = 0;
        self.descriptionLabel = descriptionLabel;
        [self addSubview:descriptionLabel];
        
        UIImageView * phohoImg = [[UIImageView alloc]initWithFrame:CGRectMake(descriptionLabel.frame.origin.x, logoImg.frame.size.height + logoImg.frame.origin.y + 12, 200, 200)];
        self.photoImg = phohoImg;
        [self addSubview:phohoImg];
        
        UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, 15, 100, 12)];
        timeLabel.font = SIZE_FOR_12;
        timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        
        UIImageView * locationImg = [[UIImageView alloc]init];
        self.locationImg = locationImg;
        locationImg.image = [UIImage imageNamed:@"fb_wz"];
        [self addSubview:locationImg];
        
        
        UILabel * addressLabel = [[UILabel alloc]init];
        self.addressLabel = addressLabel;
        addressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        addressLabel.numberOfLines = 0;
        addressLabel.font = SIZE_FOR_12;
        [self addSubview:addressLabel];
        
        UIImageView * sanjiaoImg = [[UIImageView alloc]init];
        sanjiaoImg.image = [UIImage imageNamed:@"bg_comment"];
        self.sanjiaoImg = sanjiaoImg;
        [self addSubview:sanjiaoImg];
        
        UIView * zanNumBgView = [[UIView alloc]init];
        zanNumBgView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        self.zanNumBgView = zanNumBgView;
        [self addSubview:zanNumBgView];
        
        UILabel * numPerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, zanNumBgView.frame.size.width, 12)];
        self.numPerLabel = numPerLabel;
        numPerLabel.font = SIZE_FOR_12;
        numPerLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [zanNumBgView addSubview:numPerLabel];
        
        
        //显示点赞和分享按钮
        ZZGoPayBtn * moreBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];
        self.moreBtn = moreBtn;
        [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(showMoreView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
        
        LeftImgAndRightTitleBtn * zanBtn =  [LeftImgAndRightTitleBtn buttonWithType:UIButtonTypeCustom];
        [zanBtn setTitle:@"点赞" forState:UIControlStateNormal];
        [zanBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
        [zanBtn setBackgroundColor:[GetColor16 hexStringToColor:@"#e5005d"]];
        self.zanBtn = zanBtn;
        zanBtn.hidden = YES;
        [self addSubview:zanBtn];
        
        LeftImgAndRightTitleBtn * shareBtn =  [LeftImgAndRightTitleBtn buttonWithType:UIButtonTypeCustom];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setBackgroundColor:[GetColor16 hexStringToColor:@"#e5005d"]];
        [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        self.shareBtn = shareBtn;
        shareBtn.hidden = YES;
        [self addSubview:shareBtn];
        
        UILabel * alertLabel = [[UILabel alloc]init];
        alertLabel.text = @"+1";
        self.alertLabel = alertLabel;
        alertLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        self.alertLabel.hidden = YES;
        [self addSubview:alertLabel];
        
        
        
        
        //交易cell
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 + 100, 15 + 40 + 9, SCREEN_WIDTH - 145, 35)];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        _detailLabel.hidden = YES;
        [self.contentView addSubview:_detailLabel];

        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 + 100, 15 + 40 + 9, 150, 35)];
        _priceLabel.font = [UIFont systemFontOfSize:21];
        _priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        _priceLabel.hidden = YES;
        [self.contentView addSubview:_priceLabel];
        
        _postLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 45 - 80, _priceLabel.frame.origin.y + 10, 80, 14)];
        _postLabel.font = SIZE_FOR_14;
        _postLabel.textAlignment = NSTextAlignmentRight;
        _postLabel.hidden = YES;
        _postLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [self.contentView addSubview:_postLabel];
        
        _thingimage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 100, 100)];
        [self.contentView addSubview:_thingimage];
        
        _signImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 37.5, 37.5)];
        _signImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_signImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_thingimage.frame.origin.x + _thingimage.frame.size.width + 15, 15, SCREEN_WIDTH - 45 - 100, 40)];
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = SIZE_FOR_IPHONE;
        [self.contentView addSubview:_titleLabel];
        
        _jiaoyiNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, 130 - 15 - 16, 150, 16)];
        _jiaoyiNameLabel.font = SIZE_FOR_14;
        _jiaoyiNameLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [self.contentView addSubview:_jiaoyiNameLabel];

    }
    return self;
}

- (void)setLocationModel:(LocationModel *)locationModel
{
    _locationModel = locationModel;
    self.thingimage.hidden = YES;
    self.jiaoyiNameLabel.hidden = YES;
    self.signImage.hidden = YES;
    self.detailLabel.hidden = YES;
    self.priceLabel.hidden = YES;
    self.postLabel.hidden = YES;
    self.titleLabel.hidden = YES;
    
    self.logoImg.hidden = NO;
    self.nameLabel.hidden = NO;
    self.descriptionLabel.hidden = NO;
    self.photoImg.hidden = NO;
    self.locationImg.hidden = NO;
    self.addressLabel.hidden = NO;
    self.moreBtn.hidden = NO;
    self.sanjiaoImg.hidden = NO;
    self.zanNumBgView.hidden = NO;
    self.numPerLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    self.alertLabel.hidden = NO;
    
    
    
    CGRect rect = [locationModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 15 - 20 - 8, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
    CGRect descriptionFram = self.descriptionLabel.frame;
    descriptionFram.size.height = rect.size.height;
    self.descriptionLabel.frame = descriptionFram;
    
    if ([locationModel.url isEqualToString:@""]) {
        self.photoImg.hidden = YES;
        self.locationImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 12, 11, 16);
    }else{
        self.photoImg.hidden = NO;
        self.photoImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 12, 200, 200);
        [self.photoImg sd_setImageWithURL:[NSURL URLWithString:locationModel.url] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        self.photoImg.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImg.clipsToBounds = YES;
        self.locationImg.frame = CGRectMake(self.photoImg.frame.origin.x, self.photoImg.frame.size.height + self.photoImg.frame.origin.y + 12, 11, 16);
    }
    self.addressLabel.frame = CGRectMake(self.locationImg.frame.origin.x + self.locationImg.frame.size.width + 4, self.locationImg.frame.origin.y , 180, 30);
    self.moreBtn.frame = CGRectMake(SCREEN_WIDTH - 25.5 - 30, self.locationImg.frame.origin.y, 25.5, 14.5);
    self.sanjiaoImg.frame = CGRectMake(self.locationImg.frame.size.width + self.locationImg.frame.origin.x, self.locationImg.frame.origin.y + self.locationImg.frame.size.height + 8, 8, 10);
    self.zanNumBgView.frame = CGRectMake(self.locationImg.frame.origin.x, self.sanjiaoImg.frame.origin.y + self.sanjiaoImg.frame.size.height, SCREEN_WIDTH - 15 - 15 - 20 - 8 - 20, 30);
    self.zanBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 30 - 10 - 150, self.moreBtn.frame.origin.y - 5, 75, 30);
    self.shareBtn.frame = CGRectMake(self.zanBtn.frame.origin.x + self.zanBtn.frame.size.width, self.moreBtn.frame.origin.y - 5, 75, 30);
    
    self.numPerLabel.frame = CGRectMake(15, 9, self.zanNumBgView.frame.size.width, 12);
    self.addressLabel.text = locationModel.title;
    self.numPerLabel.text = [NSString stringWithFormat:@"%@人觉得很赞",locationModel.likeCount];
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:locationModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImg.clipsToBounds = YES;
    self.nameLabel.text = locationModel.nickname;
    self.descriptionLabel.text = locationModel.content;
    
    [UIView animateWithDuration:0.6 animations:^{
        if (!self.locationModel.isClick) {
            self.zanBtn.hidden = YES;
            self.zanBtn.alpha = 1;
            self.zanBtn.alpha = 0;
            self.shareBtn.hidden = YES;
            self.shareBtn.alpha = 1;
            self.shareBtn.alpha = 0;
        }else{
            self.zanBtn.hidden = NO;
            self.zanBtn.alpha = 0;
            self.zanBtn.alpha = 1;
            self.shareBtn.hidden = NO;
            self.shareBtn.alpha = 0;
            self.shareBtn.alpha = 1;
        }
    }];
}

- (void)setBussinessModel:(BussinessModel *)bussinessModel
{
    _bussinessModel = self.bussinessModel;
    self.thingimage.hidden = NO;
    self.jiaoyiNameLabel.hidden = NO;
    self.signImage.hidden = NO;
    self.detailLabel.hidden = NO;
    self.priceLabel.hidden = NO;
    self.postLabel.hidden = NO;
    self.titleLabel.hidden = NO;
    
    
    self.logoImg.hidden = YES;
    self.nameLabel.hidden = YES;
    self.descriptionLabel.hidden = YES;
    self.photoImg.hidden = YES;
    self.locationImg.hidden = YES;
    self.addressLabel.hidden = YES;
    self.moreBtn.hidden = YES;
    self.sanjiaoImg.hidden = YES;
    self.zanNumBgView.hidden = YES;
    self.numPerLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    self.alertLabel.hidden = YES;
    
    if ([bussinessModel.dealName isEqualToString:@"想买"]) {
        self.detailLabel.hidden = NO;
        self.detailLabel.text = bussinessModel.model_description;
        self.signImage.image = [UIImage imageNamed:@"BUYtag"];
        self.jiaoyiNameLabel.text = [NSString stringWithFormat:@"买家:%@", bussinessModel.nickname];
        self.postLabel.hidden = YES;
        self.priceLabel.hidden = YES;
    }else{
        self.detailLabel.hidden = YES;
        self.signImage.image = [UIImage imageNamed:@"SALEtag"];
        self.jiaoyiNameLabel.text = [NSString stringWithFormat:@"卖家:%@", bussinessModel.nickname];
        if ([bussinessModel.freeShipment isEqualToString:@"1"]) {
            self.postLabel.text = @"包邮";
        }else{
            self.postLabel.text = @"不包邮";
        }
        self.postLabel.hidden = NO;
        self.priceLabel.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",bussinessModel.bangPrice];
    }
    [self.thingimage sd_setImageWithURL:[NSURL URLWithString:bussinessModel.cover] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.thingimage.contentMode = UIViewContentModeScaleAspectFill;
    self.thingimage.clipsToBounds = YES;
    self.titleLabel.text = bussinessModel.title;
    
}

+ (id)personalCellWithTaableView:(UITableView *)tableView
{
    static NSString * reuseID = @"personal";
    PersonalCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[PersonalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)showAlertLabel
{
    self.alertLabel.frame = CGRectMake(self.zanBtn.frame.size.width/2 + self.zanBtn.frame.origin.x, self.zanBtn.frame.origin.y, 20, 20);
    [UIView animateWithDuration:0.5 animations:^{
        self.alertLabel.hidden = NO;
        self.alertLabel.frame = CGRectMake(self.zanBtn.frame.size.width/2 + self.zanBtn.frame.origin.x, self.zanBtn.frame.origin.y - 20, 20, 20);
    } completion:^(BOOL finished) {
        self.alertLabel.hidden = YES;
    }];
    
    self.locationModel.isClick = !self.locationModel.isClick;
    [UIView animateWithDuration:0.3 animations:^{
        self.zanBtn.hidden = YES;
        self.shareBtn.hidden = YES;
    }];
}

- (void)showMoreView:(ZZGoPayBtn *)sender
{
    
    if (self.locationModel.isClick) {
        self.locationModel.isClick = NO;
    }else{
        self.locationModel.isClick = YES;
    }
    [_delegate viewreloadData];
}



@end
