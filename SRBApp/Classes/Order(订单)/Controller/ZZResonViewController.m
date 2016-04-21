//
//  ZZResonViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/20.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZResonViewController.h"
#import "ZZResonView.h"
#import "ZZCancelOrderViewController.h"

@interface ZZResonViewController ()<resonViewDelegate>

@end

@implementation ZZResonViewController

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

    ZZCancelOrderViewController * cancelVC = (ZZCancelOrderViewController *)[self parentViewController];
    if (![cancelVC.resonLabel.text isEqualToString:_array[row]]) {
        cancelVC.resonLabel.text = [_array objectAtIndex:row];
    }
    if (row == 9) {
        cancelVC.textView.hidden = NO;
        cancelVC.otherResonLabel.hidden = NO;
    }else{
        cancelVC.textView.hidden = YES;
        cancelVC.otherResonLabel.hidden = YES;
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

@end
