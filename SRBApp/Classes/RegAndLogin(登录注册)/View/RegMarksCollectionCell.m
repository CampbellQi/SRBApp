//
//  SRBRegMarksCollectionCell.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/6.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "RegMarksCollectionCell.h"

@implementation RegMarksCollectionCell

- (void)awakeFromNib {
    // Initialization code
    self.coverIV.layer.masksToBounds = YES;
    self.coverIV.layer.cornerRadius = 5.0f;
    
    self.selectIV.layer.masksToBounds = YES;
    self.selectIV.layer.cornerRadius = 5.0f;
}

-(void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:dataDict[@"pic"]] placeholderImage:[UIImage imageNamed:@"login_mark_img_default"]];
    self.nameLbl.text = dataDict[@"name"];
}
@end
