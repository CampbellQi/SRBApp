//
//  PublishTopicTextCell.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishTopicSuperCell.h"
@interface PublishTopicTextCell : PublishTopicSuperCell
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
- (IBAction)deleteBtnClicked:(id)sender;

@end
