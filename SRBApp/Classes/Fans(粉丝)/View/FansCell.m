//
//  FansCell.m
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "FansCell.h"

@implementation FansCell

- (void)setFansModel:(FansModel *)fansModel
{
    _fansModel = fansModel;
    NSLog(@"%@-%@",fansModel.nickname,fansModel.sign);
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:fansModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImg.clipsToBounds = YES;
    self.nameLabel.text = fansModel.nickname;
    self.descriptionLabel.text = fansModel.sign;
}
+ (id)fansCellWithTaableView:(UITableView *)tableView
{
    static NSString * reuseID = @"impression";
    FansCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[FansCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
