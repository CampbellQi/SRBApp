//
//  LocationCell.m
//  SRBApp
//
//  Created by zxk on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "LocationCell.h"
#import <UIImageView+WebCache.h>
#import <CoreText/CoreText.h>
#import "PersonalViewController.h"


@implementation LocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (UIView * currentView in self.subviews)
        {
            if ([NSStringFromClass([currentView class]) isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *) currentView;
                scroll.delaysContentTouches = NO;
                break;
            }
        }
        
        MyImgView * logoImg = [[MyImgView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
        self.logoImg = logoImg;
        logoImg.layer.masksToBounds = YES;
        logoImg.layer.cornerRadius = 20;
        logoImg.userInteractionEnabled = YES;
        [self addSubview:logoImg];
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame) + 8, 12, 200, 20)];
        nameLabel.font = SIZE_FOR_IPHONE;
        nameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, nameLabel.frame.origin.y, 100, 12)];
        timeLabel.font = SIZE_FOR_12;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        
        LocationTextView * descriptionLabel = [[LocationTextView alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 8, nameLabel.frame.size.height + nameLabel.frame.origin.y + 8, SCREEN_WIDTH - 15 - 15 - 40 - 8, 26)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.userInteractionEnabled = YES;
        descriptionLabel.font = [UIFont systemFontOfSize:15];
        
        descriptionLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.descriptionLabel = descriptionLabel;
        [self addSubview:descriptionLabel];
        
        UIButton *fullTextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.descriptionLabel.x - 3, descriptionLabel.y + descriptionLabel.height +5, 35, 15)];
        [fullTextBtn setTitle:@"全文" forState:UIControlStateNormal];
        [fullTextBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        fullTextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.fullTextBtn = fullTextBtn;
        [self addSubview:fullTextBtn];
        
        TapImageView * photoBig = [[TapImageView alloc]initWithFrame:CGRectMake(descriptionLabel.frame.origin.x, fullTextBtn.frame.size.height + fullTextBtn.frame.origin.y + 12, 200, 200)];
        photoBig.hidden = YES;
        photoBig.tag = 601;
        //photoBig.contentMode = UIViewContentModeScaleAspectFill;
        //photoBig.clipsToBounds = YES;
        self.photoImg = photoBig;
        photoBig.userInteractionEnabled = YES;
        [self addSubview:photoBig];
        
        TapImageView * phohoImg = [[TapImageView alloc]initWithFrame:CGRectMake(descriptionLabel.frame.origin.x, fullTextBtn.frame.size.height + fullTextBtn.frame.origin.y + 12, 72, 72)];
        self.photoImg1 = phohoImg;
        phohoImg.hidden = YES;
        phohoImg.contentMode = UIViewContentModeScaleAspectFill;
        phohoImg.clipsToBounds = YES;
        phohoImg.tag = 501;
        phohoImg.userInteractionEnabled = YES;
        [self addSubview:phohoImg];
        
        TapImageView * phohoImg2 = [[TapImageView alloc]initWithFrame:CGRectMake(phohoImg.frame.origin.x + phohoImg.frame.size.width + 3, fullTextBtn.frame.size.height + fullTextBtn.frame.origin.y + 12, 72, 72)];
        self.photoImg2 = phohoImg2;
        phohoImg2.contentMode = UIViewContentModeScaleAspectFill;
        phohoImg2.clipsToBounds = YES;
        phohoImg2.hidden = YES;
        phohoImg2.tag = 502;
        phohoImg2.userInteractionEnabled = YES;
        [self addSubview:phohoImg2];
        
        TapImageView * phohoImg3 = [[TapImageView alloc]initWithFrame:CGRectMake(phohoImg2.frame.origin.x + phohoImg2.frame.size.width + 3, fullTextBtn.frame.size.height + fullTextBtn.frame.origin.y + 12, 72, 72)];
        self.photoImg3 = phohoImg3;
        phohoImg3.contentMode = UIViewContentModeScaleAspectFill;
        phohoImg3.clipsToBounds = YES;
        phohoImg3.hidden = YES;
        phohoImg3.tag = 503;
        phohoImg3.userInteractionEnabled = YES;
        [self addSubview:phohoImg3];
        
        TapImageView * phohoImg4 = [[TapImageView alloc]initWithFrame:CGRectMake(descriptionLabel.frame.origin.x, fullTextBtn.frame.size.height + fullTextBtn.frame.origin.y + 12 + 72 + 3, 72, 72)];
        self.photoImg4 = phohoImg4;
        phohoImg4.contentMode = UIViewContentModeScaleAspectFill;
        phohoImg4.clipsToBounds = YES;
        phohoImg4.hidden = YES;
        phohoImg4.tag = 504;
        phohoImg4.userInteractionEnabled = YES;
        [self addSubview:phohoImg4];
        
        TapImageView * phohoImg5 = [[TapImageView alloc]initWithFrame:CGRectMake(phohoImg4.frame.origin.x + phohoImg4.frame.size.width +3, fullTextBtn.frame.size.height + fullTextBtn.frame.origin.y + 12 + 72 + 3, 72, 72)];
        self.photoImg5 = phohoImg5;
        phohoImg5.contentMode = UIViewContentModeScaleAspectFill;
        phohoImg5.clipsToBounds = YES;
        phohoImg5.hidden = YES;
        phohoImg5.tag = 505;
        phohoImg5.userInteractionEnabled = YES;
        [self addSubview:phohoImg5];
        
        TapImageView * phohoImg6 = [[TapImageView alloc]initWithFrame:CGRectMake(phohoImg5.frame.origin.x + phohoImg5.frame.size.width +3, fullTextBtn.frame.size.height + fullTextBtn.frame.origin.y + 12 + 72 + 3, 72, 72)];
        self.photoImg6 = phohoImg6;
        phohoImg6.contentMode = UIViewContentModeScaleAspectFill;
        phohoImg6.clipsToBounds = YES;
        phohoImg6.hidden = YES;
        phohoImg6.tag = 506;
        phohoImg6.userInteractionEnabled = YES;
        [self addSubview:phohoImg6];
        
        TapImageView * photoImg7 = [[TapImageView alloc]initWithFrame:CGRectMake(descriptionLabel.frame.origin.x, CGRectGetMaxY(phohoImg6.frame) + 3, 72, 72)];
        self.photoImg7 = photoImg7;
        photoImg7.contentMode = UIViewContentModeScaleAspectFill;
        photoImg7.clipsToBounds = YES;
        photoImg7.hidden = YES;
        photoImg7.tag = 507;
        photoImg7.userInteractionEnabled = YES;
        [self addSubview:photoImg7];
        
        TapImageView * photoImg8 = [[TapImageView alloc]initWithFrame:CGRectMake(photoImg7.frame.origin.x + photoImg7.frame.size.width +3, photoImg7.y, 72, 72)];
        self.photoImg8 = photoImg8;
        photoImg8.contentMode = UIViewContentModeScaleAspectFill;
        photoImg8.clipsToBounds = YES;
        photoImg8.hidden = YES;
        photoImg8.tag = 508;
        photoImg8.userInteractionEnabled = YES;
        [self addSubview:photoImg8];
        
        TapImageView * photoImg9 = [[TapImageView alloc]initWithFrame:CGRectMake(photoImg8.frame.origin.x + photoImg8.frame.size.width +3, photoImg8.y, 72, 72)];
        self.photoImg9 = photoImg9;
        photoImg9.contentMode = UIViewContentModeScaleAspectFill;
        photoImg9.clipsToBounds = YES;
        photoImg9.hidden = YES;
        photoImg9.tag = 509;
        photoImg9.userInteractionEnabled = YES;
        [self addSubview:photoImg9];
        
        UIImageView * locationImg = [[UIImageView alloc]init];
        self.locationImg = locationImg;
        locationImg.image = [UIImage imageNamed:@"fb_wz"];
        [self addSubview:locationImg];
        
        MyLabel * addressLabel = [[MyLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 33)];
        self.addressLabel = addressLabel;
        addressLabel.userInteractionEnabled = YES;
        addressLabel.verticalAlignment = VerticalAlignmentTop;
//        addressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        addressLabel.numberOfLines = 1;
        addressLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        addressLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:addressLabel];
        
        UIImageView * sanjiaoImg = [[UIImageView alloc]init];
        sanjiaoImg.image = [UIImage imageNamed:@"bg_comment"];
        self.sanjiaoImg = sanjiaoImg;
        [self addSubview:sanjiaoImg];
        
        UIView * zanNumBgView = [[UIView alloc]init];
        zanNumBgView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        self.zanNumBgView = zanNumBgView;
        [self addSubview:zanNumBgView];
        
