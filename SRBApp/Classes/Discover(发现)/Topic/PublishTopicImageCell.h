//
//  PublishTopicImageCell.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishTopicSuperCell.h"

@interface PublishTopicImageCell : PublishTopicSuperCell
@property (weak, nonatomic) IBOutlet UIImageView *contentIV;

@property (nonatomic, strong)NSIndexPath *indexPath;

@property (nonatomic, strong)NSArray *marksArray;

-(void)showMarksView;
@end
