//
//  PhotoCollectionViewCell.m
//  ChineseMusician
//
//  Created by 刘若曈 on 14/11/21.
//  Copyright (c) 2014年 刘若曈. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
        [self.contentView addSubview:_imageView];
    }
    return self;
}
@end
