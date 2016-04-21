//
//  PublishTopicTextController.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"
#import "PublishTopicModel.h"

typedef void (^CompletedBlock) (NSString *text);
@interface PublishTopicTextController : SRBBaseViewController
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *wordsCountLbl;

@property (nonatomic, strong)CompletedBlock completedBlock;
@property (nonatomic, strong)NSString *sourceText;

@property (nonatomic, assign)int maxWordsCount;
@end
