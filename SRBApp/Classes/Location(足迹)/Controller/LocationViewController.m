//
//  LocationViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "LocationViewController.h"
#import "MJRefresh.h"
#import "LocationModel.h"
#import "LocationCell.h"
#import "LeftImgAndRightTitleBtn.h"
#import "PsersonalViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"
#import "DDMenuController.h"
#import "AppDelegate.h"



@interface LocationViewController ()<UITableViewDataSource,UITableViewDelegate,TableViewCellDelegate>

@end

@implementation LocationViewController
{
    UITableView * tableview;
    NSMutableArray * dataArray;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 23);
    [button addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"mine.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.title = @"足迹";
    
    self.methodType = @"getDynamicLocationByRelation";
    [self customInit];
}

- (void)showLeft:(id)sender
{
    DDMenuController * ddMenu = ((AppDelegate *)[[UIApplication sharedApplication]delegate]).menuController;
    [ddMenu showLeftController:YES];
}

#pragma mark - 控件初始化
- (void)customInit
{

    dataArray = [NSMutableArray array];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview: tableview];
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
}

#pragma mark - tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationModel * locationModel = dataArray[indexPath.row];
    CGRect rect = [locationModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 15 - 20 - 8, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
    if ([locationModel.url isEqualToString:@""]) {
        return rect.size.height + 144;
    }else{
        return rect.size.height + 144 + 212;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LocationCell * cell = [LocationCell locationCellWithTaableView:tableView];
    LocationModel * locationModel = dataArray[indexPath.row];
    cell.locationModel = dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.zanBtn.indexpath = indexPath;
    [cell.zanBtn addTarget:self action:@selector(zanBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.indexpath = indexPath;
    [cell.shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    cell.logoImg.tag = indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLPersonal:)];
    [cell.logoImg addGestureRecognizer:tap];
    
    return cell;
}


//点击进入个人中心
- (void)tapToLPersonal:(UITapGestureRecognizer *)tap
{
    NSLog(@"%lu",tap.view.tag);
    LocationModel * locationModel = dataArray[tap.view.tag];
    PsersonalViewController *personalVC = [[PsersonalViewController alloc] init];
    NSLog(@"%@",locationModel.account);
    personalVC.account = locationModel.account;
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)viewreloadData
{
    [tableview reloadData];
}


#pragma mark - 点赞
- (void)zanBtn:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel * locationModel = dataArray[sender.indexpath.row];
    LocationCell * cell = (LocationCell *)[tableview cellForRowAtIndexPath:sender.indexpath];
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"accountLikeLocation" parameters:@{@"id":locationModel.ID,@"account":name,@"password":pass}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [cell showAlertLabel];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
    
}

#pragma mark - 分享
- (void)shareBtn:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel * locationModel = dataArray[sender.indexpath.row];
    NSDictionary * dataDic = @{@"title":locationModel.title,@"photo":locationModel.url};
    NSLog(@"dataDic == %@",dataDic);
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[dataDic objectForKey:@"title"]
                                       defaultContent:[dataDic objectForKey:@"title"]
                                                image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                title:[dataDic objectForKey:@"title"]
                                                  url:@"http://www.shurenbang.net/download/"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    //定制新浪微博
    [publishContent addSinaWeiboUnitWithContent:[dataDic objectForKey:@"title"]
                                          image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]];

    
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:[dataDic objectForKey:@"title"]
                                        url:@"http://www.shurenbang.net/download/"
                                       site:nil
                                    fromUrl:nil
                                    comment:nil
                                    summary:nil
                                      image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                       type:nil
                                    playUrl:nil
                                       nswb:nil];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:nil
                                           title:[dataDic objectForKey:@"title"]
                                             url:@"http://www.shurenbang.net/download/"
                                      thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                           image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage | SSPublishContentMediaTypeText]
                                          content:nil
                                            title:[dataDic objectForKey:@"photo"]
                                              url:@"http://www.shurenbang.net/download/"
                                       thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                            image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制微信收藏信息
    [publishContent addWeixinFavUnitWithType:INHERIT_VALUE
                                     content:nil
                                       title:[dataDic objectForKey:@"photo"]
                                         url:@"http://www.shurenbang.net/download/"
                                  thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                       image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                musicFileUrl:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil];
    
    //定制QQ分享信息
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:nil
                                title:[dataDic objectForKey:@"photo"]
                                  url:@"http://www.shurenbang.net/download/"
                                image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]];
    
    //定制邮件信息
    [publishContent addMailUnitWithSubject:nil
                                   content:[dataDic objectForKey:@"title"]
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:nil
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
    //定制短信信息
    [publishContent addSMSUnitWithContent:[dataDic objectForKey:@"title"]];
    
    
    //结束定制信息
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"熟人帮", @"内容分享")
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}


#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic;
    if ([self.methodType isEqualToString:@"getDynamicLocationByUser"])
    {
        dic = [self parametersForDic:self.methodType parameters:@{@"user":name,@"start":@"0",@"count":@"20"}];
    }else if([self.methodType isEqualToString:@"getDynamicLocationByCircle"])
    {
         dic = [self parametersForDic:self.methodType parameters:@{@"account":name,@"password":pass,@"start":@"0",@"count":@"20"}];
    }else if([self.methodType isEqualToString:@"getDynamicLocationByRelation"])
    {
         dic = [self parametersForDic:self.methodType parameters:@{@"account":name,@"password":pass,@"start":@"0",@"count":@"20"}];
    }

    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [dataArray removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:locationModel];
            }
            [tableview reloadData];
            [tableview headerEndRefreshing];
            
        }else if(result == 4){
            [dataArray removeAllObjects];
            [tableview reloadData];
            [tableview headerEndRefreshing];
        }else{
            [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
            [tableview headerEndRefreshing];
        }
    }];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    static int page = 0;
    page += 20;
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic;
    if ([self.methodType isEqualToString:@"getDynamicLocationByUser"])
    {
        dic = [self parametersForDic:self.methodType parameters:@{@"user":name,@"start":@"0",@"count":@"20"}];
    }else if([self.methodType isEqualToString:@"getDynamicLocationByCircle"])
    {
        dic = [self parametersForDic:self.methodType parameters:@{@"account":name,@"password":pass,@"start":@"0",@"count":@"20"}];
    }else if([self.methodType isEqualToString:@"getDynamicLocationByRelation"])
    {
        dic = [self parametersForDic:self.methodType parameters:@{@"account":name,@"password":pass,@"start":@"0",@"count":@"20"}];
    }

    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:locationModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    break;
                }
            }
            [tableview reloadData];
            [tableview footerEndRefreshing];
            
        }else if(result == 4){
            [tableview reloadData];
            [tableview footerEndRefreshing];
        }else{
            [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
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
