//
//  ResultController.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/5.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultController : UIViewController

@property (nonatomic, strong)UIImage *sourceImage;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
- (IBAction)backClicked:(id)sender;
@property (nonatomic, strong)NSArray *markArray;
@end
