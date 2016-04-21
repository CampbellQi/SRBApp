//
//  ZZLeftVCTableCell.m
//  SRBApp
//
//  Created by zxk on 14/12/17.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZLeftVCTableCell.h"

@implementation ZZLeftVCTableCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(45, 20, 25, 25)];
        imgview.backgroundColor = [UIColor orangeColor];
        [self addSubview:imgview];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(imgview.frame.size.width + imgview.frame.origin.x + 21, 13, 100, 15)];
        label.text = @"我的担保";
        [self addSubview:label];
    }
    return self;
}
+ (id)settingCellWithTaableView:(UITableView *)tableView
{
    static NSString * ID = @"LeftCell";
    ZZLeftVCTableCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZZLeftVCTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
-(void)setLeftModel:(ZZLeftVCModel *)leftModel
{
    _leftModel = leftModel;
    
}

@end
