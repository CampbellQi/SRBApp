//
//  PublishTopicFooterView.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishTopicFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UIButton *locationHideBtn;
- (IBAction)locationHideBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *topView;

@end
