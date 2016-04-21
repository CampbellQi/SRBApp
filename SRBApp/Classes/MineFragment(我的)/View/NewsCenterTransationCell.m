//
//  NewsCenterTransationCell.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/26.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "NewsCenterTransationCell.h"

@implementation NewsCenterTransationCell

- (void)awakeFromNib {
    // Initialization code
    self.contentSuperView.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSourceDict:(NSDictionary *)sourceDict {
    _sourceDict = sourceDict;
    
    NSDictionary *orderDict = _sourceDict[@"order"];
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:orderDict[@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image.size.height > image.size.width) {
            self.coverIV.contentMode = UIViewContentModeScaleToFill;
        }else{
            self.coverIV.contentMode = UIViewContentModeScaleAspectFit;
        }
    }];
    [self.kindIV sd_setImageWithURL:[NSURL URLWithString:orderDict[@"taskRoleIcon"]]];
    self.brandLbl.text = orderDict[@"brand"];
    self.nameLbl.text = orderDict[@"title"];
    self.sizeLbl.text = orderDict[@"size"];
    self.timeLbl.text = sourceDict[@"updatetime"];
    self.statusLbl.text = sourceDict[@"content"];
    self.countLbl.text = [NSString stringWithFormat:@"x %@", orderDict[@"storage"]];
    
    
}
@end
