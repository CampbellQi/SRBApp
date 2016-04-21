//
//  SquareCell.m
//  hh
//
//  Created by zxk on 14/12/28.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "SquareCell.h"
#import <UIImageView+WebCache.h>



@implementation SquareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        
        UIView * colorImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9.5, 3, 21)];
        self.colorImg = colorImg;
        [self addSubview:colorImg];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(38, 12, 120, 16)];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        ZZGoPayBtn * moreBtn = [ZZGoPayBtn buttonWithType:UIButtonTypeRoundedRect];
        moreBtn.frame = CGRectMake(SCREEN_WIDTH - 40 - 15, 14, 40, 12);
        [moreBtn setTitle:@"更多>" forState:UIControlStateNormal];
        moreBtn.titleLabel.font = SIZE_FOR_12;
        [moreBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
        self.moreBtn = moreBtn;
        [self addSubview:moreBtn];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 41,SCREEN_WIDTH , 1)];
        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:lineView];
        
        UIScrollView * mainScrollview = [[UIScrollView alloc]init];
        mainScrollview.frame = CGRectMake(15, 57, SCREEN_WIDTH-30, 185);
        self.mainScrollvew = mainScrollview;
        mainScrollview.userInteractionEnabled = YES;
        [self addSubview:mainScrollview];
    }
    return self;
}

+ (id)squareCellWithTableView:(UITableView *)tableView
{
    static NSString * reuseID = @"square";
    SquareCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[SquareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

//没有重用
+ (id)squareCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseID = @"square";
    SquareCell * cell = (SquareCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SquareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)jumpTap:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(jumpToDetail:)]) {
        [self.delegate jumpToDetail:tap.view.tag];
    }
}

- (void)setGroupModel:(GroupModel *)groupModel
{
    _groupModel = groupModel;
    self.colorImg.backgroundColor = [GetColor16 hexStringToColor:groupModel.color];
    self.titleLabel.text = groupModel.categoryName;

    self.moreBtn.hidden = NO;
    NSArray * detailArr = groupModel.post;
    self.mainScrollvew.contentSize = CGSizeMake(130*detailArr.count, 182);
    for (int i = 0; i < detailArr.count; i++) {
        @autoreleasepool {
            NSDictionary * tempdic = detailArr[i];
            SquareScrollInfoView * squareScrollView = [[SquareScrollInfoView alloc]initWithFrame:CGRectMake(i * 130, 0, 122, 182)];
            squareScrollView.userInteractionEnabled = YES;
            self.squareScrollView = squareScrollView;
            squareScrollView.tag = [[tempdic objectForKey:@"id"] integerValue];
            [squareScrollView.goodsImg sd_setImageWithURL:[NSURL URLWithString:[tempdic objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            squareScrollView.goodsImg.contentMode = UIViewContentModeScaleAspectFill;
            squareScrollView.goodsImg.clipsToBounds = YES;
            squareScrollView.titleLabel.text = [tempdic objectForKey:@"title"];
            if ([[tempdic objectForKey:@"dealType"] isEqualToString:@"2"]) {
                squareScrollView.priceLabel.hidden = YES;
            }else{
                squareScrollView.priceLabel.hidden = NO;
                squareScrollView.priceLabel.text = [NSString stringWithFormat:@"¥ %@",[tempdic objectForKey:@"bangPrice"]];
            }
            UITapGestureRecognizer * jumpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpTap:)];
            [squareScrollView addGestureRecognizer:jumpTap];
            [self.mainScrollvew addSubview:squareScrollView];
        }
    }
}

@end
