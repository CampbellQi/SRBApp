//
//  ChangeGroupViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/31.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ChangeGroupViewController.h"
#import "ChangeGroupView.h"
#import "FriendsViewController.h"

@interface ChangeGroupViewController ()<changeGroupDelegate>

@end

@implementation ChangeGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ChangeGroupView * changeGroupView = [[ChangeGroupView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    changeGroupView.groupName = self.groupName;
    changeGroupView.delegate = self;
    self.view = changeGroupView;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeFromParentViewController];
}

- (void)changeGroup:(ChangeGroupView *)changeGroupView didSelectBtn:(NSInteger)index withName:(NSString *)groupName andNum:(NSString *)groupNum
{
    FriendsViewController * friendVC = (FriendsViewController *)[self parentViewController];
    if (index == 1) {
        [friendVC changeRequest:self.index withName:groupName andNum:groupNum];
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
