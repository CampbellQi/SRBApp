//
//  OptionViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "OptionViewController.h"
#import "IdSafeViewController.h"
#import "GesturePassTableViewCell.h"
#import "AskedAddressBookViewController.h"
#import "InviteFriendsTableViewController.h"
#import "HelpViewController.h"
#import "SuggestionViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "ZZNavigationController.h"
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <SDWebImage/SDImageCache.h>
#import "ReceiveGoodsTableViewController.h"
#import "GesturePassViewController.h"
#import "AutoDismissAlert.h"
#import "APService.h"
#import "ChangePassWordViewController.h"
#import "CreateGetMoneyViewController.h"
#import "GetMoneyPassWordViewController.h"
#import "AccountBindingController.h"

@interface OptionViewController ()
{
    NSArray * _arr1;
    NSArray * _arr2;
    
    UIButton * button;
        
    UIButton * buyButton;
    UIButton * saleButton;
    UIButton * runButton;
        
    UILabel * buyLabel;
    UILabel * saleLabel;
    UILabel * runLabel;
    BOOL isBack;
    
    NSString * pushSign;
    NSString * paypassword;
}
@property (nonatomic, strong) AMBlurView * blurView;
@property (nonatomic, strong) UISwitch *GestureSwitch;
@property (nonatomic, strong) UISwitch *PushSwitch;
@property (nonatomic, strong) UIImageView *versionSignView;//版本提示
@property (nonatomic, assign) int isNewVersion;
@property (nonatomic, strong) UIImageView *QRImgView;

@end

@implementation OptionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    // Do any additional setup after loading the view.
    self.title = @"我的设置";
    _arr1 = [NSArray array];
    _arr2 = [NSArray array];
    _arr1 = @[@"修改登录密码", @"设定支付密码", @"账号绑定"];
    _arr2 = @[@"使用帮助", @"意见反馈", @"清除缓存",@"关于我们"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    _optionView = [[OptionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _optionView.tableView.delegate = self;
    _optionView.tableView.dataSource = self;
    //    _optionView.tableView.scrollEnabled = NO;
    _optionView.tableView.tableFooterView = [[UIView alloc]init];
    _optionView.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [self.view addSubview:_optionView];

    
    UIView * theView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    theView.backgroundColor  = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [self.view addSubview:theView];
    
    
    UIButton * buttons = [UIButton buttonWithType:UIButtonTypeCustom];
    buttons.frame = CGRectMake(0,0, SCREEN_WIDTH - 50, 40);
    buttons.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    buttons.center = CGPointMake(SCREEN_WIDTH / 2,50);
    buttons.titleLabel.font = [UIFont systemFontOfSize:18];
    //buttons.backgroundColor = [UIColor colorWithRed:0.89 green:0 blue:0.36 alpha:1];
//    buttons.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 2;
    [buttons setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    [buttons addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [buttons setTitle:@"退出登录" forState:UIControlStateNormal];
    [theView addSubview:buttons];
    
    _optionView.tableView.delaysContentTouches = NO;
    
    _optionView.tableView.tableFooterView  = theView;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popLast) name:@"reloadVC" object:nil];
    self.versionSignView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 17, 7, 7)];
    self.versionSignView.hidden = YES;

    [self havepassword];
}

- (void)popLast
{
    [self.navigationController optionDismissViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    //[self.mineVC post];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        isBack = YES;
        NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
        
        [dataDic setObject:@"0" forKey:@"isLogin"];

        
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"userName"];
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"pwd"];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zhifubao"];
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"passsign"];
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"nickname"];
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"rongCloud"];
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"avatar"];
        
//        AppDelegate * app = APPDELEGATE;
//        app.signView.hidden = YES;
//        //app.signLabel.hidden = YES;
//        app.newwFriendView.hidden = YES;
//        app.versionSignView.hidden = YES;
        
        //将登录状态写入配置文件
        [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
        
//        //设置别名
        [APService setAlias:@"" callbackSelector:@selector(tagsAliasCallback: tags: alias:) object:self];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"rongCloud"];
//        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"nickname"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"avatar"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"pwd"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"zhifubao"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"passsign"];
        //注销微博
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
        [[RCIM sharedRCIM]disconnect:NO];
        
        [self.navigationController popViewControllerAnimated:NO];
        
        AppDelegate * appdele = APPDELEGATE;
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        ZZNavigationController * loginNC = [[ZZNavigationController alloc]initWithRootViewController:loginVC];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"reloadVC" object:nil];
            loginVC.pwdTF.text = @"";
            UINavigationController * tempNC = [appdele.mainTab.viewControllers objectAtIndex:4];
            MineFragmentViewController * tempVC = tempNC.viewControllers[0];
            [tempVC presentViewController:loginNC animated:YES completion:nil];
        });
    }
    
}


