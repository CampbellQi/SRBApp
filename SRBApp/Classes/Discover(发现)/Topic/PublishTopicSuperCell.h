//
//  PublishTopicSuperCell.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublishTopicSuperCell;

typedef void (^AddBlock) (PublishTopicSuperCell *editCell);

typedef void (^DeleteBlock) (PublishTopicSuperCell *editCell);
typedef void (^EditBlock) (PublishTopicSuperCell *editCell);

@interface PublishTopicSuperCell : UITableViewCell

@property (nonatomic, copy)DeleteBlock deleteBlock;
@property (nonatomic, copy)EditBlock editBlock;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, copy)AddBlock addBlock;

- (IBAction)addBtnClicked:(id)sender;
- (IBAction)deleteBtnClicked:(id)sender;

-(void)prepareForMove;
@end
