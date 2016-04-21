//
//  CircleTableViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CircleTableViewController.h"
#import "MJRefresh.h"
#import "LocationModel.h"
#import "LocationCell.h"
#import "LeftImgAndRightTitleBtn.h"
#import "PersonalViewController.h"
#import "ImageViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"
#import "DDMenuController.h"
#import "AppDelegate.h"

@interface CircleTableViewController ()<TableViewCellDelegates>

@end

@implementation CircleTableViewController
{
    NSMutableArray * dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationModel * locationModel = dataArray[indexPath.row];
    CGRect rect = [locationModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 15 - 20 - 8, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
    if ([locationModel.photos isEqualToString:@""]) {
        return rect.size.height + 144;
    }else{
        NSArray * photosArr = [locationModel.photos componentsSeparatedByString:@","];
        if (photosArr.count <= 3) {
            if (photosArr.count == 1) {
                return rect.size.height + 144 + 212;
            }
            return rect.size.height + 144 + 84;
        }else{
            return rect.size.height + 144 + 159;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell * cell = [LocationCell locationCellWithTaableView:tableView];
    LocationModel * locationModel = locationModel;
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
    //大图点击事件
    //cell.photoImg.tag = indexPath.row;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToZoom:)];
    //[cell.photoImg addGestureRecognizer:imageTap];
    return cell;
}

//点击进入个人中心
- (void)tapToLPersonal:(UITapGestureRecognizer *)tap
{
    LocationModel * locationModel = dataArray[tap.view.tag];
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    personalVC.nickname = personalVC.nickname;
    personalVC.account = locationModel.account;
    [self.navigationController pushViewController:personalVC animated:YES];
}

//点击缩放
- (void)tapToZoom:(UITapGestureRecognizer *)tap
{
    ImageViewController *imageVC = [[ImageViewController alloc] init];
    LocationModel * locationModel = dataArray[tap.view.tag];
    
    imageVC.imageUrl = locationModel.photos;
    [self.navigationController pushViewController:imageVC animated:YES];
    
}
- (void)viewreloadData
{
    [self.tableView reloadData];
}
#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

#pragma mark - 点赞
- (void)zanBtn:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel * locationModel = dataArray[sender.indexpath.row];
    LocationCell * cell = (LocationCell *)[self.tableView cellForRowAtIndexPath:sender.indexpath];
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

    dic = [self parametersForDic:@"getDynamicLocationByCircle" parameters:@{@"account":name,@"password":pass,@"start":@"0",@"count":@"20"}];

    __block UITableView *temTableView = self.tableView;
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
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            
        }else if(result == 4){
            [dataArray removeAllObjects];
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView headerEndRefreshing];
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
    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByRelation"parameters:@{@"account":name,@"password":pass,@"start":[NSString stringWithFormat:@"%d",page],@"count":@"20"}];
    

    dic = [self parametersForDic:@"getDynamicLocationByCircle"
                      parameters:@{@"account":name,@"password":pass,@"start":[NSString stringWithFormat:@"%d",page],@"count":@"20"}];
    

    __block UITableView *temTableView = self.tableView;
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
            [temTableView reloadData];
        }else if(result == 4){
            [temTableView reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView footerEndRefreshing];
        }
            [temTableView footerEndRefreshing];
    }];
}

@end
