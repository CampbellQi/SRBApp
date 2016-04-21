//
//  SubChatSettingVControllerViewController.m
//  SRBApp
//
//  Created by lizhen on 15/3/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubChatSettingViewController.h"

@interface SubChatSettingViewController ()

@end

@implementation SubChatSettingViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    
    if ([self.type isEqualToString:@"1"]) {
        app.tabBarBtn1.selected = NO;
        app.tabBarBtn2.selected = NO;
        app.tabBarBtn4.selected = YES;
        app.tabBarBtn5.selected = NO;
        [app.mainTab setSelectedIndex:3];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