//        UILabel * numPerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, zanNumBgView.frame.size.width, 12)];
//        self.numPerLabel = numPerLabel;
//        numPerLabel.font = SIZE_FOR_12;
//        numPerLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
//        [zanNumBgView addSubview:numPerLabel];
        
        UIView * tempViewForZanPerson = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 78, 30)];
        tempViewForZanPerson.hidden = YES;
        tempViewForZanPerson.backgroundColor = [GetColor16 hexStringToColor:@"f6f6f6"];
        self.tempViewForZanPerson = tempViewForZanPerson;
        [zanNumBgView addSubview:tempViewForZanPerson];
        
        UIView * zanLineView = [[UIView alloc]initWithFrame:CGRectMake(0, tempViewForZanPerson.frame.size.height + tempViewForZanPerson.frame.origin.y, zanNumBgView.frame.size.width, 1)];
        zanLineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        self.zanLineView = zanLineView;
        [zanNumBgView addSubview:zanLineView];
        
        //无用
        UIView * tempViewForComment = [[UIView alloc]initWithFrame:CGRectMake(0, zanLineView.frame.size.height + zanLineView.frame.origin.y + 5, zanNumBgView.frame.size.width, 30)];
        self.tempViewForComment = tempViewForComment;
        tempViewForComment.hidden = YES;
        [zanNumBgView addSubview:tempViewForComment];
        
        MyView * commentBGView = [[MyView alloc]init];
        commentBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        self.commentBGView = commentBGView;
        [zanNumBgView addSubview:commentBGView];
        
        UILabel * sayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,3,100,14)];
        sayLabel.font = SIZE_FOR_14;
        sayLabel.text = @"我来说一句";
        sayLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [commentBGView addSubview:sayLabel];
        
        //显示点赞和分享按钮
        UIView * twoButtonView = [[UIView alloc]init];
        twoButtonView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
        self.twoButtonView = twoButtonView;
        twoButtonView.layer.masksToBounds = YES;
        twoButtonView.layer.cornerRadius = 4;
        twoButtonView.hidden = YES;
        [self addSubview:twoButtonView];
        
        ZZGoPayBtn * moreBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];
        self.moreBtn = moreBtn;
        [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"location_more_pre"] forState:UIControlStateHighlighted];
        //[moreBtn addTarget:self action:@selector(showMoreView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
    
        LeftImgAndRightTitleBtn * zanBtn =  [LeftImgAndRightTitleBtn buttonWithType:UIButtonTypeCustom];
        [zanBtn setTitle:@"  赞" forState:UIControlStateNormal];
        [zanBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
//        [zanBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [zanBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [zanBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
        self.zanBtn = zanBtn;
        zanBtn.layer.masksToBounds = YES;
        zanBtn.layer.cornerRadius = 4;
        //zanBtn.hidden = YES;
        [twoButtonView addSubview:zanBtn];
        
        LeftImgAndRightTitleBtn * shareBtn =  [LeftImgAndRightTitleBtn buttonWithType:UIButtonTypeCustom];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
        [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        self.shareBtn = shareBtn;
        shareBtn.layer.masksToBounds = YES;
        shareBtn.layer.cornerRadius = 4;
        //shareBtn.hidden = YES;
        [twoButtonView addSubview:shareBtn];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#f94888"];
        self.lineView = lineView;
        //lineView.hidden = YES;
        [twoButtonView addSubview:lineView];
        
        UILabel * alertLabel = [[UILabel alloc]init];
        alertLabel.text = @"+1";
        alertLabel.font = [UIFont systemFontOfSize:20];
        self.alertLabel = alertLabel;
        alertLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        self.alertLabel.hidden = YES;
        [self addSubview:alertLabel];
        
        ZZGoPayBtn * delBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeCustom];
        self.delBtn = delBtn;
        [self.delBtn setTitle:@"删除" forState:UIControlStateNormal];
        delBtn.titleLabel.font = SIZE_FOR_14;
        [self.delBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"]  forState:UIControlStateNormal];
        [self.delBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateHighlighted];
        [self addSubview:delBtn];
        
    }
    return self;
}

