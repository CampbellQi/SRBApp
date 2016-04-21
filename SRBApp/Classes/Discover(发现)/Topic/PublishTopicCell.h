//
//  PublishTopicCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define TV_PLACEHOLDER_COLOR [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]

#import <UIKit/UIKit.h>
#import "PublishTopicSuperCell.h"

@class PublishTopicCell;

typedef void (^ImageTapBlock) (PublishTopicCell *editCell);
typedef void (^TextTapBlock) (PublishTopicCell *editCell);
@interface PublishTopicCell : PublishTopicSuperCell


@property (weak, nonatomic) IBOutlet UIImageView *textIV;
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;

@property (nonatomic, copy)ImageTapBlock imageTapBlock;
@property (nonatomic, copy)TextTapBlock textTapBlock;


@end