//登出方法
- (void)exit
{
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"确定退出登录?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alertview show];

}


#pragma mark - TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _arr1[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row == 1) {
            float height = 20;
            float width = 60;
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-width-40, (CGRectGetHeight(cell.contentView.frame) - height)/2, width, height)];
            lbl.backgroundColor = MAINCOLOR;
            lbl.layer.cornerRadius = CGRectGetHeight(lbl.frame) * 0.5;
            lbl.layer.masksToBounds = YES;
            lbl.textColor = [UIColor whiteColor];
            lbl.font = [UIFont systemFontOfSize:15];
            lbl.text = pushSign;
            lbl.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:lbl];
//            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
//            cell.detailTextLabel.text = cell.detailTextLabel.text = pushSign;
//            cell.detailTextLabel.backgroundColor = [UIColor redColor];
        }
        return cell;
    }
//    if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            GesturePassTableViewCell *cell = [[GesturePassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//            cell.textLabel.text = @"启动手势密码";
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            [cell.gestureSwitch addTarget:self action:@selector(gesturePass) forControlEvents:UIControlEventValueChanged];
//            self.GestureSwitch = cell.gestureSwitch;
//            cell.textLabel.font = SIZE_FOR_14;
//            NSString* pswd = [LLLockPassword loadLockPassword];
//            if (pswd) {
//                cell.gestureSwitch.on = YES;
//            }
//            return  cell;
//        }
//    }
    if (indexPath.section == 1) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _arr2[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row == 2) {
            float sizes = [[SDImageCache sharedImageCache]getSize]/1048576.00;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", sizes];
        }
//        if (indexPath.row == 3) {
//            //新版本提示
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
//            view.backgroundColor = [UIColor clearColor];
//            
//            self.versionSignView.image = [UIImage imageNamed:@"newfriend_notic"];
////            self.versionSignView.hidden = YES;
//            [view addSubview:self.versionSignView];
//            cell.accessoryView = view;
//            
//        }
        return cell;
    }
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _arr1.count;
    }
    if (section == 1) {
        return _arr2.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            ChangePassWordViewController * vc = [[ChangePassWordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
//            IdSafeViewController * vc = [[IdSafeViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
//        if (indexPath.row == 1) {
//            ReceiveGoodsTableViewController *receiveGoodsTVC = [[ReceiveGoodsTableViewController alloc] init];
//            [self.navigationController pushViewController:receiveGoodsTVC animated:YES];
//            
//        }
        if (indexPath.row == 1) {
            if ([pushSign  isEqual: @"未设定"]) {
                CreateGetMoneyViewController * vc = [[CreateGetMoneyViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                GetMoneyPassWordViewController * vc = [[GetMoneyPassWordViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
//            AskedAddressBookViewController * vc = [[AskedAddressBookViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
//            InviteFriendsTableViewController * vc = [[InviteFriendsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
//            [self.navigationController pushViewController:vc animated:YES];
            
            AccountBindingController *vc = [[AccountBindingController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            HelpViewController * vc = [[HelpViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            SuggestionViewController * vc = [[SuggestionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 3) {
            AboutUsViewController * vc = [[AboutUsViewController alloc]init];
            vc.isNewVersion = self.isNewVersion;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"清除中,请稍后";
            HUD.dimBackground = YES;
            [HUD show:YES];
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            NSString * message = [[NSString alloc]initWithFormat:@"成功清除缓存" ];
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [HUD removeFromSuperview];
            [alertView show];
            [tableView reloadData];
        }
    }
}


//JSON字符串转换成字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


# pragma mark - 清除缓存
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

#pragma mark- 网络请求
//获取支付密码
- (void)havepassword
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetQuestion" parameters:@{ACCOUNT_PASSWORD}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSDictionary * dic1 = [dic objectForKey:@"data"];
            paypassword = [dic1 objectForKey:@"question"];
            if ([paypassword isEqualToString:@""]) {
                pushSign = @"未设定";
            }else{
                pushSign = @"已设定";
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [_optionView.tableView reloadData];
        [HUD removeFromSuperview];
    }];
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
