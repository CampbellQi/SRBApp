//
//  PersonalSingleGrassListCell.m
//  SRBApp
//
//  Created by liying on 16/1/25.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PersonalSingleGrassListCell.h"
#define MAINCELL @"maincell"
#define ATTACHCELL @"attachcell"
@implementation PersonalSingleGrassListCell

- (void)awakeFromNib {
    // Initialization code
    
}

-(void)setSourceDict:(NSDictionary *)sourceDict {
    _sourceDict = sourceDict;
//    TopicDetailModel *model = [[TopicDetailModel alloc] init];
//    model.cell = MAINCELL;
//    [model setValuesForKeysWithDictionary:_sourceDict];
//    if ([model.photo isEqualToString:@"1"] && model.content.length){
//            _dict = sourceDict[@"labels"];
//            if (_dict) {
//                self.brandLB.text = _dict[0][@"brand"];
//                self.titleLB.text = _dict[0][@"name"];
////                self.countryLB.text = _dict[0][@"shopland"];
////                self.referencePriceLB.text = [NSString stringWithFormat:@"参考价 ¥ %@",_dict[0][@"shopPrice"]];
//            }
//        self.countryLB.text = sourceDict[@"city"];
//        self.referencePriceLB.text = [NSString stringWithFormat:@"参考价 ¥ %@",sourceDict[@"originalPrice"]];
//        [self.CoverIV sd_setImageWithURL:[NSURL URLWithString:sourceDict[@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//    }else if ([model.photo isEqualToString:@"1"]){
//        self.brandLB.text = sourceDict[@"brand"];
//        self.titleLB.text = sourceDict[@"title"];
//        self.countryLB.text = sourceDict[@"city"];
//        self.referencePriceLB.text = [NSString stringWithFormat:@"参考价 ¥ %@",sourceDict[@"originalPrice"]];
//        [self.CoverIV sd_setImageWithURL:[NSURL URLWithString:sourceDict[@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//    }else if (model.content.length){
        self.brandLB.text = sourceDict[@"brand"];
        self.titleLB.text = sourceDict[@"title"];
        self.countryLB.text = sourceDict[@"city"];
        self.referencePriceLB.text = [NSString stringWithFormat:@"参考价 ¥ %@",sourceDict[@"originalPrice"]];
        [self.CoverIV sd_setImageWithURL:[NSURL URLWithString:sourceDict[@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    //}

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
