//
//  AccountBindingController.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/30.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "AccountBindingController.h"
#import "CommonView.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

@interface AccountBindingController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataArray;
    MBProgressHUD *HUD;
    BOOL boundWithWeixin;
    BOOL boundWithWeibo;
    
}
@property (nonatomic, strong)NSString* weiboID;
@property (nonatomic, strong)NSString* weixinID;
@end

@implementation AccountBindingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"账号绑定";
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self refreshAccountBingdingRequest];
}
#pragma mark- 事件
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
    cell.textLabel.text = dict[@"title"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self bingdingWeiXin];
    }else {
        [self bindingWeibo];
    }
}
#pragma mark- 网络请求
-(void)bingdingWeiXin {
    if (![WXApi isWXAppInstalled]) {
        return;
    }
    //解除微信绑定
    if (self.weixinID.length) {
        NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{ACCOUNT_PASSWORD,@"apiType":@"weixin",@"token":@"0"}};
        [HUD removeFromSuperview];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"操作中,请稍后";
        HUD.dimBackground = YES;
        [HUD show:YES];
        [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD removeFromSuperview];
                [self refreshAccountBingdingRequest];
            });
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }];

    }else{
        NSLog(@"idnexPath == 00");
        
        [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                          authOptions:nil
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   if (result)
                                   {
                                       id <ISSPlatformCredential> creden = [userInfo credential];
                                       NSString* uid = [creden uid];
                                       NSString* token = [creden token];
                                       
                                       //拼接post请求所需参数
                                       NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{ACCOUNT_PASSWORD,@"apiType":@"weixin",@"token":[NSString stringWithFormat:@"%@",token],@"unionid":uid}};
                                       [HUD removeFromSuperview];
                                       HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                       HUD.labelText = @"操作中,请稍后";
                                       HUD.dimBackground = YES;
                                       [HUD show:YES];
                                       [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                                           //                                                   NSLog(@"dic == %@",dic);
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [HUD removeFromSuperview];
                                               [self refreshAccountBingdingRequest];
                                           });
                                           [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                                       }];
                                   }
                               }];
    }
}
-(void)bindingWeibo {
    if (self.weiboID.length){
        //拼接post请求所需参数
        NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{ACCOUNT_PASSWORD,@"apiType":@"weibo",@"token":@"0"}};
        [HUD removeFromSuperview];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"操作中,请稍后";
        HUD.dimBackground = YES;
        [HUD show:YES];
        [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD removeFromSuperview];
                [self refreshAccountBingdingRequest];
            });
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }];
    }
    
    else{
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                          authOptions:nil
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   
                                   if (result)
                                   {
                                       id <ISSPlatformCredential> creden = [userInfo credential];
                                       NSString* uid = [creden uid];
                                       NSString* token = [creden token];
                                       NSLog(@"uid:%@",uid);
                                       NSLog(@"token:%@",token);
                                       NSLog(@"uid = %@",[userInfo uid]);
                                       NSLog(@"name = %@",[userInfo nickname]);
                                       NSLog(@"icon = %@",[userInfo profileImage]);
                                       [HUD removeFromSuperview];
                                       HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                       HUD.labelText = @"操作中,请稍后";
                                       HUD.dimBackground = YES;
                                       [HUD show:YES];
                                       
                                       NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{ACCOUNT_PASSWORD,@"apiType":@"weibo",@"token":token}};
                                       [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [HUD removeFromSuperview];
                                               [self refreshAccountBingdingRequest];
                                           });
                                           [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                                       }];
                                   }
                               }];
    }
}
//刷新用户保密信息
- (void)refreshAccountBingdingRequest
{
    NSDictionary * loginParam = @{@"method":@"accountGetInfo",@"parameters":@{ACCOUNT_PASSWORD}};
    
    [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
        self.weiboID = [[dic objectForKey:@"data"] objectForKey:@"weiboid"];
        self.weixinID = [[dic objectForKey:@"data"] objectForKey:@"weixinid"];
        if (self.weiboID && self.weixinID) {
            NSString *weiboStr = @"新浪微博绑定";
            NSString *weixinStr = @"微信绑定";
            if (self.weixinID.length) {
                weixinStr = @"取消微信绑定";
            }
            if (self.weiboID.length) {
                weiboStr = @"取消新浪微博绑定";
            }
            _dataArray = @[@{@"title": weixinStr, @"image": @"pc_accountbingding_weixin",@"boundingID": self.weixinID}, @{@"title": weiboStr, @"image": @"pc_accountbingding_weibo", @"boundingID": self.weiboID}];
            [self.tableView reloadData];
        }
        
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
