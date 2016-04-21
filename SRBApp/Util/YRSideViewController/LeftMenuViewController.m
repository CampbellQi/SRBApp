//
//  LeftMenuViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "ZZLeftVCView.h"
#import "ZZLeftVCPeopleInformationCellTableViewCell.h"
#import "ZZLeftVCButtonsTableViewCell.h"
#import "ZZLeftVCmyButtonTableViewCell.h"
#import "ZZLeftVCOptionTableViewCell.h"
#import "OptionViewController.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "ZZMyOrderViewController.h"

#import "ZZBaseNavigationController.h"
#import <UIButton+WebCache.h>
#import "IdSafeViewController.h"

#import "MyAttentionActivityViewController.h"
#import "ZZNavigationController.h"

#import "MyWalletActivityViewController.h"


@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) ZZLeftVCView * leftVCView;
@property(nonatomic, strong) NSMutableDictionary * dic;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    _dic = [[NSMutableDictionary alloc]init];
    [self post];
    
    _leftVCView = [[ZZLeftVCView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _leftVCView.backgroundColor = [UIColor blackColor];
    _leftVCView.tableView.delegate = self;
    _leftVCView.tableView.dataSource = self;
    [self.view addSubview:_leftVCView];
    
//    self.needSwipeShowMenu = true;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ZZLeftVCPeopleInformationCellTableViewCell * cell = [[ZZLeftVCPeopleInformationCellTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.phoneLabel.text = [_dic objectForKey:@"nickname"];
        NSLog(@"%@!!!!", [_dic objectForKey:@"nickname"]);
        cell.starLabel.text = [_dic objectForKey:@"evaluation"];
        cell.sayLabel.text = [_dic objectForKey:@"sign"];
        [cell.imageButton sd_setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"avatar" ]] forState:UIControlStateNormal];
        [cell.imageButton addTarget:self action:@selector(changeInformation) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (indexPath.row == 1) {
        ZZLeftVCButtonsTableViewCell * cell1 = [[ZZLeftVCButtonsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
        [cell1.attentButton addTarget:self action:@selector(toMyAttent:) forControlEvents:UIControlEventTouchUpInside];
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell1;
    }
    if (indexPath.row >= 2 && indexPath.row <= 6 ) {
        ZZLeftVCmyButtonTableViewCell * cell2 = [[ZZLeftVCmyButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell3"];
        [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 2) {
            cell2.label.text = @"我的发布";
        }
        if (indexPath.row == 3) {
            cell2.label.text = @"我的订单";
        }
        if (indexPath.row == 4) {
            cell2.label.text = @"我的钱包";
        }
        if (indexPath.row == 5) {
            cell2.label.text = @"我的评价";
        }
        if (indexPath.row == 6) {
            cell2.label.text = @"我的聊天";
        }
        return cell2;
    }
    if (indexPath.row == 7 || indexPath.row == 8) {
        ZZLeftVCOptionTableViewCell * cell3 = [[ZZLeftVCOptionTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell4"];
        [cell3 setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 7) {
            cell3.label.text = @"卖家管理";
        }
        if (indexPath.row == 8) {
            cell3.label.text = @"更多设置";
        }
        return cell3;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 25 + 75 + 15;
    }
    if (indexPath.row == 1) {
        return 45;
    }
    if (indexPath.row >= 2 && indexPath.row <= 6 ) {
        return 60;
    }
    if (indexPath.row == 7 || indexPath.row == 8) {
        return 70;
    }
    return 10;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDMenuController *menu = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication]delegate]).menuController;
    if (indexPath.row == 3) {
        ZZMyOrderViewController * vc = [[ZZMyOrderViewController alloc]init];
        ZZNavigationController *nac = [[ZZNavigationController alloc]initWithRootViewController:vc];
        
        [menu setRootController:nac animated:YES];
    }
    if (indexPath.row == 4) {
        MyWalletActivityViewController * vc = [[MyWalletActivityViewController alloc]init];
        ZZNavigationController *nac = [[ZZNavigationController alloc]initWithRootViewController:vc];
        
        [menu setRootController:nac animated:YES];
    }
    if (indexPath.row == 8) {
//        OptionViewController * vc = [[OptionViewController alloc]init];
//        _rootViewController.view.userInteractionEnabled = YES;
//        [_rootViewController.navigationController pushViewController:vc animated:YES];
        OptionViewController *VC = [[OptionViewController alloc] init];
        ZZBaseNavigationController *nac = [[ZZBaseNavigationController alloc] initWithRootViewController:VC];
        [menu setRootController:nac animated:YES];
    }
}

#pragma mark - post请求
- (void)post
{
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{@"account":name, @"password":password, @"user":name}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        _dic = [dic objectForKey:@"data"];
        [_leftVCView.tableView reloadData];
        if ([dic objectForKey:@"title"] == nil || [dic objectForKey:@"content"] == nil) {
        }else{
            [AutoDismissAlert autoDismissAlert:@"请求失败"];
        }
    }];
}
- (void)toMyAttent:(UIButton *)sender
{
    MyAttentionActivityViewController * myAttentionVC = [[MyAttentionActivityViewController alloc]init];
    ZZNavigationController * myAttentionNC = [[ZZNavigationController alloc]initWithRootViewController:myAttentionVC];
    DDMenuController *menu = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication]delegate]).menuController;
    [menu setRootController:myAttentionNC animated:YES];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

#pragma mark - 修改信息
- (void)changeInformation
{
    
    
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
