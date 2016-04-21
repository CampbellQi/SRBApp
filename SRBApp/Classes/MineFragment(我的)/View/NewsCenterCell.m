//
//  NewsCenterCell.m
//  SRBApp
//
//  Created by zxk on 15/3/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NewsCenterCell.h"
#import "ReplaceEmotionTool.h"

@implementation NewsCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        MyImgView * stateImgView = [[MyImgView alloc]init];
        self.stateImgView = stateImgView;
        [self addSubview:stateImgView];
        
        MyImgView * isNewImgView = [[MyImgView alloc]init];
        self.isNewImgView = isNewImgView;
        isNewImgView.image = [UIImage imageNamed:@"newfriend_notic"];
        [self addSubview:isNewImgView];
        
        MyLabel * titleLabel = [[MyLabel alloc]init];
        titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        titleLabel.font = SIZE_FOR_14;
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        titleLabel.numberOfLines = 0;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        MyLabel * contentLabel = [[MyLabel alloc]init];
        contentLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        contentLabel.font = SIZE_FOR_14;
        contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        contentLabel.numberOfLines = 0;
        self.contentLabel = contentLabel;
        [self addSubview:contentLabel];
        
        MyLabel * timeLabel = [[MyLabel alloc]init];
        timeLabel.font = SIZE_FOR_12;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        
        MyLabel * detailLabel = [[MyLabel alloc]init];
        detailLabel.font = SIZE_FOR_12;
        detailLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.detailLabel = detailLabel;
        detailLabel.text = @"查看详情>";
        //[self addSubview:detailLabel];
        
        self.stateImgView.frame = CGRectMake(15, 10, 30, 16);
        self.isNewImgView.frame = CGRectMake(11, 6, 7, 7);
        self.titleLabel.frame = CGRectMake(self.stateImgView.frame.size.width + self.stateImgView.frame.origin.x + 5, 10, SCREEN_WIDTH - 30 - 30 - 5, 17);
        self.contentLabel.frame = CGRectMake(15, self.stateImgView.frame.size.height + self.stateImgView.frame.origin.y + 7, SCREEN_WIDTH - 30, 17);
        self.timeLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - 150, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y + 5, 150, 14);
//        self.detailLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, self.timeLabel.frame.origin.y, 60, 14);
    }
    return self;
}

/**
 *  @brief  创建cell
 *  @param tableView
 *  @return 返回cell
 */
+ (id)newsCenterCellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"newsCenter";
    NewsCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NewsCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
}

- (void)setNewsCenterModel:(NewsCenterModel *)newsCenterModel
{
    _newsCenterModel = newsCenterModel;
    
    NSAttributedString * attributedString = [ReplaceEmotionTool enumerateStringWithStr:newsCenterModel.content andFont:SIZE_FOR_14];
    
    CGRect tempRect = [attributedString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 65, 4000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    CGRect tempRect = [newsCenterModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 - 30 - 5, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];

//    self.contentLabel.frame = CGRectMake(15, self.stateImgView.frame.size.height + self.stateImgView.frame.origin.y + 7, SCREEN_WIDTH - 30, tempRect.size.height);
    self.titleLabel.frame = CGRectMake(self.stateImgView.frame.size.width + self.stateImgView.frame.origin.x + 5, 10, SCREEN_WIDTH - 30 - 30 - 5, tempRect.size.height);
    self.timeLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - 150, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y + 5, 150, 14);
//    self.detailLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, self.timeLabel.frame.origin.y, 60, 14);
    
    
    if ([newsCenterModel.module isEqualToString:@"sellerorder"] || [newsCenterModel.module isEqualToString:@"buyerorder"]) {
        //订单
        self.stateImgView.image = [UIImage imageNamed:@"notice_dingdan"];
    }else if ([newsCenterModel.module isEqualToString:@"userapply"] || [newsCenterModel.module isEqualToString:@"userfriend"] || [newsCenterModel.module isEqualToString:@"userinfo"]){
        //熟人
        self.stateImgView.image = [UIImage imageNamed:@"notice_shuren"];
    }else if ([newsCenterModel.module isEqualToString:@"postguarantee"] || [newsCenterModel.module isEqualToString:@"userguarantee"]){
        //担保
        self.stateImgView.image = [UIImage imageNamed:@"notice_guarantee"];
    }else if ([newsCenterModel.module isEqualToString:@"sellercomment"] || [newsCenterModel.module isEqualToString:@"buyercomment"]){
        //评价
        self.stateImgView.image = [UIImage imageNamed:@"notice_pingjia"];
    }else if ([newsCenterModel.module isEqualToString:@"userpost"]){
        //商品详情里的
        self.stateImgView.image = [UIImage imageNamed:@"notice_xianhuo"];
    }else if ([newsCenterModel.module isEqualToString:@"userposition"]){
        //足迹
        self.stateImgView.image = [UIImage imageNamed:@"notice_zuji"];
    }else if ([newsCenterModel.module isEqualToString:@"inviteguarantee"]){
        //邀请担保
        self.stateImgView.image = [UIImage imageNamed:@"notice_yaoqing"];
    }else if ([newsCenterModel.module isEqualToString:@"usertopic"] || [newsCenterModel.module isEqualToString:@"usertopiccomment"]){
        //话题
        self.stateImgView.image = [UIImage imageNamed:@"notice_huati"];
    }else if ([newsCenterModel.module isEqualToString:@"taskorder"]){
        //订单详情
        self.stateImgView.image = [UIImage imageNamed:@"notice_dingdan"];
    }else if ([newsCenterModel.module isEqualToString:@"buyertask"]){
        //求购单
        self.stateImgView.image = [UIImage imageNamed:@"notice_qiugou"];
    }else if ([newsCenterModel.module isEqualToString:@"sellertask"]){
        //代购单
        self.stateImgView.image = [UIImage imageNamed:@"notice_daigou"];
    }else{
        self.stateImgView.image = [UIImage imageNamed:@"notice_xitong"];
    }
    
    if ([newsCenterModel.isNew isEqualToString:@"1"]) {
        self.isNewImgView.hidden = NO;
    }else{
        self.isNewImgView.hidden = YES;
    }
    
    self.titleLabel.attributedText = attributedString;
//    //日期格式化
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate * date = [dateFormatter dateFromString:_model.updatetime];
//    [dateFormatter setDateFormat:@"MM-dd"];
//    NSString * str = [dateFormatter stringFromDate:date];
    self.timeLabel.text = newsCenterModel.updatetime;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