/**
 *  @brief  创建cell
 *  @param tableView
 *  @return 
 */
+ (id)locationCellWithTaableView:(UITableView *)tableView
{
    static NSString * reuseID = @"location";
    LocationCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[LocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }else{
        [cell removeFromSuperview];
    }
    
    return cell;
}

/**
 *  @brief  显示+1的动画
 */
- (void)showAlertLabel
{
    self.alertLabel.frame = CGRectMake(self.twoButtonView.frame.size.width/2/2 + self.twoButtonView.frame.origin.x, self.twoButtonView.frame.origin.y, 40, 20);
    [UIView animateWithDuration:0.6 animations:^{
        self.alertLabel.hidden = NO;
        self.alertLabel.frame = CGRectMake(self.twoButtonView.frame.size.width/2/2 + self.twoButtonView.frame.origin.x, self.twoButtonView.frame.origin.y - 30, 40, 20);
    } completion:^(BOOL finished) {
        self.alertLabel.hidden = YES;
    }];
    
}
-(void)hideTwoButtonView {
    CGRect rect = self.twoButtonView.frame;
    rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
    rect.size.width = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.twoButtonView.frame = rect;
    } completion:^(BOOL finished) {
        
        self.twoButtonView.hidden = YES;
    }];
}
-(CGSize)onScreenPointSizeOfImageInImageView:(LocationModel *)locationModel{
    CGFloat scale;
    CGFloat width = [locationModel.width floatValue];
    CGFloat height = [locationModel.height floatValue];
    //200是图片最大长,宽
    if (width > height) {
        scale = width / 200;
    } else {
        scale = height / 200;
    }
    return CGSizeMake(width / scale, height / scale);
}

- (NSString *)appendStrWithLocationModel:(LocationModel *)locationmodel
{
    NSString * content = locationmodel.content;
    if (locationmodel.tags == nil || [locationmodel.tags isEqualToString:@""] || locationmodel.tags.length == 0) {
        
    }else{
        NSArray * tempArr = [locationmodel.tags componentsSeparatedByString:@","];
        NSMutableArray * attribuArr = [NSMutableArray array];
        for (NSString * str in tempArr) {
            NSString * tempStr = [NSString stringWithFormat:@"#%@#",str];
            [attribuArr addObject:tempStr];
        }
        NSString * attributedContentStr = @"";
        for (NSString * str in attribuArr) {
            attributedContentStr = [attributedContentStr stringByAppendingFormat:@"%@ ",str];
        }
        content = [attributedContentStr stringByAppendingString:locationmodel.content];
    }
    return content;
}

