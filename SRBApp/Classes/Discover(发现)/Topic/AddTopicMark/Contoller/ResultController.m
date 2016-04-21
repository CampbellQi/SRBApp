//
//  ResultController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/5.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "ResultController.h"
#import "TPMarkModel.h"
#import "WQMarkView.h"
#import "InputMarkController.h"

@interface ResultController ()

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.resultImage.image = self.sourceImage;
    
    
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //添加标签
    for (TPMarkModel *model in _markArray) {
        WQMarkView *mark = [WQMarkView produceWithData:model];
        NSArray *xyz = [model.xyz componentsSeparatedByString:@","];
        mark.currentPoint = CGPointMake([xyz[0] floatValue] * CGRectGetWidth(self.resultImage.frame), [xyz[1] floatValue] * CGRectGetHeight(self.resultImage.frame));
        [self.resultImage addSubview:mark];
        [mark resetCenter];
        mark.isFreeze = YES;
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
