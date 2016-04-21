//
//  NearbyLocationVCell.m
//  SRBApp
//
//  Created by lizhen on 15/3/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NearbyLocationVCell.h"

@implementation NearbyLocationVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 11, 15)];
        self.locationImage.image = [UIImage imageNamed:@"locationadd_icon"];
        [self.contentView addSubview:self.locationImage];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, SCREEN_WIDTH - self.locationImage.frame.origin.x - self.locationImage.frame.size.width - 9, 18)];
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        self.titleLable.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.titleLable.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLable];
        
        self.addressLable = [[UILabel alloc]initWithFrame:CGRectMake(35, self.locationImage.frame.origin.x + self.locationImage.frame.size.width + 9, SCREEN_WIDTH - self.locationImage.frame.origin.x - self.locationImage.frame.size.width - 9, 14)];
        self.addressLable.numberOfLines = 0;
        self.addressLable.lineBreakMode = NSLineBreakByWordWrapping;
        self.addressLable.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.addressLable.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.addressLable];
        
    }
    return self;
}

- (void)setModel:(TencentMapModel *)model
{
    _model = model;
    self.titleLable.text = model.title;
    self.addressLable.text = model.address;
}

@end