- (void)setLocationModel:(LocationModel *)locationModel
{
    _locationModel = locationModel;
    
    [locationModel setAttributedStrWith:locationModel.content andFont:[UIFont systemFontOfSize:15]];
    //CGRect rect = [locationModel.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78, 4000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGRect rect = locationModel.contentFrame;
    if (rect.size.height >= DISCREPTIOIN_MAX_HEIGHT) {
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, DISCREPTIOIN_MAX_HEIGHT);
    }
    [self.fullTextBtn setTitle:@"全文" forState:UIControlStateNormal];
    if (_isSpread) {
        rect = locationModel.contentFrame;
        [self.fullTextBtn setTitle:@"收起" forState:UIControlStateNormal];
    }
    CGRect descriptionFram = self.descriptionLabel.frame;
    CGFloat tempY = descriptionFram.origin.y;
//    if ((locationModel.content == nil || [locationModel.content isEqualToString:@""] || locationModel.content.length == 0 )&& (locationModel.tags == nil || [locationModel.tags isEqualToString:@""])) {
//        tempY = 28;
//    }else{
//        tempY = CGRectGetMaxY(self.nameLabel.frame)+8;
//    }
    tempY = CGRectGetMaxY(self.nameLabel.frame)+8;
    descriptionFram.origin.y = tempY;
    descriptionFram.size.height = rect.size.height ;
    self.descriptionLabel.frame = descriptionFram;
    if (locationModel.contentFrame.size.height >= DISCREPTIOIN_MAX_HEIGHT) {
        self.fullTextBtn.y = self.descriptionLabel.y + self.descriptionLabel.height + 5;
        self.fullTextBtn.height = 20;
        self.fullTextBtn.hidden = NO;
    }
    else {
        self.fullTextBtn.y = self.descriptionLabel.y + self.descriptionLabel.height;
        self.fullTextBtn.height = 0;
        self.fullTextBtn.hidden = YES;
    }
    
    self.photoImg1.frame = CGRectMake(self.descriptionLabel.frame.origin.x, CGRectGetMaxY(self.fullTextBtn.frame) + 9, 72, 72);
    self.photoImg2.frame = CGRectMake(self.photoImg1.frame.origin.x + self.photoImg1.frame.size.width + 3, CGRectGetMaxY(self.fullTextBtn.frame) + 9, 72, 72);
    self.photoImg3.frame = CGRectMake(self.photoImg2.frame.origin.x + self.photoImg2.frame.size.width + 3, CGRectGetMaxY(self.fullTextBtn.frame) + 9, 72, 72);
    
    self.photoImg4.frame = CGRectMake(self.descriptionLabel.frame.origin.x, CGRectGetMaxY(self.fullTextBtn.frame) + 9 + 72 + 3, 72, 72);
    self.photoImg5.frame = CGRectMake(self.photoImg4.frame.origin.x + self.photoImg4.frame.size.width + 3, CGRectGetMaxY(self.fullTextBtn.frame) + 9 + 72 + 3, 72, 72);
    self.photoImg6.frame = CGRectMake(self.photoImg5.frame.origin.x + self.photoImg5.frame.size.width + 3, CGRectGetMaxY(self.fullTextBtn.frame) + 9 + 72 + 3, 72, 72);
    
    self.photoImg7.frame = CGRectMake(self.descriptionLabel.frame.origin.x, CGRectGetMaxY(self.photoImg6.frame) + 3, 72, 72);
    self.photoImg8.frame = CGRectMake(CGRectGetMaxX(self.photoImg7.frame) + 3, self.photoImg7.y, 72, 72);
    self.photoImg9.frame = CGRectMake(CGRectGetMaxX(self.photoImg8.frame) + 3, self.photoImg7.y, 72, 72);
    //如果没有图片
    if ([locationModel.photos isEqualToString:@""]) {
        self.photoImg.hidden = YES;
        self.photoImg1.hidden = YES;
        self.photoImg2.hidden = YES;
        self.photoImg3.hidden = YES;
        self.photoImg4.hidden = YES;
        self.photoImg5.hidden = YES;
        self.photoImg6.hidden = YES;
        self.photoImg7.hidden = YES;
        self.photoImg8.hidden = YES;
        self.photoImg9.hidden = YES;
        self.locationImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.fullTextBtn.frame.size.height + self.fullTextBtn.frame.origin.y + 12, 11, 16);
    }else{
        NSArray * photosArr = [locationModel.photos componentsSeparatedByString:@","];
        //图片数量小于3
        if (photosArr.count <= 3) {
            if (photosArr.count == 1) {
                [self.photoImg sd_setImageWithURL:[NSURL URLWithString:photosArr[0]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                
                CGFloat height = 0;
                //计算图片尺寸
                
                if (locationModel.width != nil && ![locationModel.width isEqualToString:@""] && locationModel.height != nil && ![locationModel.height isEqualToString:@""] &&  ![locationModel.width isEqualToString:@"0"] && ![locationModel.height isEqualToString:@"0"]) {
                    CGSize imageSize = [self onScreenPointSizeOfImageInImageView:locationModel];
                    CGRect imageViewRect = self.photoImg.frame;
                    imageViewRect.origin.y = CGRectGetMaxY(self.fullTextBtn.frame) + 9;
                    imageViewRect.size = imageSize;
                    self.photoImg.frame = imageViewRect;
                    height = imageSize.height;
                    
                }else{
                    self.photoImg.contentMode = UIViewContentModeScaleAspectFill;
                    self.photoImg.clipsToBounds = YES;
                    self.photoImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, CGRectGetMaxY(self.fullTextBtn.frame) + 9, 200, 200);
                    height = 200;
                }
                self.locationImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, CGRectGetMaxY(self.fullTextBtn.frame) + height + 9 +12, 11, 16);
                
                self.photoImg.hidden = NO;
                self.photoImg1.hidden = YES;
                self.photoImg2.hidden = YES;
                self.photoImg3.hidden = YES;
                self.photoImg4.hidden = YES;
                self.photoImg5.hidden = YES;
                self.photoImg6.hidden = YES;
                self.photoImg7.hidden = YES;
                self.photoImg8.hidden = YES;
                self.photoImg9.hidden = YES;
            }else if (photosArr.count == 2) {
                self.photoImg.hidden = YES;
                self.photoImg1.hidden = NO;
                self.photoImg2.hidden = NO;
                self.photoImg3.hidden = YES;
                self.photoImg4.hidden = YES;
                self.photoImg5.hidden = YES;
                self.photoImg6.hidden = YES;
                self.photoImg7.hidden = YES;
                self.photoImg8.hidden = YES;
                self.photoImg9.hidden = YES;
            [self.photoImg1 sd_setImageWithURL:[NSURL URLWithString:photosArr[0]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg1.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg1.clipsToBounds = YES;
            [self.photoImg2 sd_setImageWithURL:[NSURL URLWithString:photosArr[1]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg2.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg2.clipsToBounds = YES;

            }else if (photosArr.count == 3) {
                [self.photoImg3 sd_setImageWithURL:[NSURL URLWithString:photosArr[2]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg3.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg3.clipsToBounds = YES;
                [self.photoImg2 sd_setImageWithURL:[NSURL URLWithString:photosArr[1]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg2.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg2.clipsToBounds = YES;
                [self.photoImg1 sd_setImageWithURL:[NSURL URLWithString:photosArr[0]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg1.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg1.clipsToBounds = YES;
                self.photoImg.hidden = YES;
                self.photoImg1.hidden = NO;
                self.photoImg2.hidden = NO;
                self.photoImg3.hidden = NO;
                self.photoImg4.hidden = YES;
                self.photoImg5.hidden = YES;
                self.photoImg6.hidden = YES;
                self.photoImg7.hidden = YES;
                self.photoImg8.hidden = YES;
                self.photoImg9.hidden = YES;
            }
            if (photosArr.count == 1) {
                
            }else{
                self.locationImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, CGRectGetMaxY(self.fullTextBtn.frame) + 72 + 9 + 12, 11, 16);
            }
        }else{
            self.photoImg.hidden = YES;
            self.photoImg1.hidden = NO;
            self.photoImg2.hidden = NO;
            self.photoImg3.hidden = NO;
            [self.photoImg3 sd_setImageWithURL:[NSURL URLWithString:photosArr[2]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.photoImg3.contentMode = UIViewContentModeScaleAspectFill;
            self.photoImg3.clipsToBounds = YES;
            [self.photoImg2 sd_setImageWithURL:[NSURL URLWithString:photosArr[1]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.photoImg2.contentMode = UIViewContentModeScaleAspectFill;
            self.photoImg2.clipsToBounds = YES;
            [self.photoImg1 sd_setImageWithURL:[NSURL URLWithString:photosArr[0]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.photoImg1.contentMode = UIViewContentModeScaleAspectFill;
            self.photoImg1.clipsToBounds = YES;
            if (photosArr.count == 4) {
                [self.photoImg4 sd_setImageWithURL:[NSURL URLWithString:photosArr[3]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg4.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg4.clipsToBounds = YES;
                self.photoImg.hidden = YES;
                self.photoImg4.hidden = NO;
                self.photoImg5.hidden = YES;
                self.photoImg6.hidden = YES;
                self.photoImg7.hidden = YES;
                self.photoImg8.hidden = YES;
                self.photoImg9.hidden = YES;
            }else if (photosArr.count == 5) {
                [self.photoImg4 sd_setImageWithURL:[NSURL URLWithString:photosArr[3]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg4.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg4.clipsToBounds = YES;
                [self.photoImg5 sd_setImageWithURL:[NSURL URLWithString:photosArr[4]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg5.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg5.clipsToBounds = YES;
                self.photoImg.hidden = YES;
                self.photoImg4.hidden = NO;
                self.photoImg5.hidden = NO;
                self.photoImg6.hidden = YES;
                self.photoImg7.hidden = YES;
                self.photoImg8.hidden = YES;
                self.photoImg9.hidden = YES;
            }else if (photosArr.count == 6) {
                [self.photoImg4 sd_setImageWithURL:[NSURL URLWithString:photosArr[3]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg4.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg4.clipsToBounds = YES;
                [self.photoImg5 sd_setImageWithURL:[NSURL URLWithString:photosArr[4]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg5.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg5.clipsToBounds = YES;
                [self.photoImg6 sd_setImageWithURL:[NSURL URLWithString:photosArr[5]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg6.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg6.clipsToBounds = YES;
                self.photoImg.hidden = YES;
                self.photoImg4.hidden = NO;
                self.photoImg5.hidden = NO;
                self.photoImg6.hidden = NO;
                self.photoImg7.hidden = YES;
                self.photoImg8.hidden = YES;
                self.photoImg9.hidden = YES;
            }else if (photosArr.count == 7) {
            [self.photoImg4 sd_setImageWithURL:[NSURL URLWithString:photosArr[3]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.photoImg4.contentMode = UIViewContentModeScaleAspectFill;
            self.photoImg4.clipsToBounds = YES;
            [self.photoImg5 sd_setImageWithURL:[NSURL URLWithString:photosArr[4]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.photoImg5.contentMode = UIViewContentModeScaleAspectFill;
            self.photoImg5.clipsToBounds = YES;
            [self.photoImg6 sd_setImageWithURL:[NSURL URLWithString:photosArr[5]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.photoImg6.contentMode = UIViewContentModeScaleAspectFill;
            self.photoImg6.clipsToBounds = YES;
            [self.photoImg7 sd_setImageWithURL:[NSURL URLWithString:photosArr[6]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.photoImg7.contentMode = UIViewContentModeScaleAspectFill;
            self.photoImg7.clipsToBounds = YES;
            self.photoImg.hidden = YES;
            self.photoImg4.hidden = NO;
            self.photoImg5.hidden = NO;
            self.photoImg6.hidden = NO;
            self.photoImg7.hidden = NO;
            self.photoImg8.hidden = YES;
            self.photoImg9.hidden = YES;
            }else if (photosArr.count == 8) {
                [self.photoImg4 sd_setImageWithURL:[NSURL URLWithString:photosArr[3]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg4.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg4.clipsToBounds = YES;
                [self.photoImg5 sd_setImageWithURL:[NSURL URLWithString:photosArr[4]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg5.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg5.clipsToBounds = YES;
                [self.photoImg6 sd_setImageWithURL:[NSURL URLWithString:photosArr[5]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg6.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg6.clipsToBounds = YES;
                [self.photoImg7 sd_setImageWithURL:[NSURL URLWithString:photosArr[6]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg7.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg7.clipsToBounds = YES;
                [self.photoImg8 sd_setImageWithURL:[NSURL URLWithString:photosArr[7]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg8.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg8.clipsToBounds = YES;
                
                self.photoImg.hidden = YES;
                self.photoImg4.hidden = NO;
                self.photoImg5.hidden = NO;
                self.photoImg6.hidden = NO;
                self.photoImg7.hidden = NO;
                self.photoImg8.hidden = NO;
                self.photoImg9.hidden = YES;
            }else if (photosArr.count == 9) {
                [self.photoImg4 sd_setImageWithURL:[NSURL URLWithString:photosArr[3]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg4.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg4.clipsToBounds = YES;
                [self.photoImg5 sd_setImageWithURL:[NSURL URLWithString:photosArr[4]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg5.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg5.clipsToBounds = YES;
                [self.photoImg6 sd_setImageWithURL:[NSURL URLWithString:photosArr[5]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg6.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg6.clipsToBounds = YES;
                [self.photoImg7 sd_setImageWithURL:[NSURL URLWithString:photosArr[6]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg7.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg7.clipsToBounds = YES;
                [self.photoImg8 sd_setImageWithURL:[NSURL URLWithString:photosArr[7]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg8.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg8.clipsToBounds = YES;
                [self.photoImg9 sd_setImageWithURL:[NSURL URLWithString:photosArr[8]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                self.photoImg9.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImg9.clipsToBounds = YES;
                
                self.photoImg.hidden = YES;
                self.photoImg4.hidden = NO;
                self.photoImg5.hidden = NO;
                self.photoImg6.hidden = NO;
                self.photoImg7.hidden = NO;
                self.photoImg8.hidden = NO;
                self.photoImg9.hidden = NO;
            }
            self.locationImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, CGRectGetMaxY(self.fullTextBtn.frame) + 9 + 3 + 72 * (photosArr.count % 3 == 0 ? photosArr.count/3 : photosArr.count/3 + 1) + 12, 11, 16);
            
        }
    }
    
    //移除评论内容所在view内容,防止重用
    NSMutableArray * commentArr = locationModel.comments;
    for (UIView * view in self.zanNumBgView.subviews) {
        if ([view isKindOfClass:[MyCommentView class]]) {
            [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [view removeFromSuperview];
        }
    }
    //移除点赞的人所在view内容,防止重用
    NSArray * likesArr = locationModel.likes;
    for (UIView * view in self.tempViewForZanPerson.subviews) {
        [view removeFromSuperview];
    }
    
    int j = 0;
    int tempWidth = 0;
    if (locationModel.likes != nil && locationModel.likes.count != 0) {
        self.tempViewForZanPerson.hidden = NO;
        for (int i = 0; i < locationModel.likes.count + 1; i++) {
            @autoreleasepool {
                NSDictionary * tempDic;
                CommentNameView * nameView = [[CommentNameView alloc]initWithFrame:CGRectMake(15, 7.5, 30, 15)];
                nameView.nameLabel.font = [UIFont systemFontOfSize:13];
                NSString * nameStr;
                if (i <= locationModel.likes.count - 1) {
                    tempDic = likesArr[i];
                    nameView.nameLabel.text = [NSString stringWithFormat:@"%@,",[tempDic objectForKey:@"nickname"]];
                    UITapGestureRecognizer * zanNameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zanNameTap:)];
                    [nameView addGestureRecognizer:zanNameTap];
                    nameStr = [NSString stringWithFormat:@"%@,",[tempDic objectForKey:@"nickname"]];
                }else{
                    nameStr = @" 觉得很赞";
                    nameView.nameLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
                    nameView.nameLabel.text = @" 觉得很赞";
                }
                
                if (i == locationModel.likes.count - 1) {
                    nameView.nameLabel.text = [nameView.nameLabel.text substringToIndex:nameView.nameLabel.text.length - 1];
                }
                
                nameView.tag = 8000+i;
                [nameView.nameLabel sizeToFit];
                if (i == 0) {
                    nameView.frame = CGRectMake(15, 7.5 + j * 15, nameView.nameLabel.frame.size.width, 15);
                }else{
                    nameView.frame = CGRectMake(15 + tempWidth, 7.5 + j * 15, nameView.nameLabel.frame.size.width, 15);
                }
                
                CGSize tempSize = [nameStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                
                tempWidth += tempSize.width;

                if (tempWidth > (SCREEN_WIDTH - 78 - 20))
                {
                    j += 1;
                    tempWidth = 0;
                    nameView.frame = CGRectMake(15 + tempWidth, 7.5 + j * 15, nameView.nameLabel.frame.size.width, 15);
                    tempWidth += nameView.nameLabel.frame.size.width;
                }
                
                [self.tempViewForZanPerson addSubview:nameView];
            }
        }
        self.tempViewForZanPerson.frame = CGRectMake(0, 0, SCREEN_WIDTH - 78, (j+1) * 15 + 15);
        self.zanLineView.frame = CGRectMake(0, self.tempViewForZanPerson.frame.size.height + self.tempViewForZanPerson.frame.origin.y, SCREEN_WIDTH - 78, 1);
    }else{
        self.tempViewForZanPerson.hidden = YES;
        self.zanLineView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 78, 0);
    }
    
    float height = 0.0;
    if (locationModel.comments != nil && locationModel.comments.count != 0 )
    {
        for (int i = 0; i < locationModel.comments.count; i++) {
            @autoreleasepool {
                
                NSDictionary * tempDic = commentArr[i];

                MyCommentView * tempView = [[MyCommentView alloc]init];
                tempView.tag = 5000 + i;
                
                UITapGestureRecognizer * commentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentTap:)];
                //commentTap.delaysTouchesBegan = YES;
                commentTap.delegate = self;
                [tempView addGestureRecognizer:commentTap];
                
                NameTextView * commentTextView = [[NameTextView alloc]init];
                commentTextView.backgroundColor = [UIColor clearColor];
                commentTextView.userInteractionEnabled = YES;
                commentTextView.font = SIZE_FOR_14;
                commentTextView.textColor = [GetColor16 hexStringToColor:@"#434343"];
                commentTextView.clickHandler = ^(NameTextView * nameTextView,NSString * nameStr,NSString * nameNum){
                    if ([nameNum isEqualToString:@"1"]) {
                        [self.delegate tapName1:self index:tempView.tag - 5000];
                    }else if([nameNum isEqualToString:@"2"]){
                        [self.delegate tapName2:self index:tempView.tag - 5000];
                    }
                    
                };
                [tempView addSubview:commentTextView];
                
                NSDictionary * fromuserDic = [tempDic objectForKey:@"fromuser"];
                NSDictionary * toUserDic = [tempDic objectForKey:@"touser"];
                NSString * commentStr;
                if (toUserDic == nil) {
                    commentStr = [NSString stringWithFormat:@"&%@&：%@",[fromuserDic objectForKey:@"nickname"],[tempDic objectForKey:@"comment_content"]];
                }else{
                    commentStr = [NSString stringWithFormat:@"&%@& %@ &%@&：%@",[fromuserDic objectForKey:@"nickname"],@"回复",[toUserDic objectForKey:@"nickname"],[tempDic objectForKey:@"comment_content"]];
                }
                [locationModel setNameAttributedStrWith:commentStr andFont:SIZE_FOR_14];
                commentTextView.attributedText = locationModel.nameAttributedText;
                
                CGRect tempRects = [locationModel.nameAttributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78 - 30, 50000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                
                if (i == 0) {
                    tempView.frame = CGRectMake(15, CGRectGetMaxY(self.zanLineView.frame), SCREEN_WIDTH - 78 - 30, tempRects.size.height + 6);
                }else{
                    tempView.frame = CGRectMake(15, CGRectGetMaxY(self.zanLineView.frame) + height, SCREEN_WIDTH - 78 - 30, tempRects.size.height + 6);
                }
                
                commentTextView.frame = CGRectMake(0, 3, SCREEN_WIDTH - 78 - 30, 17);
                
                height += tempRects.size.height + 6;
                
                CGRect contentRect = commentTextView.frame;
                contentRect.size.height = tempRects.size.height;
                commentTextView.frame = contentRect;
                
                [tempView addSubview:commentTextView];
                [self.zanNumBgView addSubview:tempView];
            }
        }
    }
    
    
    NSString * timeStr = [CompareCurrentTime compareCurrentTime:locationModel.updatetimeLong];
    self.timeLabel.text = timeStr;
    
    
    
    self.addressLabel.text = locationModel.title;
    if ([locationModel.title isEqualToString:@""] || locationModel.title == nil || locationModel.title.length == 0) {
        self.locationImg.hidden = YES;
    }else{
        self.locationImg.hidden = NO;
    }
    
    self.moreBtn.frame = CGRectMake(SCREEN_WIDTH - 40 - 15, self.locationImg.frame.origin.y - 15, 55, 45);
    self.addressLabel.frame = CGRectMake(self.locationImg.frame.origin.x + self.locationImg.frame.size.width + 4, self.locationImg.frame.origin.y - 1, SCREEN_WIDTH - self.locationImg.frame.size.width - self.locationImg.frame.origin.x - 15 - self.moreBtn.frame.size.width - 5, 30);
    
    self.sanjiaoImg.frame = CGRectMake(self.locationImg.frame.size.width + self.locationImg.frame.origin.x - 4, self.locationImg.frame.origin.y + self.locationImg.frame.size.height + 7.5, 17, 7);
    if (likesArr.count == 0 || likesArr == nil) {
        self.zanNumBgView.frame = CGRectMake(self.locationImg.frame.origin.x, CGRectGetMaxY(self.sanjiaoImg.frame), SCREEN_WIDTH - 78, 44 + height);
    }else{
        self.zanNumBgView.frame = CGRectMake(self.locationImg.frame.origin.x, CGRectGetMaxY(self.sanjiaoImg.frame), SCREEN_WIDTH - 78, 44 + height + (j + 1) * 15 + 15);
    }
    
    self.commentBGView.frame = CGRectMake(15, self.zanLineView.frame.size.height + self.zanLineView.frame.origin.y + height + 12, self.zanNumBgView.frame.size.width - 30, 20);

    self.delBtn.frame = CGRectMake(self.zanNumBgView.frame.origin.x, CGRectGetMaxY(self.zanNumBgView.frame) + 12, 35, 16);
    
    self.twoButtonView.frame = CGRectMake(SCREEN_WIDTH - 15 - 25 - 10, self.moreBtn.frame.origin.y + 8, 0, 30);
    
    self.zanBtn.frame = CGRectMake(0, 0, 75, 30);
    if ([locationModel.isLike isEqualToString:@"1"]) {
        [self.zanBtn setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        [self.zanBtn setTitle:@"  赞" forState:UIControlStateNormal];
    }
    self.lineView.frame = CGRectMake(self.zanBtn.frame.origin.x + self.zanBtn.frame.size.width, self.zanBtn.frame.origin.y + 5, 1, 20);
    self.shareBtn.frame = CGRectMake(self.lineView.frame.origin.x + self.lineView.frame.size.width, 0, 75, 30);

//    self.numPerLabel.frame = CGRectMake(15, 9, self.zanNumBgView.frame.size.width, 12);
//    self.zanLineView.frame = CGRectMake(0, self.numPerLabel.frame.size.height + self.numPerLabel.frame.origin.y + 5, self.zanNumBgView.frame.size.width, 1);
    
    self.numPerLabel.text = [NSString stringWithFormat:@"%@人觉得很赞",locationModel.likeCount];
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:locationModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImg.clipsToBounds = YES;
    self.nameLabel.text = locationModel.nickname;
    self.descriptionLabel.attributedText = locationModel.attributedText;
    
    if ([locationModel.account isEqualToString:ACCOUNT_SELF]) {
        self.delBtn.hidden = NO;
    }else{
        self.delBtn.hidden = YES;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    Singleton * singleton = [Singleton sharedInstance];
    if (!singleton.pinglunTap) {
        return NO;
    }
    return YES;
}

/**
 *  @brief  点赞的人详情
 *  @param tap
 */
- (void)zanNameTap:(UITapGestureRecognizer *)tap
{
    CommentNameView * tempZanName = (CommentNameView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(tapZanName:index:)]) {
        [self.delegate tapZanName:self index:tempZanName.tag - 8000];
    }
}

/**
 *  @brief  点击评论内容
 *  @param tap
 */
- (void)commentTap:(UITapGestureRecognizer *)tap
{
    MyCommentView * tempComment = (MyCommentView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(tapComment:index:withTap:)]) {
        Singleton * singleton = [Singleton sharedInstance];
        singleton.pinglunTap = NO;
        [self.delegate tapComment:self index:tempComment.tag - 5000 withTap:tap];
    }
}

@end
