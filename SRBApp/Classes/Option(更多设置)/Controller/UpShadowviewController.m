//
//  UpShadowviewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/20.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "UpShadowviewController.h"
#import "ZZResonView.h"
#import "SuggestionViewController.h"

@interface UpShadowviewController ()<resonViewDelegate>

@end

@implementation UpShadowviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ZZResonView * resonView = [[ZZResonView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    resonView.delegate = self;
    resonView.array = self.array;
    self.view = resonView;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeFromParentViewController];
}

- (void)resonView:(ZZResonView *)resonView didSelectRow:(NSInteger)row
{
    
    SuggestionViewController * cancelVC = (SuggestionViewController *)[self parentViewController];
    [cancelVC.button setTitle:[_array objectAtIndex:row] forState:UIControlStateNormal];
//    if (![cancelVC.button.text isEqualToString:_array[row]]) {
//        cancelVC.resonLabel.text = [_array objectAtIndex:row];
//    }
//    if (row == 9) {
//        cancelVC.textView.hidden = NO;
//        cancelVC.otherResonLabel.hidden = NO;
//    }else{
//        cancelVC.textView.hidden = YES;
//        cancelVC.otherResonLabel.hidden = YES;
//    }
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

@end
