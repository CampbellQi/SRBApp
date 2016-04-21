//
//  InviteFriendsTableViewController.m
//  SRBApp
//
//  Created by lizhen on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "InviteFriendsTableViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
//#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "AutoDismissAlert.h"
#import "WXApi.h"

@interface InviteFriendsTableViewController ()
{
    //    BOOL boundWithWeixin;
    //    BOOL boundWithWeibo;
    
}
@property (nonatomic, strong) NSArray *inviteArr;//邀请好友
@property (nonatomic, strong) NSArray *shareToPlatform;//分享到平台
//@property (nonatomic, strong) NSString *weixinID;
//@property (nonatomic, strong) NSString *weiboID;

@end

@implementation InviteFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
        self.inviteArr = @[@"邀请QQ好友", @"邀请微信好友", @"邀请通讯录好友"];
        self.shareToPlatform = @[@"分享到QQ空间", @"分享到微信朋友圈"];
    }else if (![QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
        self.inviteArr = @[@"邀请微信好友", @"邀请通讯录好友"];
        self.shareToPlatform = @[@"分享到微信圈"];
    }else if ([QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]){
        self.inviteArr = @[@"邀请QQ好友", @"邀请通讯录好友"];
        self.shareToPlatform = @[@"分享到QQ空间"];
    }else{
        self.inviteArr = @[@"邀请通讯录好友"];
        self.shareToPlatform = nil;
    }
    self.title = @"邀请熟人";
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)backBtn:(id)sender
{
    [self.navigationController dismissViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        if ([QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            return 3;
        }else if(![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]){
            return 1;
        }else{
            return 2;
        }
    }else if (section == 1){
        if ([QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            return 2;
        }else if(![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]){
            return 0;
        }else{
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *section1 = @"sectionOne";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section1];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section1];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        cell.textLabel.text = [self.inviteArr objectAtIndex:indexPath.row];
        cell.textLabel.font = SIZE_FOR_14;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [self.shareToPlatform objectAtIndex:indexPath.row];
        cell.textLabel.font = SIZE_FOR_14;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * shareParam = @{@"method":@"getShareInfo",@"parameters":@{@"account":ACCOUNT_SELF, @"password":PASSWORD_SELF,@"type":@"1"}};
    [URLRequest postRequestWith:iOS_POST_URL parameters:shareParam andblock:^(NSDictionary *dic) {
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        NSLog(@"dataDic == %@",dataDic);
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:[dataDic objectForKey:@"note"]
                                           defaultContent:[dataDic objectForKey:@"note"]
                                                    image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                    title:[dataDic objectForKey:@"title"]
                                                      url:[dataDic objectForKey:@"url"]
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeNews];
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"熟人邦", @"内容分享")
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:nil
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
        
        if (indexPath.section == 0) {
            if (![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
                if (indexPath.row == 0) {
                    //                    //定制短信信息
                    [publishContent addSMSUnitWithContent:[[dataDic objectForKey:@"note"] stringByAppendingString:[dataDic objectForKey:@"url"]]];
                    [ShareSDK clientShareContent:publishContent
                                            type:ShareTypeSMS
                                     authOptions:authOptions
                                    shareOptions:shareOptions
                                   statusBarTips:YES
                                         targets:nil
                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                              if (error) {
                                                  [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                              }
                                          }];
                }
            }else{
                switch (indexPath.row) {
                    case 0:
                        NSLog(@"idnexPath == 0");
                        //                    //定制QQ分享信息
                        //                    [publishContent addQQUnitWithType:INHERIT_VALUE
                        //                                              content:[dataDic objectForKey:@"note"]
                        //                                                title:[dataDic objectForKey:@"title"]
                        //                                                  url:[dataDic objectForKey:@"url"]
                        //                                                image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]];
                        
                        [ShareSDK clientShareContent:publishContent
                                                type:ShareTypeQQ
                                         authOptions:authOptions
                                        shareOptions:shareOptions
                                       statusBarTips:YES
                                             targets:nil
                                              result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                  if (error) {
                                                      [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                                  }
                                              }];
                        
                        break;
                    case 1:
                        NSLog(@"idnexPath == 1");
                        //                    //定制微信好友信息
                        //                    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                        //                                                         content:[dataDic objectForKey:@"note"]
                        //                                                           title:[dataDic objectForKey:@"title"]
                        //                                                             url:[dataDic objectForKey:@"url"]
                        //                                                      thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                        //                                                           image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                        //                                                    musicFileUrl:nil
                        //                                                         extInfo:nil
                        //                                                        fileData:nil
                        //                                                    emoticonData:nil];
                        [ShareSDK clientShareContent:publishContent
                                                type:ShareTypeWeixiSession
                                         authOptions:authOptions
                                        shareOptions:shareOptions
                                       statusBarTips:YES
                                             targets:nil
                                              result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                  if (error) {
                                                      [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                                  }
                                              }];
                        
                        
                        break;
                    case 2:
                        NSLog(@"idnexPath == 2");
                        
                        //                    //定制短信信息
                        [publishContent addSMSUnitWithContent:[[dataDic objectForKey:@"note"] stringByAppendingString:[dataDic objectForKey:@"url"]]];
                        [ShareSDK clientShareContent:publishContent
                                                type:ShareTypeSMS
                                         authOptions:authOptions
                                        shareOptions:shareOptions
                                       statusBarTips:YES
                                             targets:nil
                                              result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                  if (error) {
                                                      [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                                  }
                                              }];
                        break;
                    default:
                        break;
                }
            }
          
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                NSLog(@"idnexPath == 3");
                //                //定制QQ空间信息
                [publishContent addQQSpaceUnitWithTitle:[dataDic objectForKey:@"note"]
                                                    url:[dataDic objectForKey:@"url"]
                                                   site:nil
                                                fromUrl:nil
                                                comment:nil
                                                summary:nil
                                                  image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                   type:INHERIT_VALUE
                                                playUrl:nil
                                                   nswb:nil];
                [ShareSDK clientShareContent:publishContent
                                        type:ShareTypeQQSpace
                                 authOptions:authOptions
                                shareOptions:shareOptions
                               statusBarTips:YES
                                     targets:nil
                                      result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                          if (error) {
                                              [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                          }else{
                                          }
                                      }];
            }
            if (indexPath.row == 1) {
                NSLog(@"idnexPath == 4");
                //                //微信朋友圈
                [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                                      content:[dataDic objectForKey:@"note"]
                                                        title:[dataDic objectForKey:@"note"]
                                                          url:[dataDic objectForKey:@"url"]
                                                   thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                        image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                 musicFileUrl:nil
                                                      extInfo:nil
                                                     fileData:nil
                                                 emoticonData:nil];
                [ShareSDK clientShareContent:publishContent
                                        type:ShareTypeWeixiTimeline
                                 authOptions:authOptions
                                shareOptions:shareOptions
                               statusBarTips:YES
                                     targets:nil
                                      result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                          if (error) {
                                              [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                          }else{
                                          }
                                      }];
            }
        }
    }];
}




@end
