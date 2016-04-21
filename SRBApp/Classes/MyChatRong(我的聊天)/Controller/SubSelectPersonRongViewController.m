//
//  SubSelectPersonRongViewController.m
//  SRBApp
//
//  Created by lizhen on 15/2/28.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubSelectPersonRongViewController.h"

@interface SubSelectPersonRongViewController ()

@end

@implementation SubSelectPersonRongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"SelectPersonRongViewController的子类");
    // Do any additional setup after loading the view.
}
//传值
- (void)alone:(AloneBlock)block
{
    self.aloneBlock = block;
}

- (void)rightBarButtonItemPressed:(UIBarButtonItem *)sender
{
    if (self.aloneBlock != nil) {
        self.aloneBlock(@"1");
    }
    [super rightBarButtonItemPressed:sender];
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
