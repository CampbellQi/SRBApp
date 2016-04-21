//
//  ChangeLaterViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ChangeLaterViewController.h"
#import "MyPublishViewController.h"

@interface ChangeLaterViewController ()

@end

@implementation ChangeLaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)backBtn
{
    MyPublishViewController * vc = [[self.navigationController viewControllers] objectAtIndex:2];
    [self.navigationController popToViewController:vc animated:YES];
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
