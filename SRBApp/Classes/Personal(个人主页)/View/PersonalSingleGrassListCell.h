//
//  PersonalSingleGrassListCell.h
//  SRBApp
//
//  Created by liying on 16/1/25.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicDetailModel.h"

@interface PersonalSingleGrassListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *CoverIV;
@property (weak, nonatomic) IBOutlet UILabel *brandLB;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *countryLB;
@property (weak, nonatomic) IBOutlet UILabel *referencePriceLB;
@property (nonatomic, strong)NSDictionary *sourceDict;
@property (nonatomic, strong)NSString *cover;
@property (nonatomic, strong)NSArray *dict;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end
