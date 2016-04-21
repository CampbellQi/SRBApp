//
//  MessageCenterToSubClassViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/4/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MessageCenterToSubClassViewController.h"

@interface MessageCenterToSubClassViewController ()

@end

@implementation MessageCenterToSubClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)backBtn
{
    isBack = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pianyi
{
    //    CGRect * rect = (__bridge CGRect *)(self.tableView);
    if (self.tableView != nil) {
        UIView * view = [[UIView alloc]init];
        view.frame = self.tableView.tableHeaderView.frame;
//        [self.tableView setContentOffset:CGPointMake(0, view.frame.origin.y + view.frame.size.height - 280  ) animated:YES];
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
