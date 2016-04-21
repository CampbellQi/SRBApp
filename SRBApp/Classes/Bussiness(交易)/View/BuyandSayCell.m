//
//  BuyandSayCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/4/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "BuyandSayCell.h"
#import "MarkModel.h"

@implementation BuyandSayCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImage = [[MyImgView alloc]initWithFrame:CGRectMake(15, 5, 30, 30)];
        _headImage.userInteractionEnabled = YES;
        _headImage.backgroundColor = [UIColor clearColor];
        _headImage.layer.cornerRadius = 15;
        _headImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImage.frame.origin.x + +_headImage.frame.size.width + 10, 5, SCREEN_WIDTH - 80, 16)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
        [self.contentView addSubview:_titleLabel];
        
        //评分
        _goodComment = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 5, 90, 16)];
        _goodComment.font = SIZE_FOR_12;
        _goodComment.hidden = NO;
        _goodComment.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [self.contentView addSubview:_goodComment];
        
        //评分图片
        _commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(_goodComment.frame.size.width + _goodComment.frame.origin.x + 8, _goodComment.frame.origin.y + 2, 12,12)];
        _commentImg.hidden = NO;
        [self.contentView addSubview:_commentImg];
        
        _sayLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x,_goodComment.frame.origin.y + _goodComment.frame.size.height + 2, SCREEN_WIDTH - 80, 14)];
        [_sayLabel setTextColor:[GetColor16 hexStringToColor:@"#959595"] ];
        _sayLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_sayLabel];
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 170, _titleLabel.frame.origin.y, 155, 12)];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [self.contentView addSubview:_dateLabel];
        
        /** 配图 */
        WQOneToSixPhotosView *photosView = [[WQOneToSixPhotosView alloc] init];
        [self.contentView addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}

////赋值 and 自动换行,计算出cell的高度
//-(void)setIntroductionText:(NSString*)text{
//    //获得当前cell高度
//    CGRect frame = [self frame];
//    //文本赋值
//    self.sayLabel.text = text;
//    //设置label的最大行数
//    self.sayLabel.numberOfLines = 0;
//    CGSize size = CGSizeMake(SCREEN_WIDTH - _titleLabel.frame.origin.x - 15, 1000);
//    CGSize labelSize = [self.sayLabel.text sizeWithFont:self.sayLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
//    self.sayLabel.frame = CGRectMake(self.sayLabel.frame.origin.x, self.sayLabel.frame.origin.y, labelSize.width, labelSize.height);
//    
//    //计算出自适应的高度
//    frame.size.height = labelSize.height + _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 20 + 26;
//    
//    self.frame = frame;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

-(void)setCellFrame:(BuyandSayCellFrame *)cellFrame {
    MarkModel *markModel = cellFrame.markModel;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[markModel avatar]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headImage.clipsToBounds = YES;
    self.titleLabel.text =[markModel nickname];
    
    if ([[markModel grade] isEqualToString:@"1"]) {
        self.commentImg.image = [UIImage imageNamed:@"s_good"];
        self.goodComment.text = @"综合评分：好评";
    }else if([[markModel grade] isEqualToString:@"0"]){
        self.commentImg.image = [UIImage imageNamed:@"s_middle"];
        self.goodComment.text = @"综合评分：中评";
    }else if([[markModel grade] isEqualToString:@"-1"]){
        self.commentImg.image = [UIImage imageNamed:@"s_negative"];
        self.goodComment.text = @"综合评分：差评";
    }else
    {
        self.commentImg.image = [UIImage imageNamed:@"s_fake"];
        self.goodComment.text = @"综合评分：假货";
    }
    //[self setIntroductionText:[markModel content]];
    self.sayLabel.text = [markModel content];
    self.dateLabel.text = [markModel updatetime];
    /** 配图 */
    if (markModel.photos.length != 0) {
        self.photosView.photos = [markModel.photos componentsSeparatedByString:@","];
    }
    
    
    self.headImage.frame = cellFrame.headImageF;
    self.titleLabel.frame = cellFrame.titleLabelF;
    self.commentImg.frame = cellFrame.commentImgF;
    self.goodComment.frame = cellFrame.goodCommentF;
    self.dateLabel.frame = cellFrame.dateLabelF;
    self.photosView.frame = cellFrame.photosViewF;
    self.sayLabel.frame = cellFrame.sayLabelF;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
