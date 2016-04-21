//
//  InviteFriendViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "InviteFriendViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"

@interface InviteFriendViewController ()
@property (nonatomic, strong) NSArray * arr;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation InviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的设置";
    _arr = [NSArray array];
    _arr = @[@"QQ好友", @"QQ空间", @"短信邀请", @"微信好友", @"微信朋友圈", @"微信绑定", @"新浪微博绑定"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20 * 3 + 40 * 8 + 5) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    __block NSDictionary *temDic = self.dataDic;
    //请求数据
    NSDictionary * shareParam = @{@"method":@"getShareInfo",@"parameters":@{@"type":@"1"}};
    [URLRequest postRequestWith:iOS_POST_URL parameters:shareParam andblock:^(NSDictionary *dic) {
        NSLog(@"shareDic == %@",dic);
        temDic = [dic objectForKey:@"data"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = _arr[indexPath.row];
        cell.textAlignment = NSTextAlignmentCenter;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    UITableViewCell * cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    cell1.textLabel.text = _arr[indexPath.row + 5];
    cell1.textAlignment = NSTextAlignmentCenter;
    [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[self.dataDic objectForKey:@"note"]
                                       defaultContent:[self.dataDic objectForKey:@"note"]
                                                image:[ShareSDK imageWithUrl:[self.dataDic objectForKey:@"photo"]]
                                                title:[self.dataDic objectForKey:@"title"]
                                                  url:[self.dataDic objectForKey:@"url"]
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
        if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                NSLog(@"idnexPath == 1");
                //定制QQ分享信息
                [publishContent addQQUnitWithType:INHERIT_VALUE
                                          content:[self.dataDic objectForKey:@"note"]
                                            title:[self.dataDic objectForKey:@"title"]
                                              url:[self.dataDic objectForKey:@"url"]
                                            image:[ShareSDK imageWithUrl:[self.dataDic objectForKey:@"photo"]]];
                
                break;
            case 1:
                NSLog(@"idnexPath == 2");

                //定制QQ空间信息
                [publishContent addQQSpaceUnitWithTitle:[self.dataDic objectForKey:@"title"]                                            url:[self.dataDic objectForKey:@"url"]
                                                   site:nil
                                                fromUrl:nil
                                                comment:nil
                                                summary:nil
                                                  image:[ShareSDK imageWithUrl:[self.dataDic objectForKey:@"photo"]]
                                                   type:INHERIT_VALUE
                                                playUrl:nil
                                                   nswb:nil];
                break;
            case 2:
                NSLog(@"idnexPath == 3");

                //定制短信信息
                [publishContent addSMSUnitWithContent:[[self.dataDic objectForKey:@"note"] stringByAppendingString:[self.dataDic objectForKey:@"url"]]];
                break;
            case 3:
                NSLog(@"idnexPath == 4");

                //定制微信好友信息
                [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                                     content:[self.dataDic objectForKey:@"note"]
                                                       title:[self.dataDic objectForKey:@"title"]
                                                         url:[self.dataDic objectForKey:@"url"]
                                                  thumbImage:[ShareSDK imageWithUrl:[self.dataDic objectForKey:@"photo"]]
                                                       image:[ShareSDK imageWithUrl:[self.dataDic objectForKey:@"photo"]]
                                                musicFileUrl:nil
                                                     extInfo:nil
                                                    fileData:nil
                                                emoticonData:nil];
                break;
            case 4:
                NSLog(@"idnexPath == 5");

                [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage | SSPublishContentMediaTypeText | SSPublishContentMediaTypeNews]
                                                      content:[self.dataDic objectForKey:@"note"]
                                                        title:[self.dataDic objectForKey:@"title"]
                                                          url:[self.dataDic objectForKey:@"url"]
                                                   thumbImage:[ShareSDK imageWithUrl:[self.dataDic objectForKey:@"photo"]]
                                                        image:[ShareSDK imageWithUrl:[self.dataDic objectForKey:@"photo"]]
                                                 musicFileUrl:nil
                                                      extInfo:nil
                                                     fileData:nil
                                                 emoticonData:nil];
                break;
                
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                NSLog(@"idnexPath == 11");

                [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                                  authOptions:nil
                                       result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                           
                                           if (result)
                                           {
                                               id <ISSPlatformCredential> creden = [userInfo credential];
                                               NSString* uid = [creden uid];
                                               NSString* token = [creden token];
                            
                                               //拼接post请求所需参数
                                               NSDictionary * loginParam = @{@"method":@"accountLoginToken",@"parameters":@{@"type":@"weixin",@"token":[NSString stringWithFormat:@"%@",token],@"deviceID":@"0",@"deviceName":[NSString stringWithFormat:@"%@",PHONE_NAME],@"unionid":[NSString stringWithFormat:@"%@",uid]}};
                                               [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                                                   NSLog(@"dic == %@",dic);
                                                   
                                                   int result = [[dic objectForKey:@"result"]intValue];
                                                   if (result == 0) {
                                                       NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
                                                       if (dataDic == nil) {
                                                           dataDic = [NSMutableDictionary dictionary];
                                                       }
                                                       [dataDic setObject:@"1" forKey:@"isLogin"];
                                                       //将登录状态写入配置文件
                                                       [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
                                                       NSDictionary * tempDic = [dic objectForKey:@"data"];
                                                       [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"rongCloud"] forKey:@"rongCloud"];
                                                       [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"account"] forKey:@"userName"];
                                                       [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"password"] forKey:@"pwd"];
                                                   }
                                               }];
                                               
                                           }else{
                                               [AutoDismissAlert autoDismissAlert:@"您还没有下载微信客户端"];
                                           }
                                       }];
                break;
            case 1:
                NSLog(@"idnexPath == 22");

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
                                               
                                               //拼接post请求所需参数
                                               NSDictionary * loginParam = @{@"method":@"accountLoginToken",@"parameters":@{@"type":@"weibo",@"token":[NSString stringWithFormat:@"%@",token],@"deviceID":@"0",@"deviceName":[NSString stringWithFormat:@"%@",PHONE_NAME]}};
                                               [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                                                   NSLog(@"dic == %@",dic);
                                                   
                                                   int result = [[dic objectForKey:@"result"]intValue];
                                                   if (result == 0) {
                                                       NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
                                                       if (dataDic == nil) {
                                                           dataDic = [NSMutableDictionary dictionary];
                                                       }
                                                       [dataDic setObject:@"1" forKey:@"isLogin"];
                                                       //将登录状态写入配置文件
                                                       [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
                                                       NSDictionary * tempDic = [dic objectForKey:@"data"];
                                                       [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"rongCloud"] forKey:@"rongCloud"];
                                                       [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"account"] forKey:@"userName"];
                                                       [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"password"] forKey:@"pwd"];
                                                   }
                                               }];
                                               
                                           }else{
                                               [AutoDismissAlert autoDismissAlert:@"登录失败"];
                                           }
                                       }];
                break;
                
            default:
                break;
        }
    }
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
